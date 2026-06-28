import 'dart:convert';
import '../models/mentor_model.dart';
import 'api_client.dart';
import 'auth_service.dart';
import '../../core/utils/token_manager.dart';

class MentorService {
  
  /// Pobiera listę pracowników firmy i dla każdego dociąga statystyki ocen
  static Future<List<MentorModel>> fetchMentors() async {
    final token = await TokenManager.getToken();
    final currentUser = await AuthService.getCurrentUser();

    if (currentUser == null || currentUser.companyId == null) {
      return [];
    }

    final companyId = currentUser.companyId!;
    
    // 1. Pobranie pracowników firmy
    final response = await ApiClient.get(
      'companies/$companyId/users/',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) return [];
    
    final List<dynamic> usersData = jsonDecode(utf8.decode(response.bodyBytes));
    List<MentorModel> mentors = [];

    // 2. Dla każdego pracownika pobieramy zagregowane statystyki (średnia i liczba ocen)
    for (var userJson in usersData) {
      final String userId = userJson['user_id'].toString();
      final String role = userJson['role'] ?? 'Pracownik';
      
      double avgRating = 0.0;
      int reviewCount = 0;
      
      try {
        final statsResponse = await ApiClient.get(
          'api/ratings/mentor/$userId/stats/',
          headers: {'Authorization': 'Bearer $token'},
        );
        
        if (statsResponse.statusCode == 200) {
          final statsData = jsonDecode(utf8.decode(statsResponse.bodyBytes));
          avgRating = (statsData['average_rating'] as num?)?.toDouble() ?? 0.0;
          reviewCount = (statsData['total_ratings'] as num?)?.toInt() ?? 0;
        }
      } catch (e) {
        // Brak ocen lub błąd dla tego usera – zostawiamy z wartościami 0.0
      }

      mentors.add(MentorModel(
        id: userId,
        name: '${userJson['first_name']} ${userJson['last_name']}'.trim(),
        role: role,
        department: 'Firma', 
        rating: avgRating,
        reviewCount: reviewCount,
        activeTasksCount: 0, 
        expertise: ['Mentoring', 'Wdrożenie'], 
        avatar: null,
      ));
    }

    return mentors;
  }

  static Future<bool> assignMentor(String mentorId, String? taskTitle) async {
    // Logika przypisania zadań (będzie integrowana w module zadań HR)
    return true;
  }

  /// Przesyła nową ocenę na serwer
  static Future<bool> submitRating({
    required String mentorId,
    required int rating,
    required String comment,
    Map<String, int>? criteriaRatings,
    List<String>? tags,
  }) async {
    final token = await TokenManager.getToken();
    
    final response = await ApiClient.post(
      'api/ratings/',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        // Model MentorRating w Django oczekuje klucza obcego `mentor` oraz `rating` i `comment`
        'mentor': int.parse(mentorId), 
        'rating': rating,
        'comment': comment,
      }),
    );

    return response.statusCode == 201 || response.statusCode == 200;
  }
}