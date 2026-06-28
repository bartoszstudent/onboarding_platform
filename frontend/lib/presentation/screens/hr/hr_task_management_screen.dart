import 'package:flutter/material.dart';
import '../../../core/constants/design_tokens.dart';
import '../../ui/app_card.dart';
import '../../ui/input.dart';
import '../../ui/stat_card.dart';
import 'widgets/create_task_screen.dart';
import 'widgets/edit_task_screen.dart';
import 'widgets/assign_task_screen.dart';
import 'widgets/delete_task_screen.dart';
import '../../../data/services/onboarding_service.dart';

class OnboardingTask {
  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final List<String> assignedTo;
  final int completionRate;
  final String createdBy;
  final String createdAt;
  final String dueDate;
  final String category;
  final int progress;

  const OnboardingTask({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.assignedTo,
    required this.completionRate,
    required this.createdBy,
    required this.createdAt,
    required this.dueDate,
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
  'draft': StatusInfo(
    label: 'Szkic',
    background: Color(0xFFF1F5F9),
    textColor: Color(0xFF475569),
    icon: Icons.edit,
  ),
  'active': StatusInfo(
    label: 'Aktywne',
    background: Color(0xFFDBEAFE),
    textColor: Color(0xFF1D4ED8),
    icon: Icons.schedule,
  ),
  'completed': StatusInfo(
    label: 'Ukończone',
    background: Color(0xFFD1FAE5),
    textColor: Color(0xFF047857),
    icon: Icons.check_circle,
  ),
  'overdue': StatusInfo(
    label: 'Przeterminowane',
    background: Color(0xFFFEE2E2),
    textColor: Color(0xFFDC2626),
    icon: Icons.warning,
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

class HrTaskManagementScreen extends StatefulWidget {
  const HrTaskManagementScreen({super.key});

  @override
  State<HrTaskManagementScreen> createState() =>
      _HrTaskManagementScreenState();
}

class _HrTaskManagementScreenState extends State<HrTaskManagementScreen> {
  final searchController = TextEditingController();
  String selectedStatus = 'all';

  // State z API
  List<OnboardingTask> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => setState(() {}));
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final fetchedTasks = await OnboardingService().fetchHrTasks();
      if (mounted) {
        setState(() {
          tasks = fetchedTasks;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredTasks = tasks.where((task) {
      if (selectedStatus != 'all' && task.status != selectedStatus) {
        return false;
      }

      final query = searchController.text.toLowerCase();
      if (query.isNotEmpty && !task.title.toLowerCase().contains(query)) {
        return false;
      }

      return true;
    }).toList();

    final completed = tasks.where((e) => e.status == 'completed').length;
    final active = tasks.where((e) => e.status == 'active').length;
    final overdue = tasks.where((e) => e.status == 'overdue').length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        /// HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zarządzanie zadaniami HR',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Tokens.textDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Twórz i przypisuj zadania onboardingowe pracownikom',
                  style: TextStyle(color: Tokens.textMuted2),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => const CreateTaskScreen(), // Wymaga przekazania widoku
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Nowe zadanie'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Tokens.blue,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// STATS
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
                title: 'Aktywnych',
                value: active.toString(),
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

        /// SEARCH
        AppInput(
          controller: searchController,
          hintText: 'Szukaj zadania...',
        ),

        const SizedBox(height: 16),

        /// FILTERS
        Wrap(
          spacing: 8,
          children: [
            _chip('all', 'Wszystkie'),
            _chip('draft', 'Szkic'),
            _chip('active', 'Aktywne'),
            _chip('completed', 'Ukończone'),
            _chip('overdue', 'Przeterminowane'),
          ],
        ),

        const SizedBox(height: 20),

        /// TASKS
        ...filteredTasks.map(_taskCard),
      ],
    );
  }

  Widget _chip(String value, String label) {
    final selected = selectedStatus == value;

    return InkWell(
      onTap: () => setState(() => selectedStatus = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Tokens.blue : Tokens.surface,
          borderRadius: BorderRadius.circular(Tokens.radiusLg),
          border: Border.all(
            color: selected ? Tokens.blue : Tokens.gray200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : Tokens.textMuted2,
          ),
        ),
      ),
    );
  }

  Widget _taskCard(OnboardingTask task) {
    final status = statusConfig[task.status]!;
    final priority = priorityConfig[task.priority]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _statusBadge(task.status),
                      _priorityBadge(task.priority),
                      _categoryBadge(task.category),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Tokens.mutedForeground,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        // Wymaga dopasowania modelu w Twoim komponencie
                        break;
                      case 'assign':
                        break;
                      case 'delete':
                        break;
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edytuj'),
                    ),
                    PopupMenuItem(
                      value: 'assign',
                      child: Text('Przypisz'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Usuń'),
                    ),
                  ],
                ),
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Tokens.mutedForeground,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            task.dueDate,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Tokens.mutedForeground,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.group_outlined,
                            size: 14,
                            color: Tokens.mutedForeground,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Przypisano: ${task.assignedTo.join(", ")}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Tokens.textMuted2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final config = statusConfig[status]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: config.background,
        borderRadius: BorderRadius.circular(Tokens.radiusLg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 14, color: config.textColor),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: config.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priorityBadge(String priority) {
    final config = priorityConfig[priority]!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: config.background,
        borderRadius:
            BorderRadius.circular(Tokens.radiusLg),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          color: config.textColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _categoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Tokens.gray100,
        borderRadius: BorderRadius.circular(Tokens.radiusLg),
      ),
      child: Text(
        category,
        style: const TextStyle(
          fontSize: 11,
          color: Tokens.textMuted2,
        ),
      ),
    );
  }
}