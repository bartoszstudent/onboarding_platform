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
  static Future<bool> createCourse(Map<String, dynamic> courseData) async {
    final token = await TokenManager.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/courses/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(courseData),
    );

    // Zwraca true, jeśli kurs (i cała jego zagnieżdżona struktura) został poprawnie utworzony (201 Created)
    if (response.statusCode == 201) {
      return true;
    } else {
      print('Błąd tworzenia kursu: ${response.body}');
      return false;
    }
  }
  static Future<List<Course>> fetchUserCourses(String userId) async {
    final token = await TokenManager.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/users/$userId/courses/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((e) => Course.fromJson(e)).toList();
    } else {
      throw Exception('Nie udało się pobrać kursów pracownika');
    }
  }
}
