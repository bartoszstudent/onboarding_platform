import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../../core/utils/token_manager.dart';
import '../models/user_model.dart';
import 'auth_state.dart';
import 'api_client.dart';

class AuthService {
  static const String _userKey = 'auth_user';

  /// Logowanie do backendu.
  ///
  /// Wysyła POST na endpoint Django:
  ///   POST /api/login/
  /// z body:
  ///   { "email": "...", "password": "..." }
  ///
  /// Oczekuje odpowiedzi:
  /// {
  ///   "token": "<string>",
  ///   "user": {
  ///     "id": 1,
  ///     "email": "user@example.com",
  ///     "first_name": "Jan",
  ///     "last_name": "Kowalski",
  ///     "username": "jan",
  ///     "role": "admin"
  ///   }
  /// }
  static Future<bool> login(String email, String password) async {
    try {
      final response = await ApiClient.post(
        'api/login/', // <-- ścieżka do Twojego Django
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        return false;
      }

      final Map<String, dynamic> decoded =
          jsonDecode(response.body) as Map<String, dynamic>;

      final token = decoded['token']?.toString();
      final userMap = decoded['user'] as Map<String, dynamic>?;

      if (token == null || userMap == null) {
        return false;
      }

      final user = UserModel.fromJson(userMap);

      // Zapis tokena
      await TokenManager.saveToken(token);

      // Zapis użytkownika w SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));

      AuthState.instance.notify();

      return true;
    } catch (_) {
      // W razie błędu sieci / parsowania traktujemy jako nieudane logowanie
      return false;
    }
  }

  /// Sprawdza, czy mamy zapisany token.
  static Future<bool> isLoggedIn() async {
    final token = await TokenManager.getToken();
    return token != null;
  }

  /// Zwraca aktualnie zalogowanego użytkownika (jeśli jest zapisany).
  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;

    try {
      final Map<String, dynamic> data =
          jsonDecode(raw) as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  /// Zwraca rolę aktualnego użytkownika ("admin", "user").
  static Future<String?> getRole() async {
    final token = await TokenManager.getToken();
    if (token != null) {
      try {
        // Dekodowanie tokena JWT i odczyt pola 'role'
        final payload = Jwt.parseJwt(token);
        if (payload.containsKey('role')) return payload['role'] as String;
      } catch (_) {
        // fallback: jeśli coś pójdzie nie tak, sprawdzamy usera w SharedPreferences
      }
    }
    final user = await getCurrentUser();
    return user?.role;
  }

  /// Wylogowuje użytkownika – usuwa token i dane usera.
  static Future<void> logout() async {
    await TokenManager.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);

    AuthState.instance.notify();
  }
}
