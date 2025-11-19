import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Tutaj w przyszłości możesz dodać np. inicjalizację Firebase lub SharedPreferences
  // np. await AuthService.init();

  runApp(const OnboardlyApp());
}
