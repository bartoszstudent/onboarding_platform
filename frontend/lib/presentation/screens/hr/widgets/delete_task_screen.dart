import 'package:flutter/material.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../ui/label.dart';
import '../hr_task_management_screen.dart';

class DeleteTaskScreen extends StatelessWidget {
  final OnboardingTask task;

  const DeleteTaskScreen({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 450,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  AppLabel(
                    'Usuń zadanie',
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

                  const SizedBox(height: 16),

                  const Text(
                    'Czy na pewno chcesz usunąć poniższe zadanie?',
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          Tokens.textMuted2,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(
                            16),
                    decoration:
                        BoxDecoration(
                      color:
                          Tokens.gray50,
                      borderRadius:
                          BorderRadius.circular(
                              12),
                      border: Border.all(
                        color:
                            Tokens.gray200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          task.title,
                          style:
                              const TextStyle(
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w600,
                            color: Tokens
                                .textPrimary,
                          ),
                        ),

                        const SizedBox(
                            height: 6),

                        Text(
                          task.description,
                          maxLines: 2,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                          style:
                              const TextStyle(
                            fontSize: 13,
                            color: Tokens
                                .textMuted2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(
                            12),
                    decoration:
                        BoxDecoration(
                      color: const Color(
                          0xFFFEE2E2),
                      borderRadius:
                          BorderRadius.circular(
                              12),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.warning_amber,
                          color:
                              Colors.red,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tej operacji nie można cofnąć.',
                            style:
                                TextStyle(
                              fontSize:
                                  13,
                              color: Colors
                                  .red,
                            ),
                          ),
                        ),
                      ],
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
                                Colors.red,
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              vertical: 14,
                            ),
                          ),
                          child: const Text(
                            'Usuń',
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