import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../data/services/auth_service.dart';
import '../../ui/input.dart';
import '../../ui/app_button.dart';
import '../../ui/app_card.dart';

class LoginScreenNew extends StatefulWidget {
  const LoginScreenNew({super.key});

  @override
  State<LoginScreenNew> createState() => _LoginScreenNewState();
}

class _LoginScreenNewState extends State<LoginScreenNew> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final ok = await AuthService.login(_email.text.trim(), _password.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      //context.go('/dashboard');
      context.go('/');
    } else {
      setState(() => _error = 'Nieprawidłowy email lub hasło');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 420,
          child: AppCard(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Onboardly',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 6),
                  Text('Zaloguj się do platformy',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Tokens.textMuted2)),
                  const SizedBox(height: 18),
                  const Text('Email', style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 6),
                  AppInput(
                    controller: _email,
                    hintText: 'twoj@email.com',
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Podaj email'
                        : (!v.contains('@') ? 'Nieprawidłowy email' : null),
                  ),
                  const SizedBox(height: 12),
                  const Text('Hasło', style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 6),
                  AppInput(
                    controller: _password,
                    hintText: '********',
                    obscureText: true,
                    validator: (v) => (v == null || v.length < 6)
                        ? 'Hasło musi mieć min. 6 znaków'
                        : null,
                  ),
                  const SizedBox(height: 18),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(_error!,
                          style: const TextStyle(color: Colors.red)),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: _loading ? () {} : _submit,
                      label: _loading ? 'Ładowanie...' : 'Zaloguj się',
                      primary: true,
                    ),
                  ),
                  // const SizedBox(height: 12),
                  // Container(
                  //   padding: const EdgeInsets.all(12),
                  //   decoration: BoxDecoration(
                  //     color: Tokens.gray50,
                  //     borderRadius: BorderRadius.circular(Tokens.radius),
                  //   ),
                  //   child: const Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: const [
                  //       Text('Demo login (dowolne hasło 6+ znaków):',
                  //           style: TextStyle(fontSize: 13)),
                  //       SizedBox(height: 6),
                  //       Text('• superadmin@test.com - Super Admin',
                  //           style: TextStyle(fontSize: 12)),
                  //       Text('• admin@test.com - Admin',
                  //           style: TextStyle(fontSize: 12)),
                  //       Text('• hr@test.com - HR',
                  //           style: TextStyle(fontSize: 12)),
                  //       Text('• employee@test.com - Employee',
                  //           style: TextStyle(fontSize: 12)),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
