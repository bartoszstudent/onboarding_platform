import 'dart:convert';
import '../../core/utils/token_manager.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    // symulacja api potem do wyrzucenia
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'admin@onboardly.com' && password == 'admin123') {
      final payload = base64Url.encode(
        utf8.encode(jsonEncode({'role': 'company_admin'})),
      );
      final token = 'header.$payload.signature';
      await TokenManager.saveToken(token);
      return true;
    } else if (email == 'super@onboardly.com' && password == 'super123') {
      final payload = base64Url.encode(
        utf8.encode(jsonEncode({'role': 'super_admin'})),
      );
      final token = 'header.$payload.signature';
      await TokenManager.saveToken(token);
      return true;
    } else if (email == 'hr@onboardly.com' && password == 'hr123') {
      final payload = base64Url.encode(utf8.encode(jsonEncode({'role': 'hr'})));
      final token = 'header.$payload.signature';
      await TokenManager.saveToken(token);
      return true;
    }
    return false;
  }

  static Future<String?> getRole() async {
    final token = await TokenManager.getToken();
    if (token == null) return null;
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      final payload = utf8.decode(base64Url.decode(parts[1]));
      final map = jsonDecode(payload);
      return map['role'] as String?;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> isLoggedIn() async {
    final token = await TokenManager.getToken();
    return token != null;
  }

  static Future<void> logout() async {
    await TokenManager.clearToken();
  }
}
