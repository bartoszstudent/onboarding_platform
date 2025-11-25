import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../ui/input.dart';
import '../../../ui/dropdown_menu.dart';
import '../../../ui/checkbox.dart';
import '../../../ui/label.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _role = 'employee';
  final Set<String> _selectedGroups = {}; // store group ids

  final List<Map<String, String>> _mockGroups = [
    {'id': 'g1', 'name': 'Frontend'},
    {'id': 'g2', 'name': 'Backend'},
    {'id': 'g3', 'name': 'Nowi pracownicy'},
    {'id': 'g4', 'name': 'HR'},
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLabel(
                    'Dodaj nowego użytkownika',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Tokens.textPrimary,
                        ),
                  ),

                  const SizedBox(height: 16),

                  // Name input
                  const AppLabel('Imię i nazwisko'),
                  const SizedBox(height: 8),
                  AppInput(
                    controller: _nameController,
                    hintText: 'Jan Kowalski',
                    labelText: 'Imię i nazwisko',
                  ),

                  const SizedBox(height: 12),

                  // Email input
                  const AppLabel('Email'),
                  const SizedBox(height: 8),
                  AppInput(
                    controller: _emailController,
                    hintText: 'jan.kowalski@firma.pl',
                    labelText: 'Email',
                  ),

                  const SizedBox(height: 12),

                  // Role dropdown
                  const AppLabel('Rola'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Tokens.gray200),
                      color: Tokens.gray50,
                    ),
                    child: AppDropdown<String>(
                      value: _role,
                      items: const [
                        DropdownMenuItem(value: 'employee', child: Text('Pracownik')),
                        DropdownMenuItem(value: 'hr', child: Text('HR')),
                        DropdownMenuItem(value: 'admin', child: Text('Administrator')),
                        DropdownMenuItem(value: 'superadmin', child: Text('Super Admin')),
                      ],
                      onChanged: (v) => setState(() => _role = v ?? 'employee'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Groups
                  const AppLabel('Grupy (opcjonalnie)'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Tokens.gray200),
                      color: Tokens.surface,
                    ),
                    constraints: const BoxConstraints(maxHeight: 160),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _mockGroups.length,
                      itemBuilder: (ctx, i) {
                        final g = _mockGroups[i];
                        final selected = _selectedGroups.contains(g['id']);
                        return AppCheckbox(
                          value: selected,
                          label: g['name'],
                          onChanged: (v) => setState(() {
                            if (v == true) {
                              _selectedGroups.add(g['id']!);
                            } else {
                              _selectedGroups.remove(g['id']);
                            }
                          }),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Tokens.gray50,
                            side: BorderSide(color: Tokens.gray200),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Anuluj', style: TextStyle(color: Tokens.textMuted2)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _addUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Tokens.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Dodaj użytkownika', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addUser() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proszę wypełnić wszystkie wymagane pola')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Użytkownik został (tylko w widoku) dodany')));
    Navigator.of(context).pop();
  }
}
