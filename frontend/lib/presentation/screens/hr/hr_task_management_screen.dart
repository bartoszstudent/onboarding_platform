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
  final Color color;

  const PriorityInfo({
    required this.label,
    required this.color,
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
    color: Color(0xFFDC2626),
  ),
  'medium': PriorityInfo(
    label: 'Średni',
    color: Color(0xFFD97706),
  ),
  'low': PriorityInfo(
    label: 'Niski',
    color: Color(0xFF64748B),
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

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  final List<OnboardingTask> tasks = const [
    OnboardingTask(
      id: '1',
      title: 'Konfiguracja środowiska deweloperskiego',
      description: 'Instalacja i konfiguracja VS Code, Git, Docker i Node.js.',
      status: 'active',
      priority: 'high',
      assignedTo: ['Jan Kowalski', 'Marta Szymańska'],
      completionRate: 75,
      createdBy: 'Anna Nowak',
      createdAt: '2024-01-01',
      dueDate: '2024-01-20',
      category: 'Techniczna',
      progress: 75,
    ),
    OnboardingTask(
      id: '2',
      title: 'Szkolenie RODO',
      description: 'Obowiązkowe szkolenie z ochrony danych osobowych.',
      status: 'overdue',
      priority: 'high',
      assignedTo: ['Jan Kowalski', 'Marta Szymańska', 'Krzysztof Nowicki'],
      completionRate: 33,
      createdBy: 'Anna Nowak',
      createdAt: '2023-12-20',
      dueDate: '2024-01-15',
      category: 'Compliance',
      progress: 33,
    ),
    OnboardingTask(
      id: '3',
      title: 'Spotkania integracyjne',
      description: '1:1 spotkania z członkami zespołu.',
      status: 'active',
      priority: 'medium',
      assignedTo: ['Jan Kowalski'],
      completionRate: 50,
      createdBy: 'Piotr Wiśniewski',
      createdAt: '2024-01-05',
      dueDate: '2024-02-01',
      category: 'Integracja',
      progress: 50,
    ),
    OnboardingTask(
      id: '4',
      title: 'Przegląd polityki bezpieczeństwa',
      description: 'Zapoznanie się z polityką IT firmy.',
      status: 'draft',
      priority: 'medium',
      assignedTo: ['Marta Szymańska', 'Krzysztof Nowicki'],
      completionRate: 0,
      createdBy: 'Anna Nowak',
      createdAt: '2024-01-10',
      dueDate: '2024-01-30',
      category: 'Compliance',
      progress: 0,
    ),
    OnboardingTask(
      id: '5',
      title: 'Prezentacja 30-dniowa',
      description: 'Prezentacja pierwszych obserwacji pracy.',
      status: 'completed',
      priority: 'low',
      assignedTo: ['Jan Kowalski', 'Marta Szymańska'],
      completionRate: 100,
      createdBy: 'Piotr Wiśniewski',
      createdAt: '2023-12-15',
      dueDate: '2024-02-15',
      category: 'Raportowanie',
      progress: 100,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    final filteredTasks = (tasks).where((task) {
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
                  'Zadania onboardingowe',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Tokens.textDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Zarządzaj zadaniami pracowników',
                  style: TextStyle(color: Tokens.textMuted2),
                ),
              ],
            ),
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
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            children: [
              _statusBadge(task.status),
              _priorityBadge(task.priority),
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: Tokens.textMuted2,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Text(
                  '${task.assignedTo.length} osób • ${task.assignedTo.take(2).join(', ')}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Tokens.textMuted2,
                  ),
                ),
              ),
              Text(
                task.dueDate,
                style: const TextStyle(
                  fontSize: 12,
                  color: Tokens.mutedForeground,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          LinearProgressIndicator(
            value: task.completionRate / 100,
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        'Priorytet: ${config.label}',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: config.color,
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