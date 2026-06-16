import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../../core/utils/token_manager.dart';
import '../../presentation/screens/onboarding/onboarding_tasks_screen.dart';

class OnboardingService {
  Future<List<OnboardingTask>> fetchTasks() async {
    final token = await TokenManager.getToken();
    final response = await http.get(
      Uri.parse('${ApiEndpoints.base}/onboarding-tasks/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => OnboardingTask(
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
      throw Exception('Nie udało się załadować zadań');
    }
  }
}