import 'dart:convert';
import '../models/competency_model.dart';
import 'api_client.dart';
import 'auth_service.dart';
import '../../core/utils/token_manager.dart';

class CompetencyService {
  
  /// Pobiera kompetencje z API i mapuje zagnieżdżone w nich kursy 
  /// na umiejętności (Skills), sprawdzając jednocześnie postęp użytkownika.
  static Future<List<CompetencyPath>> getPaths() async {
    final token = await TokenManager.getToken();
    final currentUser = await AuthService.getCurrentUser();

    // 1. Pobieramy wszystkie kompetencje wraz z obiektami kursów
    final compResponse = await ApiClient.get(
      'api/competencies/',
      headers: {'Authorization': 'Bearer $token'},
    );

    // 2. Pobieramy postępy (CourseAssignments), aby wiedzieć, co użytkownik już ukończył
    final assignResponse = await ApiClient.get(
      'api/course-assignments/',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (compResponse.statusCode == 200) {
      final List<dynamic> compData = jsonDecode(utf8.decode(compResponse.bodyBytes));

      // Filtrujemy przypisania tylko dla zalogowanego usera
      List<dynamic> userAssignments = [];
      if (assignResponse.statusCode == 200 && currentUser != null) {
        final List<dynamic> allAssignments = jsonDecode(utf8.decode(assignResponse.bodyBytes));
        userAssignments = allAssignments
            .where((a) => a['user'].toString() == currentUser.id.toString())
            .toList();
      }

      return compData.map((json) {
        final courses = json['courses'] as List<dynamic>? ?? [];
        int completedSkills = 0;
        int totalEarnedXp = 0;

        // Mapowanie każdego kursu wewnątrz kompetencji na obiekt Skill
        final skills = courses.map((course) {
          final courseId = course['id'];
          
          // Szukamy, czy użytkownik ma przypisany ten konkretny kurs
          final assignment = userAssignments.where((a) => a['course'] == courseId).firstOrNull;

          bool isCompleted = false;
          int progress = 0;

          if (assignment != null) {
            final status = assignment['status']?.toString().toLowerCase() ?? '';
            if (status == 'completed' || status.contains('100')) {
              isCompleted = true;
              progress = 100;
            } else if (status.contains('%')) {
              // Wyciągamy procenty ze stringa "X% complete"
              final match = RegExp(r'\d+').firstMatch(status);
              if (match != null) {
                progress = int.tryParse(match.group(0) ?? '0') ?? 0;
              }
            }
          }

          if (isCompleted) {
            completedSkills++;
            totalEarnedXp += 250; // Przydzielamy po 250 XP za każdy ukończony kurs w ścieżce
          }

          return Skill(
            name: course['title'] ?? 'Nieznany kurs',
            isCompleted: isCompleted,
            xp: 250, 
            level: 'Z bazy danych',
            progress: progress,
          );
        }).toList();

        final totalSkills = skills.length;
        final overallProgress = totalSkills > 0 ? ((completedSkills / totalSkills) * 100).toInt() : 0;

        return CompetencyPath(
          id: json['id'].toString(),
          name: json['name'] ?? 'Brak nazwy kompetencji',
          description: json['description'] ?? 'Brak opisu',
          category: 'Kariera', // Możesz w przyszłości dodać to pole do backendu
          totalSkills: totalSkills,
          completedSkills: completedSkills,
          progress: overallProgress,
          earnedXp: totalEarnedXp,
          totalXp: totalSkills * 250,
          estimatedHours: totalSkills * 2, // Szacujemy 2h na każdy przypisany kurs
          skills: skills,
        );
      }).toList();
    } else {
      throw Exception('Nie udało się pobrać map kompetencji z serwera');
    }
  }
  static Future<Map<String, dynamic>> fetchGamificationAnalytics() async {
    final token = await TokenManager.getToken();
    final response = await ApiClient.get(
      'api/gamification/analytics/',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Nie udało się pobrać danych analitycznych grywalizacji.');
    }
  }
}