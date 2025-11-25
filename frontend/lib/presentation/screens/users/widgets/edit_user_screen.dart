import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../ui/input.dart';
import '../../../ui/dropdown_menu.dart';
import '../../../ui/checkbox.dart';
import '../../../ui/label.dart';

class EditUserScreen extends StatefulWidget {
  final Map<String, dynamic> user; 

  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late String _role;
  late String _status;
  final Set<String> _selectedGroups = {};

  final List<Map<String, String>> _mockGroups = [
    {'id': 'g1', 'name': 'Frontend'},
    {'id': 'g2', 'name': 'Backend'},
    {'id': 'g3', 'name': 'Nowi pracownicy'},
    {'id': 'g4', 'name': 'HR'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user['name']);
    _emailController = TextEditingController(text: widget.user['email']);
    _role = widget.user['role'] ?? 'employee';
    _status = widget.user['status'] ?? 'aktywny';
    if (widget.user['groups'] != null) {
      _selectedGroups.addAll(List<String>.from(widget.user['groups']));
    }
  }

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
                    'Edytuj użytkownika',
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

                  // Status dropdown
                  const AppLabel('Status'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Tokens.gray200),
                      color: Tokens.gray50,
                    ),
                    child: AppDropdown<String>(
                      value: _status,
                      items: const [
                        DropdownMenuItem(value: 'aktywny', child: Text('Aktywny')),
                        DropdownMenuItem(value: 'nieaktywny', child: Text('Nieaktywny')),
                      ],
                      onChanged: (v) => setState(() => _status = v ?? 'aktywny'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Groups
                  const AppLabel('Grupy'),
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

                  // Akcje
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Tokens.gray50,
                            side: BorderSide(color: Tokens.gray200),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Anuluj', style: TextStyle(color: Tokens.textMuted2)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Tokens.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Zapisz zmiany', style: TextStyle(color: Colors.white)),
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

  void _saveUser() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proszę wypełnić wszystkie wymagane pola')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Użytkownik zaktualizowany')),
    );

    Navigator.of(context).pop();
  }
}
