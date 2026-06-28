import 'package:flutter/material.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../ui/dropdown_menu.dart';
import '../../../ui/label.dart';
import '../hr_task_management_screen.dart';
import '../../../../data/services/onboarding_service.dart';

class AssignTaskScreen extends StatefulWidget {
  final OnboardingTask task;

  const AssignTaskScreen({super.key, required this.task});

  @override
  State<AssignTaskScreen> createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  final OnboardingService _service = OnboardingService();
  List<Map<String, dynamic>> employees = [];
  bool isLoading = true;
  bool isSubmitting = false;
  String? _selectedMentorId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final e = await _service.fetchCompanyUsers();
      if (mounted) {
        setState(() {
          employees = e;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _submit() async {
    if (_selectedMentorId == null) return;
    setState(() => isSubmitting = true);
    
    final success = await _service.assignMentorToTask(
      widget.task.id, 
      int.parse(_selectedMentorId!)
    );
    
    if (mounted) {
      Navigator.pop(context, success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: isLoading 
                ? const SizedBox(height: 150, child: Center(child: CircularProgressIndicator()))
                : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLabel(
                    'Zarządzaj opieką merytoryczną',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Zadanie: ${widget.task.title}',
                    style: const TextStyle(fontSize: 13, color: Tokens.textMuted2),
                  ),
                  const SizedBox(height: 24),

                  const AppLabel('Wybierz mentora dla tego zadania'),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Tokens.gray200),
                      color: Tokens.gray50,
                    ),
                    child: AppDropdown<String>(
                      value: _selectedMentorId,
                      items: employees.map((emp) => DropdownMenuItem(
                        value: emp['user_id'].toString(),
                        child: Text('${emp['first_name']} ${emp['last_name']}'),
                      )).toList(),
                      onChanged: (value) => setState(() => _selectedMentorId = value),
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
                            : const Text('Zapisz mentora', style: TextStyle(color: Colors.white)),
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