import '../../data/services/auth_service.dart';

class LoginUser {
  Future<bool> call(String email, String password) async {
    return await AuthService.login(email, password);
  }
}
