import 'package:flutter/foundation.dart';

class AuthState extends ChangeNotifier {
  static final AuthState instance = AuthState._internal();
  AuthState._internal();

  void notify() {
    notifyListeners();
  }
}
