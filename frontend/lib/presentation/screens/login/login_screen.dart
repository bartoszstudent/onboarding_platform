import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/auth_service.dart';
import '../../ui/input.dart';
import '../../ui/app_button.dart';
import '../../ui/app_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final success = await AuthService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      // Po zalogowaniu przechodzimy bezpośrednio do dashboardu
      context.go('/dashboard');
    } else {
      setState(() => _error = "Nieprawidłowy email lub hasło");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: AppCard(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Onboardly",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    controller: _emailController,
                    labelText: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Podaj email';
                      if (!value.contains('@')) {
                        return 'Nieprawidłowy format emaila';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppInput(
                    controller: _passwordController,
                    labelText: 'Hasło',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Hasło musi mieć min. 6 znaków';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: _isLoading ? () {} : _login,
                      label: _isLoading ? 'Ładowanie...' : 'Zaloguj się',
                      primary: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
