import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../../core/utils/token_manager.dart';
import '../../presentation/screens/onboarding/onboarding_tasks_screen.dart' as emp;
import '../../presentation/screens/hr/hr_task_management_screen.dart' as hr;
import '../../../data/services/auth_service.dart';

class OnboardingService {
  
  /// 1. Pobieranie instancji zadań dla widoku Pracownika
  Future<List<emp.OnboardingTask>> fetchTasks() async {
    final token = await TokenManager.getToken();
    final response = await http.get(
      Uri.parse('${ApiEndpoints.base}/onboarding-tasks/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Używamy utf8.decode do obsługi polskich znaków
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => emp.OnboardingTask(
        id: json['id'].toString(),
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        status: json['status'] ?? 'pending',
        priority: json['priority'] ?? 'medium',
        assignee: json['assignee_name'] ?? 'Brak pracownika',
        mentor: json['mentor_name'],
        dueDate: json['due_date'] ?? 'Brak terminu',
        completedDate: json['completed_date'],
        category: json['category'] ?? 'Ogólne',
        progress: json['progress'] ?? 0,
      )).toList();
    } else {
      throw Exception('Nie udało się załadować zadań pracownika');
    }
  }

  /// 2. Pobieranie pełnej listy instancji i szablonów dla panelu zarządzania HR
  Future<List<hr.OnboardingTask>> fetchHrTasks() async {
    final token = await TokenManager.getToken();
    
    // Pobieramy zadania z /api/onboarding-tasks/ i mapujemy je dla HR
    final response = await http.get(
      Uri.parse('${ApiEndpoints.base}/onboarding-tasks/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      
      return data.map((json) {
        // Tłumaczenie backendowych statusów na te, które obsługuje widget w HR
        String beStatus = json['status'] ?? 'pending';
        String hrStatus = 'draft';
        
        if (beStatus == 'completed') hrStatus = 'completed';
        else if (beStatus == 'overdue') hrStatus = 'overdue';
        else if (beStatus == 'pending' || beStatus == 'in_progress') hrStatus = 'active';

        return hr.OnboardingTask(
          id: json['id'].toString(),
          title: json['title'] ?? 'Zadanie Onboardingowe',
          description: json['description'] ?? 'Brak opisu',
          status: hrStatus,
          priority: json['priority'] ?? 'medium',
          assignedTo: [json['assignee_name'] ?? 'Nieprzypisane'],
          completionRate: json['progress'] ?? 0,
          createdBy: 'Panel HR',
          createdAt: 'Z systemu',
          dueDate: json['due_date'] ?? 'Brak terminu',
          category: json['category'] ?? 'Wdrożenie',
          progress: json['progress'] ?? 0,
        );
      }).toList();
    } else {
      throw Exception('Błąd pobierania zadań dla HR z serwera');
    }
  }
  // Upewnij się, że masz te importy na górze pliku:
// import '../../../data/services/auth_service.dart';

  // --- Nowe metody do zaawansowanego zarządzania Onboardingiem ---

  /// Pobiera listę gotowych szablonów z bazy danych
  Future<List<Map<String, dynamic>>> fetchTemplates() async {
    final token = await TokenManager.getToken();
    final response = await http.get(
      Uri.parse('${ApiEndpoints.base}/onboarding-templates/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    return [];
  }

  /// Pobiera listę pracowników z firmy
  Future<List<Map<String, dynamic>>> fetchCompanyUsers() async {
    final token = await TokenManager.getToken();
    final currentUser = await AuthService.getCurrentUser();
    if (currentUser == null || currentUser.companyId == null) return [];

    final response = await http.get(
      Uri.parse('${ApiEndpoints.base}/companies/${currentUser.companyId}/users/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    return [];
  }

  /// Rozpoczyna nowy proces wdrożeniowy dla wybranych pracowników na podstawie szablonu
  Future<bool> startOnboardingProcess(int templateId, List<int> userIds) async {
    final token = await TokenManager.getToken();
    bool success = true;
    for (int userId in userIds) {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.base}/onboardings/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'template': templateId,
          'user': userId,
          'status': 'in_progress', // Backend z automatu stworzy 'pending' dla instancji zadań
        }),
      );
      if (response.statusCode != 201) success = false;
    }
    return success;
  }

  /// Zmienia mentora wewnątrz konkretnej instancji zadania pracownika
  Future<bool> assignMentorToTask(String taskId, int mentorId) async {
    final token = await TokenManager.getToken();
    final response = await http.patch(
      Uri.parse('${ApiEndpoints.base}/onboarding-tasks/$taskId/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'mentor_user': mentorId}),
    );
    return response.statusCode == 200;
  }
}