import 'dart:convert';
import '../models/quiz_model.dart';
import 'api_client.dart';
import '../../core/utils/token_manager.dart';

class QuizService {
  
  /// Pobiera listę pytań i odpowiedzi dla danego kursu
  static Future<Quiz> fetchQuizForCourse(int courseId) async {
    final token = await TokenManager.getToken();
    final response = await ApiClient.get(
      'api/courses/$courseId/quiz/',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return Quiz.fromJson(data);
    } else {
      throw Exception('Nie udało się pobrać quizu dla tego kursu.');
    }
  }

  /// Przesyła ID zaznaczonych odpowiedzi do oceny przez serwer
  static Future<QuizResult> submitQuiz(
      int quizId, List<int> submittedAnswerIds) async {
    final token = await TokenManager.getToken();
    final response = await ApiClient.post(
      'api/quizzes/$quizId/submit/',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'submitted_answer_ids': submittedAnswerIds,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return QuizResult.fromJson(data);
    } else {
      throw Exception('Nie udało się ocenić quizu. Spróbuj ponownie.');
    }
  }
}