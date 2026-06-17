import 'package:flutter/material.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../ui/dropdown_menu.dart';
import '../../../ui/checkbox.dart';
import '../../../ui/label.dart';
import '../../../../data/services/onboarding_service.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final OnboardingService _service = OnboardingService();
  
  List<Map<String, dynamic>> templates = [];
  List<Map<String, dynamic>> employees = [];
  bool isLoading = true;
  
  String? _selectedTemplateId;
  final Set<int> _selectedEmployeeIds = {};
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final t = await _service.fetchTemplates();
      final e = await _service.fetchCompanyUsers();
      
      if (mounted) {
        setState(() {
          templates = t;
          employees = e;
          if (templates.isNotEmpty) {
            _selectedTemplateId = templates.first['id'].toString();
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _submit() async {
    if (_selectedTemplateId == null || _selectedEmployeeIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wybierz szablon i co najmniej jednego pracownika')),
      );
      return;
    }
    
    setState(() => isSubmitting = true);
    
    final success = await _service.startOnboardingProcess(
      int.parse(_selectedTemplateId!),
      _selectedEmployeeIds.toList(),
    );
    
    if (mounted) {
      Navigator.pop(context, success); // Możesz nasłuchiwać tego wyniku w głównym oknie i przeładować listę
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: isLoading 
                ? const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()))
                : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLabel(
                    'Uruchom program wdrożeniowy',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Zamiast dodawać pojedyncze zadania, wybierz szablon. System automatycznie wygeneruje i przypisze odpowiednie kroki pracownikom.',
                    style: TextStyle(color: Tokens.textMuted2, fontSize: 13),
                  ),
                  const SizedBox(height: 24),

                  const AppLabel('Wybierz szablon onboardingu'),
                  const SizedBox(height: 8),
                  
                  if (templates.isEmpty)
                    const Text('Brak szablonów w bazie Django.', style: TextStyle(color: Colors.red))
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Tokens.gray200),
                        color: Tokens.gray50,
                      ),
                      child: AppDropdown<String>(
                        value: _selectedTemplateId,
                        items: templates.map((t) => DropdownMenuItem(
                          value: t['id'].toString(),
                          child: Text(t['name']),
                        )).toList(),
                        onChanged: (value) => setState(() => _selectedTemplateId = value),
                      ),
                    ),

                  const SizedBox(height: 20),
                  const AppLabel('Przypisz pracowników do ścieżki'),
                  const SizedBox(height: 8),

                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Tokens.gray200),
                    ),
                    child: employees.isEmpty
                      ? const Padding(padding: EdgeInsets.all(16), child: Text('Brak pracowników w firmie'))
                      : ListView(
                      shrinkWrap: true,
                      children: employees.map((emp) {
                        final empId = emp['user_id'] as int;
                        final empName = '${emp['first_name']} ${emp['last_name']}';
                        return AppCheckbox(
                          value: _selectedEmployeeIds.contains(empId),
                          label: empName,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedEmployeeIds.add(empId);
                              } else {
                                _selectedEmployeeIds.remove(empId);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Anuluj'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Tokens.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: isSubmitting 
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Uruchom', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
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