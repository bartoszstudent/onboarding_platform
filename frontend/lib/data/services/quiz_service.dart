import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_model.dart';
import '../../core/utils/token_manager.dart';

class QuizService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<Quiz> fetchQuizForCourse(int courseId) async {
    final token = await TokenManager.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/courses/$courseId/quiz/'), // endpoint Django
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Quiz.fromJson(data); // Quiz.fromJson powinien pasować do QuizDetailSerializer
    } else {
      throw Exception('Nie udało się pobrać quizu');
    }
  }
}
