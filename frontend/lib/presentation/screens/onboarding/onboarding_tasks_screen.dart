import 'package:flutter/material.dart';

import '../../../core/constants/design_tokens.dart';
import '../../ui/app_card.dart';
import '../../ui/input.dart';
import '../../ui/stat_card.dart';

class OnboardingTask {
  final String id;
  final String title;
  final String description;

  final String status;
  final String priority;

  final String assignee;

  final String? mentor;
  final int? mentorRating;

  final String dueDate;
  final String? completedDate;

  final String category;
  final int progress;

  const OnboardingTask({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.assignee,
    this.mentor,
    this.mentorRating,
    required this.dueDate,
    this.completedDate,
    required this.category,
    required this.progress,
  });
}

class StatusInfo {
  final String label;
  final Color background;
  final Color textColor;
  final IconData icon;

  const StatusInfo({
    required this.label,
    required this.background,
    required this.textColor,
    required this.icon,
  });
}

class PriorityInfo {
  final String label;
  final Color background;
  final Color textColor;

  const PriorityInfo({
    required this.label,
    required this.background,
    required this.textColor,
  });
}

const statusConfig = {
  'pending': StatusInfo(
    label: 'Oczekuje',
    background: Tokens.gray100,
    textColor: Tokens.mutedForeground,
    icon: Icons.schedule,
  ),
  'in_progress': StatusInfo(
    label: 'W toku',
    background: Tokens.blue100,
    textColor: Tokens.blue700,
    icon: Icons.timelapse,
  ),
  'completed': StatusInfo(
    label: 'Ukończone',
    background: Tokens.green100,
    textColor: Tokens.green700,
    icon: Icons.check_circle,
  ),
  'overdue': StatusInfo(
    label: 'Przeterminowane',
    background: Color(0xFFFEE2E2),
    textColor: Colors.red,
    icon: Icons.warning_amber_rounded,
  ),
};

const priorityConfig = {
  'high': PriorityInfo(
    label: 'Wysoki',
    background: Color(0xFFFEE2E2),
    textColor: Colors.red,
  ),
  'medium': PriorityInfo(
    label: 'Średni',
    background: Color(0xFFFEF3C7),
    textColor: Color(0xFF92400E),
  ),
  'low': PriorityInfo(
    label: 'Niski',
    background: Tokens.gray100,
    textColor: Tokens.mutedForeground,
  ),
};

class OnboardingTasksScreen extends StatefulWidget {
  const OnboardingTasksScreen({super.key});

  @override
  State<OnboardingTasksScreen> createState() =>
      _OnboardingTasksScreenState();
}

class _OnboardingTasksScreenState
    extends State<OnboardingTasksScreen> {
  final searchController = TextEditingController();

  String selectedStatus = 'all';

  OnboardingTask? selectedTask;

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  final bool isHR = true;

  final List<OnboardingTask> tasks = const [
    OnboardingTask(
      id: '1',
      title: 'Konfiguracja środowiska deweloperskiego',
      description:
          'Zainstaluj i skonfiguruj wszystkie wymagane narzędzia: VS Code, Git, Docker, Node.js.',
      status: 'completed',
      priority: 'high',
      assignee: 'Jan Kowalski',
      mentor: 'Piotr Wiśniewski',
      mentorRating: 5,
      dueDate: '2024-01-10',
      completedDate: '2024-01-09',
      category: 'Techniczna',
      progress: 100,
    ),
    OnboardingTask(
      id: '2',
      title: 'Wprowadzenie do procesów firmowych',
      description:
          'Zapoznaj się z procedurami HR, systemem ticketów i workflow zespołu.',
      status: 'in_progress',
      priority: 'high',
      assignee: 'Jan Kowalski',
      mentor: 'Anna Nowak',
      dueDate: '2024-01-20',
      category: 'Procesy',
      progress: 60,
    ),
    OnboardingTask(
      id: '3',
      title: 'Szkolenie z bezpieczeństwa danych (RODO)',
      description:
          'Ukończ obowiązkowy kurs dotyczący ochrony danych osobowych.',
      status: 'in_progress',
      priority: 'high',
      assignee: 'Jan Kowalski',
      dueDate: '2024-01-15',
      category: 'Compliance',
      progress: 30,
    ),
    OnboardingTask(
      id: '4',
      title: 'Poznaj zespół i interesariuszy',
      description:
          'Umów spotkania 1:1 z kluczowymi osobami w organizacji.',
      status: 'pending',
      priority: 'medium',
      assignee: 'Jan Kowalski',
      dueDate: '2024-01-25',
      category: 'Integracja',
      progress: 0,
    ),
    OnboardingTask(
      id: '5',
      title: 'Przegląd dokumentacji projektu',
      description:
          'Przeczytaj dokumentację techniczną i architekturę aktualnych projektów.',
      status: 'overdue',
      priority: 'medium',
      assignee: 'Jan Kowalski',
      mentor: 'Tomasz Kowalczyk',
      dueDate: '2024-01-08',
      category: 'Techniczna',
      progress: 45,
    ),
    OnboardingTask(
      id: '6',
      title: 'First commit do repozytorium',
      description:
          'Wprowadź swoją pierwszą zmianę do projektu i przejdź przez proces code review.',
      status: 'pending',
      priority: 'low',
      assignee: 'Jan Kowalski',
      dueDate: '2024-02-01',
      category: 'Techniczna',
      progress: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (selectedTask != null) {
      return TaskDetailsView(
        task: selectedTask!,
        isHR: isHR,
        onBack: () {
          setState(() {
            selectedTask = null;
          });
        },
      );
    }

    final filteredTasks = tasks.where((task) {
      if (selectedStatus != 'all' &&
          task.status != selectedStatus) {
        return false;
      }

      if (searchController.text.isNotEmpty &&
          !task.title
              .toLowerCase()
              .contains(searchController.text.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();

    final completed = tasks
        .where((e) => e.status == 'completed')
        .length;

    final inProgress = tasks
        .where((e) => e.status == 'in_progress')
        .length;

    final overdue =
        tasks.where((e) => e.status == 'overdue').length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Zadania onboardingowe',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Tokens.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isHR
                      ? 'Zarządzaj zadaniami pracowników'
                      : 'Twoje zadania onboardingowe',
                  style: const TextStyle(
                    color: Tokens.textMuted2,
                  ),
                ),
              ],
            ),
            if (isHR)
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Nowe zadanie'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Tokens.blue,
                ),
              ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Wszystkich',
                value: tasks.length.toString(),
                icon: Icons.assignment,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'W toku',
                value: inProgress.toString(),
                icon: Icons.schedule,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Ukończonych',
                value: completed.toString(),
                icon: Icons.check_circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Przeterminowanych',
                value: overdue.toString(),
                icon: Icons.warning,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        AppInput(
          controller: searchController,
          hintText: 'Szukaj zadania...',
        ),

        const SizedBox(height: 16),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _statusChip('all', 'Wszystkie'),
            _statusChip('pending', 'Oczekuje'),
            _statusChip('in_progress', 'W toku'),
            _statusChip('completed', 'Ukończone'),
            _statusChip('overdue', 'Przeterminowane'),
          ],
        ),

        const SizedBox(height: 20),

        ...filteredTasks.map(
          (task) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TaskListCard(
              task: task,
              onTap: () {
                setState(() {
                  selectedTask = task;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusChip(
    String value,
    String label,
  ) {
    final selected = selectedStatus == value;

    return InkWell(
      onTap: () {
        setState(() {
          selectedStatus = value;
        });
      },
      borderRadius:
          BorderRadius.circular(Tokens.radiusLg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Tokens.blue
              : Tokens.surface,
          borderRadius:
              BorderRadius.circular(Tokens.radiusLg),
          border: Border.all(
            color: selected
                ? Tokens.blue
                : Tokens.gray200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Tokens.textMuted2,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class TaskListCard extends StatelessWidget {
  final OnboardingTask task;
  final VoidCallback onTap;

  const TaskListCard({
    super.key,
    required this.task,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = statusConfig[task.status]!;
    final priority = priorityConfig[task.priority]!;

    return InkWell(
      borderRadius:
          BorderRadius.circular(Tokens.radius2xl),
      onTap: onTap,
      child: AppCard(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _statusBadge(status),
                _priorityBadge(priority),
                _categoryBadge(task.category),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              task.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Tokens.textDark,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              task.description,
              style: const TextStyle(
                fontSize: 13,
                color: Tokens.textMuted2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            if (task.progress > 0 &&
                task.status != 'completed') ...[
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: task.progress / 100,
                        minHeight: 8,
                        backgroundColor:
                            Tokens.gray100,
                        color: Tokens.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${task.progress}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Tokens.textMuted2,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color:
                                Tokens.mutedForeground,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            task.dueDate,
                            style: const TextStyle(
                              fontSize: 12,
                              color:
                                  Tokens.mutedForeground,
                            ),
                          ),
                        ],
                      ),

                      if (task.mentor != null)
                        Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person_outline,
                              size: 14,
                              color: Tokens
                                  .mutedForeground,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              task.mentor!,
                              style:
                                  const TextStyle(
                                fontSize: 12,
                                color: Tokens
                                    .textMuted2,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right,
                  color: Tokens.mutedForeground,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(StatusInfo status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: status.background,
        borderRadius:
            BorderRadius.circular(Tokens.radiusLg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.icon,
            size: 14,
            color: status.textColor,
          ),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: status.textColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priorityBadge(
    PriorityInfo priority,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: priority.background,
        borderRadius:
            BorderRadius.circular(Tokens.radiusLg),
      ),
      child: Text(
        priority.label,
        style: TextStyle(
          color: priority.textColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _categoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Tokens.gray100,
        borderRadius:
            BorderRadius.circular(Tokens.radiusLg),
      ),
      child: Text(
        category,
        style: const TextStyle(
          fontSize: 11,
          color: Tokens.textMuted2,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class TaskDetailsView extends StatelessWidget {
  final OnboardingTask task;
  final bool isHR;
  final VoidCallback onBack;

  const TaskDetailsView({
    super.key,
    required this.task,
    required this.isHR,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final status = statusConfig[task.status]!;
    final priority = priorityConfig[task.priority]!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Powrót'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Tokens.textDark,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        LayoutBuilder(
          builder: (context, constraints) {
            final isWide =
                constraints.maxWidth > 1000;

            if (isWide) {
              return Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _mainContent(
                      status,
                      priority,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _detailsCard(),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _mainContent(
                  status,
                  priority,
                ),
                const SizedBox(height: 16),
                _detailsCard(),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _mainContent(
    StatusInfo status,
    PriorityInfo priority,
  ) {
    return Column(
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _statusBadge(status),
                  _priorityBadge(priority),
                  _categoryBadge(task.category),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                task.description,
                style: const TextStyle(
                  color: Tokens.textMuted2,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              if (task.status != 'completed')
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        const Text(
                          'Postęp',
                          style: TextStyle(
                            color:
                                Tokens.textMuted2,
                          ),
                        ),
                        Text(
                          '${task.progress}%',
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(
                              999),
                      child:
                          LinearProgressIndicator(
                        value:
                            task.progress / 100,
                        minHeight: 12,
                        color: Tokens.blue,
                        backgroundColor:
                            Tokens.gray100,
                      ),
                    ),
                  ],
                ),

              if (task.status == 'completed')
                Container(
                  padding:
                      const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Tokens.green100,
                    borderRadius:
                        BorderRadius.circular(
                      Tokens.radiusLg,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color:
                            Tokens.green700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Text(
                              'Zadanie ukończone',
                              style: TextStyle(
                                color: Tokens
                                    .green700,
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                            if (task.completedDate !=
                                null)
                              Text(
                                task.completedDate!,
                                style:
                                    const TextStyle(
                                  color: Tokens
                                      .green700,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _commentsCard(),
      ],
    );
  }

  Widget _detailsCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Szczegóły',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 16),

          _detailRow(
            'Przypisany do',
            task.assignee,
          ),

          const SizedBox(height: 12),

          _detailRow(
            'Termin',
            task.dueDate,
            valueColor:
                task.status == 'overdue'
                    ? Colors.red
                    : Tokens.textDark,
          ),

          const SizedBox(height: 12),

          _detailRow(
            'Kategoria',
            task.category,
          ),

          const SizedBox(height: 20),

          _mentorCard(),

          const SizedBox(height: 16),

          _actionButtons(),
        ],
      ),
    );
  }

  Widget _detailRow(
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Tokens.textMuted2,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color:
                valueColor ??
                Tokens.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(StatusInfo status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: status.background,
        borderRadius:
            BorderRadius.circular(
          Tokens.radiusLg,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.icon,
            size: 14,
            color: status.textColor,
          ),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: status.textColor,
              fontWeight:
                  FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priorityBadge(
    PriorityInfo priority,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: priority.background,
        borderRadius:
            BorderRadius.circular(
          Tokens.radiusLg,
        ),
      ),
      child: Text(
        'Priorytet: ${priority.label}',
        style: TextStyle(
          color: priority.textColor,
          fontWeight:
              FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _categoryBadge(
    String category,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Tokens.gray100,
        borderRadius:
            BorderRadius.circular(
          Tokens.radiusLg,
        ),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: Tokens.textMuted2,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _commentsCard() {
    final comments = [
      {
        'author': 'Anna Nowak',
        'time': '2 godz. temu',
        'text':
            'Świetna robota! Pamiętaj o konfiguracji zmiennych środowiskowych.',
      },
      {
        'author': 'Jan Kowalski',
        'time': '1 godz. temu',
        'text':
            'Gotowe, mam jeszcze pytanie odnośnie Docker Compose.',
      },
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                color: Tokens.blue,
              ),
              SizedBox(width: 8),
              Text(
                'Komentarze',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...comments.map(
            (comment) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Tokens.blue,
                      borderRadius:
                          BorderRadius.circular(999),
                    ),
                    child: Text(
                      comment['author']!
                          .substring(0, 1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Tokens.gray50,
                        borderRadius:
                            BorderRadius.circular(
                          Tokens.radiusLg,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              Text(
                                comment['author']!,
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                              Text(
                                comment['time']!,
                                style:
                                    const TextStyle(
                                  fontSize: 11,
                                  color: Tokens
                                      .mutedForeground,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            comment['text']!,
                            style:
                                const TextStyle(
                              color:
                                  Tokens.textMuted2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Expanded(
                child: AppInput(
                  hintText:
                      'Dodaj komentarz...',
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Tokens.blue,
                ),
                child:
                    const Text('Wyślij'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mentorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Tokens.gray50,
        borderRadius: BorderRadius.circular(
          Tokens.radiusLg,
        ),
        border: Border.all(
          color: Tokens.gray200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Mentor',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          if (task.mentor != null)
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      alignment:
                          Alignment.center,
                      decoration:
                          BoxDecoration(
                        color:
                            Tokens.purple100,
                        borderRadius:
                            BorderRadius
                                .circular(
                          999,
                        ),
                      ),
                      child: Text(
                        task.mentor!
                            .substring(0, 1),
                        style:
                            const TextStyle(
                          color:
                              Tokens.purple700,
                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            task.mentor!,
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                          const Text(
                            'Senior Developer',
                            style:
                                TextStyle(
                              color: Tokens
                                  .textMuted2,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (task.mentorRating != null)
                  Container(
                    padding:
                        const EdgeInsets.all(
                            12),
                    decoration:
                        BoxDecoration(
                      color: const Color(
                          0xFFFFFBEB),
                      borderRadius:
                          BorderRadius
                              .circular(
                        Tokens.radiusLg,
                      ),
                    ),
                    child: Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            size: 18,
                            color: index <
                                    task
                                        .mentorRating!
                                ? Colors.amber
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(
                            width: 8),
                        const Text(
                          'Oceniono',
                          style:
                              TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (task.status ==
                    'completed')
                  SizedBox(
                    width:
                        double.infinity,
                    child:
                        ElevatedButton(
                      onPressed: () {},
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            const Color(
                                0xFFFFFBEB),
                      ),
                      child: const Text(
                        '⭐ Oceń mentora',
                      ),
                    ),
                  )
                else if (isHR)
                  SizedBox(
                    width:
                        double.infinity,
                    child:
                        OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        'Zmień mentora',
                      ),
                    ),
                  ),
              ],
            )
          else
            Column(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 40,
                  color:
                      Tokens.mutedForeground,
                ),

                const SizedBox(height: 8),

                const Text(
                  'Brak przypisanego mentora',
                  style: TextStyle(
                    color:
                        Tokens.textMuted2,
                  ),
                ),

                if (isHR) ...[
                  const SizedBox(
                      height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          Tokens.blue,
                    ),
                    child: const Text(
                      'Przypisz mentora',
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    if (!isHR &&
        task.status != 'completed') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                Tokens.blue,
            padding:
                const EdgeInsets.symmetric(
              vertical: 14,
            ),
          ),
          child: const Text(
            'Oznacz jako ukończone',
          ),
        ),
      );
    }

    if (isHR) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text(
                'Edytuj zadanie',
              ),
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red.shade50,
                foregroundColor:
                    Colors.red,
              ),
              child: const Text(
                'Usuń zadanie',
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }
}