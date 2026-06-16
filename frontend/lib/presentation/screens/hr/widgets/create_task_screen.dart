import 'package:flutter/material.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../ui/input.dart';
import '../../../ui/dropdown_menu.dart';
import '../../../ui/checkbox.dart';
import '../../../ui/label.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() =>
      _CreateTaskScreenState();
}

class _CreateTaskScreenState
    extends State<CreateTaskScreen> {
  final _titleController =
      TextEditingController();

  final _descriptionController =
      TextEditingController();

  String _category = 'Techniczna';
  String _priority = 'medium';

  DateTime? _dueDate;

  final Set<String> _selectedEmployees = {};

  final List<String> employees = const [
    'Jan Kowalski',
    'Marta Szymańska',
    'Krzysztof Nowicki',
    'Agata Wiśniewska',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(
            maxWidth: 600,
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    AppLabel(
                      'Nowe zadanie',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w600,
                            color: Tokens
                                .textPrimary,
                          ),
                    ),

                    const SizedBox(height: 20),

                    const AppLabel(
                      'Tytuł zadania',
                    ),

                    const SizedBox(height: 8),

                    AppInput(
                      controller:
                          _titleController,
                      hintText:
                          'Wpisz nazwę zadania...',
                      labelText:
                          'Tytuł zadania',
                    ),

                    const SizedBox(height: 16),

                    const AppLabel('Opis'),

                    const SizedBox(height: 8),

                    AppInput(
                      controller:
                          _descriptionController,
                      hintText:
                          'Opisz szczegóły zadania...',
                      labelText: 'Opis',
                      maxLines: 4,
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const AppLabel(
                                  'Kategoria'),

                              const SizedBox(
                                  height: 8),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration:
                                    BoxDecoration(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              12),
                                  border:
                                      Border.all(
                                    color: Tokens
                                        .gray200,
                                  ),
                                  color:
                                      Tokens.gray50,
                                ),
                                child:
                                    AppDropdown<
                                        String>(
                                  value:
                                      _category,
                                  items: const [
                                    DropdownMenuItem(
                                      value:
                                          'Techniczna',
                                      child: Text(
                                          'Techniczna'),
                                    ),
                                    DropdownMenuItem(
                                      value:
                                          'Compliance',
                                      child: Text(
                                          'Compliance'),
                                    ),
                                    DropdownMenuItem(
                                      value:
                                          'Integracja',
                                      child: Text(
                                          'Integracja'),
                                    ),
                                    DropdownMenuItem(
                                      value:
                                          'Raportowanie',
                                      child: Text(
                                          'Raportowanie'),
                                    ),
                                  ],
                                  onChanged:
                                      (value) {
                                    setState(() {
                                      _category =
                                          value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                            width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const AppLabel(
                                  'Priorytet'),

                              const SizedBox(
                                  height: 8),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration:
                                    BoxDecoration(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              12),
                                  border:
                                      Border.all(
                                    color: Tokens
                                        .gray200,
                                  ),
                                  color:
                                      Tokens.gray50,
                                ),
                                child:
                                    AppDropdown<
                                        String>(
                                  value:
                                      _priority,
                                  items: const [
                                    DropdownMenuItem(
                                      value:
                                          'high',
                                      child: Text(
                                          'Wysoki'),
                                    ),
                                    DropdownMenuItem(
                                      value:
                                          'medium',
                                      child: Text(
                                          'Średni'),
                                    ),
                                    DropdownMenuItem(
                                      value:
                                          'low',
                                      child: Text(
                                          'Niski'),
                                    ),
                                  ],
                                  onChanged:
                                      (value) {
                                    setState(() {
                                      _priority =
                                          value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const AppLabel('Termin'),

                    const SizedBox(height: 8),

                    OutlinedButton.icon(
                      onPressed: () async {
                        final date =
                            await showDatePicker(
                          context: context,
                          firstDate:
                              DateTime.now(),
                          lastDate:
                              DateTime(2030),
                          initialDate:
                              DateTime.now(),
                        );

                        if (date != null) {
                          setState(() {
                            _dueDate = date;
                          });
                        }
                      },
                      icon: const Icon(
                          Icons.calendar_today),
                      label: Text(
                        _dueDate == null
                            ? 'Wybierz termin'
                            : '${_dueDate!.day}.${_dueDate!.month}.${_dueDate!.year}',
                      ),
                    ),

                    const SizedBox(height: 16),

                    const AppLabel(
                      'Przypisz pracowników',
                    ),

                    const SizedBox(height: 8),

                    Container(
                      constraints:
                          const BoxConstraints(
                        maxHeight: 180,
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
                        children: employees
                            .map(
                              (employee) =>
                                  AppCheckbox(
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
                              ),
                            )
                            .toList(),
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
                            ),
                            child: const Text(
                              'Zapisz szkic',
                              style: TextStyle(
                                color:
                                    Colors.white,
                              ),
                            ),
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
                                  Colors.green,
                            ),
                            child: const Text(
                              'Opublikuj',
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
      ),
    );
  }
}