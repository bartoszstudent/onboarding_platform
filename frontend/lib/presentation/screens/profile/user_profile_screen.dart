import 'package:flutter/material.dart';
import '../../../core/constants/design_tokens.dart';
import '../../ui/app_card.dart';
import '../../ui/avatar.dart';
import '../../components/widgets/course_progress_bar.dart';
import '../../../data/models/badge_list_item.dart';
import '../../components/widgets/badge_card.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/badge_service.dart';
import '../../../data/models/badge_model.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserModel? user;
  bool loading = true;
  List<BadgeListItem> badges = [];

  static const roleLabels = {
    'super-admin': 'Super Administrator',
    'admin': 'Administrator',
    'hr': 'HR Manager',
    'employee': 'Pracownik',
  };

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final u = await AuthService.getCurrentUser();
    if (u != null) {
      try {
        final userBadges = await BadgeService.fetchUserBadges(u.name);
        final allBadges = await BadgeService.fetchAllBadges();
        
        setState(() {
          badges = allBadges.map((b) {
            final earned = userBadges.any((ub) => ub.id == b.id);
            String color = 'blue';
            if (b.rarity == BadgeRarity.rare) color = 'purple';
            if (b.rarity == BadgeRarity.epic) color = 'amber';
            if (b.rarity == BadgeRarity.legendary) color = 'red';

            return BadgeListItem(
              id: int.tryParse(b.id.replaceAll('b', '')) ?? 0,
              name: b.name,
              description: b.description,
              icon: b.icon,
              color: color,
              earned: earned,
              earnedDate: earned ? DateTime.now().subtract(const Duration(days: 2)) : null,
            );
          }).toList();
        });
      } catch (e) {
        debugPrint('Błąd pobierania odznak: $e');
      }
    }

    setState(() {
      user = u;
      loading = false;
    });
  }

  List<Map<String, dynamic>> get mockCourses => [
        {
          "title": "Wprowadzenie do React",
          "progress": 75,
          "totalLessons": 12,
          "completedLessons": 9,
          "estimatedTime": "2h",
          "nextLesson": "Hooks - useState",
          "status": "in-progress",
        },
        {
          "title": "TypeScript Podstawy",
          "progress": 45,
          "totalLessons": 15,
          "completedLessons": 7,
          "estimatedTime": "5h",
          "nextLesson": "Typy zaawansowane",
          "status": "in-progress",
        },
        {
          "title": "Git i GitHub",
          "progress": 100,
          "totalLessons": 10,
          "completedLessons": 10,
          "estimatedTime": "0h",
          "status": "completed",
        },
        {
          "title": "CSS Advanced",
          "progress": 100,
          "totalLessons": 8,
          "completedLessons": 8,
          "estimatedTime": "0h",
          "status": "completed",
        },
        {
          "title": "Node.js dla początkujących",
          "progress": 0,
          "totalLessons": 20,
          "completedLessons": 0,
          "estimatedTime": "12h",
          "status": "not-started",
        },
      ];

  List<Map<String, String>> get achievements => [
        {
          "date": "20.03.2026",
          "title": 'Zdobyto odznakę "Mistrz nauki"',
          "desc": 'Ukończono 5 kursów w marcu',
          "icon": "🏆"
        },
        {
          "date": "18.03.2026",
          "title": 'Zdobyto odznakę "Seria 7 dni"',
          "desc": 'Nauka przez 7 dni z rzędu',
          "icon": "🔥"
        },
      ];

  String _nameFromEmail(String email) {
    final namePart = email.split('@').first.replaceAll('.', ' ');
    return namePart
        .split(' ')
        .map((e) =>
            e.isNotEmpty ? '${e[0].toUpperCase()}${e.substring(1)}' : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return const Center(child: Text('Brak danych użytkownika'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _header(),
        const SizedBox(height: 20),
        _statsSection(),
        const SizedBox(height: 20),
        _badgesAndCourses(),
        const SizedBox(height: 20),
        _achievementsTimeline(),
      ],
    );
  }

  Widget _header() {
    final fullName = _nameFromEmail(user!.email);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Tokens.blue700, Tokens.blueHover],
        ),
        borderRadius: BorderRadius.circular(Tokens.radius2xl),
        boxShadow: Tokens.shadowSm,
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Stack(
            children: [
              AppAvatar(
                imageUrl: null,
                name: fullName,
                radius: 40,
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Tokens.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.edit, size: 14),
                ),
              )
            ],
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fullName,
                    style: const TextStyle(
                        color: Tokens.background,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(user!.email,
                    style: const TextStyle(color: Tokens.muted)),
                Text(roleLabels[user!.role] ?? user!.role,
                    style: const TextStyle(color: Tokens.muted)),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Tokens.mutedForeground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Edytuj profil',
                style: TextStyle(color: Tokens.background)),
          )
        ],
      ),
    );
  }

  Widget _statsSection() {
    return Row(
      children: [
        Expanded(child: _statCard("Ukończone kursy", "3")),
        const SizedBox(width: 12),
        Expanded(child: _statCard("W trakcie", "2")),
        const SizedBox(width: 12),
        Expanded(child: _statCard("Średni wynik", "87%")),
      ],
    );
  }

  Widget _statCard(String title, String value) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 12, color: Tokens.textMuted2)),
          const SizedBox(height: 6),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _badgesAndCourses() {
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 800;

      return isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _badges()),
                const SizedBox(width: 16),
                Expanded(child: _courses()),
              ],
            )
          : Column(
              children: [
                _badges(),
                const SizedBox(height: 16),
                _courses(),
              ],
            );
    });
  }

  // Karta z odznakami
  Widget _badges() {
    final earnedCount = badges.where((b) => b.earned).length;
    final totalCount = badges.length;

    return AppCard(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Zdobyte odznaki",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Column(
                  children: badges
                      .map((b) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: BadgeCard(badge: b),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "$earnedCount/$totalCount",
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Karta z kursami
  Widget _courses() {
    final completedCount =
        mockCourses.where((c) => (c['progress'] as int) == 100).length;
    final totalCount = mockCourses.length;

    return AppCard(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Postęp w kursach",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(Tokens.radiusLg),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ogólny postęp",
                        style: TextStyle(
                            fontSize: 12,
                            color: Tokens.gray700,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: mockCourses
                                .map((c) => c['progress'] as int)
                                .reduce((a, b) => a + b) /
                            (mockCourses.length * 100),
                        color: Tokens.blue,
                        backgroundColor: Tokens.background,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${mockCourses.where((c) => (c['progress'] as int) > 0 && (c['progress'] as int) < 100).length} w trakcie",
                            style: const TextStyle(fontSize: 11),
                          ),
                          Text(
                            "$completedCount ukończone",
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Column(
                  children: mockCourses.map((c) {
                    final progress = c['progress'] as int;
                    String status;
                    Color statusColor;
                    if (progress == 100) {
                      status = 'Ukończony';
                      statusColor = Tokens.green700;
                    } else if (progress == 0) {
                      status = 'Nierozpoczęty';
                      statusColor = Tokens.mutedForeground;
                    } else {
                      status = 'W trakcie';
                      statusColor = Tokens.blue;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Tokens.radiusLg),
                          side: BorderSide(
                            color: statusColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      c['title'] as String,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                          color: statusColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              CourseProgressBar(
                                progress: progress,
                                label: null,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${c['completedLessons']} / ${c['totalLessons']} lekcji",
                                        style: const TextStyle(fontSize: 11, color: Tokens.mutedForeground),
                                      ),
                                      const SizedBox(width: 8),
                                      if (c['estimatedTime'] != null &&
                                          c['estimatedTime'].toString().isNotEmpty)
                                        Text(
                                          c['estimatedTime'],
                                          style: const TextStyle(fontSize: 11, color: Tokens.mutedForeground),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              if (c['nextLesson'] != null &&
                                  progress < 100 &&
                                  c['nextLesson'].toString().isNotEmpty)
                                Text(
                                  "Następnie: ${c['nextLesson']}",
                                  style: const TextStyle(
                                      fontSize: 11, color: Tokens.mutedForeground),
                                ),
                              const SizedBox(height: 6),
                              if (progress < 100)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Tokens.blue,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                    child: Text(
                                      progress == 0 ? 'Rozpocznij' : 'Kontynuuj',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // Licznik ukończonych kursów w prawym górnym rogu
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Tokens.blue100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "$completedCount/$totalCount",
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _achievementsTimeline() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Historia osiągnięć",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Column(
            children: achievements
                .map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Tokens.gray100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(a['icon']!),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(a['title']!,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500)),
                                Text(a['desc']!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Tokens.textMuted2)),
                              ],
                            ),
                          ),
                          Text(a['date']!,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Tokens.textMuted2))
                        ],
                      ),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}