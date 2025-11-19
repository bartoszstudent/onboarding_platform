import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/token_manager.dart';
import '../../core/constants/api_endpoints.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse(ApiEndpoints.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        await TokenManager.saveToken(data['token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // 🔹 Brak backendu? → fallback testowy:
      if (email == "admin@onboardly.com" && password == "admin123") {
        await TokenManager.saveToken("mock-token-123");
        return true;
      }
      return false;
    }
  }
}
