import 'dart:convert';
import '../../core/utils/token_manager.dart';

class AuthService {
  // Demo users shown in `login_screen_new.dart` (all use password '123123')
  static const Map<String, String> _demoUsers = {
    'superadmin@test.com': 'super_admin',
    'admin@test.com': 'company_admin',
    'hr@test.com': 'hr',
    'employee@test.com': 'employee',
  };

  static Future<bool> login(String email, String password) async {
    // simulate API latency (mock)
    await Future.delayed(const Duration(seconds: 1));

    // Accept demo users with a single shared password '123123'
    final role = _demoUsers[email];
    if (role != null && password == '123123') {
      final payload = base64Url.encode(utf8.encode(jsonEncode({'role': role})));
      final token = 'header.$payload.signature';
      await TokenManager.saveToken(token);
      return true;
    }

    // Keep backward-compatible hardcoded check (optional)
    if (email == 'admin@onboardly.com' && password == 'admin123') {
      final payload = base64Url.encode(
        utf8.encode(jsonEncode({'role': 'company_admin'})),
      );
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
