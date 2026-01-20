import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_model.dart';
import '../../core/utils/token_manager.dart';


class CourseService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<List<Course>> fetchCourses() async {
    final token = await TokenManager.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/courses/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Course.fromJson(e)).toList();
    } else {
      throw Exception('Nie udało się pobrać kursów');
    }
  }
}
