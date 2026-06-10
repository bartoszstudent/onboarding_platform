import 'package:flutter/material.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../ui/checkbox.dart';
import '../../../ui/label.dart';
import '../hr_task_management_screen.dart';

class AssignTaskScreen extends StatefulWidget {
  final OnboardingTask task;

  const AssignTaskScreen({
    super.key,
    required this.task,
  });

  @override
  State<AssignTaskScreen> createState() =>
      _AssignTaskScreenState();
}

class _AssignTaskScreenState
    extends State<AssignTaskScreen> {
  final Set<String> _selectedEmployees = {};

  final List<String> employees = const [
    'Jan Kowalski',
    'Marta Szymańska',
    'Krzysztof Nowicki',
    'Agata Wiśniewska',
    'Tomasz Nowak',
    'Karolina Wiśniewska',
  ];

  @override
  void initState() {
    super.initState();

    _selectedEmployees.addAll(
      widget.task.assignedTo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(
            maxWidth: 500,
          ),
          child: Material(
            borderRadius:
                BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            elevation: 8,
            child: Padding(
              padding:
                  const EdgeInsets.all(20),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  AppLabel(
                    'Przypisz pracowników',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              Tokens.textPrimary,
                        ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.task.title,
                    style: const TextStyle(
                      fontSize: 13,
                      color:
                          Tokens.textMuted2,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    constraints:
                        const BoxConstraints(
                      maxHeight: 300,
                    ),
                    decoration:
                        BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(
                              12),
                      border: Border.all(
                        color:
                            Tokens.gray200,
                      ),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: employees.map(
                        (employee) {
                          return AppCheckbox(
                            value:
                                _selectedEmployees
                                    .contains(
                              employee,
                            ),
                            label:
                                employee,
                            onChanged:
                                (value) {
                              setState(() {
                                if (value ==
                                    true) {
                                  _selectedEmployees
                                      .add(
                                          employee);
                                } else {
                                  _selectedEmployees
                                      .remove(
                                          employee);
                                }
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(
                            12),
                    decoration:
                        BoxDecoration(
                      color:
                          Tokens.gray50,
                      borderRadius:
                          BorderRadius.circular(
                              12),
                    ),
                    child: Text(
                      'Wybrano ${_selectedEmployees.length} pracowników',
                      style: const TextStyle(
                        fontSize: 13,
                        color:
                            Tokens.textMuted2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child:
                            OutlinedButton(
                          onPressed: () {
                            Navigator.pop(
                                context);
                          },
                          style:
                              OutlinedButton
                                  .styleFrom(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              vertical: 14,
                            ),
                          ),
                          child: const Text(
                              'Anuluj'),
                        ),
                      ),

                      const SizedBox(
                          width: 12),

                      Expanded(
                        child:
                            ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                                context);
                          },
                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                Tokens.blue,
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              vertical: 14,
                            ),
                          ),
                          child: const Text(
                            'Zapisz',
                            style: TextStyle(
                              color:
                                  Colors.white,
                            ),
                          ),
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