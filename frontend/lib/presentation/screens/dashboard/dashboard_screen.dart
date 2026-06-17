import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../ui/stat_card.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../data/services/dashboard_service.dart';
import '../../../data/models/dashboard_models.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/badge_service.dart';
import '../../../data/models/badge_model.dart';
import '../../../data/services/mentor_service.dart';
import '../../../data/models/mentor_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<DashboardStats> _statsFuture;
  late Future<List<ActivityItem>> _activitiesFuture;
  late Future<List<double>> _chartDataFuture; 
  String? _role;
  UserModel? _user;
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _statsFuture = DashboardService.getStats();
    _chartDataFuture = DashboardService.getWeeklyActivity(); 
    _activitiesFuture = DashboardService.getRecentActivities(limit: 10);
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await AuthService.getCurrentUser();
      final role = await AuthService.getRole();
      if (mounted) {
        setState(() {
          _role = role;
          _user = user;
          _loadingUser = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingUser = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingUser) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isAdmin = _role == 'admin' || _role == 'super_admin' || _role == 'hr';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Welcome banner
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF60A5FA)]),
            borderRadius: BorderRadius.circular(Tokens.radius2xl),
            boxShadow: Tokens.shadowSm,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAdmin
                    ? 'Witaj, ${_user?.name ?? 'admin'}! 👋'
                    : 'Witaj, ${_user?.name ?? 'pracowniku'}! 👋',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                isAdmin
                    ? 'Panel zarządzania firmą - przegląd aktywności i statystyk'
                    : 'Twój panel wdrożeniowy - monitoruj swój postęp i zadania',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(Tokens.radius),
                ),
                child: const Text('TechCorp Sp. z o.o.',
                    style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),

        const SizedBox(height: 20),

        if (isAdmin) ...[
          // Stats for Admin
          FutureBuilder<DashboardStats>(
            future: _statsFuture,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()));
              }
              final stats = snap.data ?? DashboardStats();

              return LayoutBuilder(builder: (context, constraints) {
                final width = constraints.maxWidth;
                final cardWidth = width >= 1100 ? (width - 32) / 3 : 320.0;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                        width: cardWidth,
                        child: StatCard(
                            iconAsset: 'assets/icons/book-open.svg',
                            title: 'Liczba kursów',
                            value: stats.courses.toString(),
                            delta: 'Na podstawie bazy')),
                    SizedBox(
                        width: cardWidth,
                        child: StatCard(
                            iconAsset: 'assets/icons/users.svg',
                            title: 'Liczba pracowników',
                            value: stats.employees.toString(),
                            delta: 'Na podstawie bazy')),
                    SizedBox(
                        width: cardWidth,
                        child: StatCard(
                            iconAsset: 'assets/icons/clock.svg',
                            title: 'Średni czas',
                            value: '${stats.avgCompletionHours}h',
                            delta: 'Szacunkowo')),
                  ],
                );
              });
            },
          ),

          const SizedBox(height: 20),

          // Wykres i akcje zintegrowane z API
          LayoutBuilder(builder: (context, constraints) {
            final width = constraints.maxWidth;
            final leftWidth = width >= 1000 ? width * 0.68 : width;
            final rightWidth = width >= 1000 ? width * 0.3 : width;
            
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === LEWA STRONA (WYKRES) ===
                SizedBox(
                  width: leftWidth,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Tokens.surface,
                        borderRadius: BorderRadius.circular(Tokens.radius2xl),
                        boxShadow: Tokens.shadowSm),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/chart-bar.svg', width: 18, height: 18, color: Tokens.blue),
                            const SizedBox(width: 8),
                            const Text('Tygodniowa aktywność platformy', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        FutureBuilder<List<double>>(
                          future: _chartDataFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox(
                                height: 200, 
                                child: Center(child: CircularProgressIndicator())
                              );
                            }
                            
                            final heights = snapshot.data ?? List.generate(7, (index) => 0.05);

                            return SizedBox(
                              height: 200,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(7, (i) {
                                  final days = ['Pn', 'Wt', 'Śr', 'Cz', 'Pt', 'Sb', 'Nd'];
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(milliseconds: 600),
                                            curve: Curves.easeOut,
                                            height: 180 * heights[i],
                                            decoration: BoxDecoration(
                                              color: Tokens.blue, 
                                              borderRadius: BorderRadius.circular(6)
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            days[i], 
                                            style: const TextStyle(fontSize: 10, color: Colors.grey)
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          }
                        ), // <- Koniec FutureBuildera
                      ],
                    ),
                  ),
                ), // <- Koniec lewej kolumny (SizedBox)
                
                // === ODSTĘP ===
                if (width >= 1000) const SizedBox(width: 20),
                
                // === PRAWA STRONA (SZYBKIE AKCJE) ===
                SizedBox(
                  width: rightWidth,
                  child: Container(
                    decoration: BoxDecoration(color: Tokens.surface, borderRadius: BorderRadius.circular(Tokens.radius2xl), boxShadow: Tokens.shadowSm),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Szybkie akcje', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 12),
                        Column(
                          children: [
                            _quickAction(context, 'Dodaj nowy kurs', () => context.push('/courses/create')),
                            const SizedBox(height: 8),
                            _quickAction(context, 'Zaproś pracownika', () => context.push('/users/create')),
                          ],
                        )
                      ],
                    ),
                  ),
                ) // <- Koniec prawej kolumny (SizedBox)
              ],
            );
          }),

          const SizedBox(height: 20),

          // Ostatnie aktywności z bazy
          FutureBuilder<List<ActivityItem>>(
            future: _activitiesFuture,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
              }
              final activities = snap.data ?? [];

              return Container(
                decoration: BoxDecoration(color: Tokens.surface, borderRadius: BorderRadius.circular(Tokens.radius2xl), boxShadow: Tokens.shadowSm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Ostatnie aktywności z bazy', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    ),
                    const Divider(height: 1),
                    if (activities.isEmpty)
                       const Padding(padding: EdgeInsets.all(16), child: Text("Brak ostatnich aktywności.")),
                    ...activities.map((r) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Tokens.gray200))),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text(r.user)),
                            Expanded(flex: 2, child: Text(r.action)),
                            Expanded(child: Text(r.course)),
                            Expanded(child: Text(r.time)),
                          ],
                        ),
                      );
                    }).toList()
                  ],
                ),
              );
            },
          ),
        ] else ...[
          // Employee dashboard views z podpiętymi danymi API
          FutureBuilder<DashboardStats>(
            future: _statsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
              }
              
              final stats = snapshot.data ?? DashboardStats();
              
              return LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final isWide = width > 900;

                  return isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  UserStatsWidget(stats: stats),
                                  const SizedBox(height: 20),
                                  const MentorCardWidget(), // Mentor nadal statyczny (Punkt 5)
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(child: BadgeWidget(userId: _user?.id.toString() ?? '0')),
                          ],
                        )
                      : Column(
                          children: [
                            UserStatsWidget(stats: stats),
                            const SizedBox(height: 20),
                            const MentorCardWidget(),
                            const SizedBox(height: 20),
                            BadgeWidget(userId: _user?.id.toString() ?? '0'),
                          ],
                        );
                },
              );
            }
          ),
        ],
      ],
    );
  }

  Widget _quickAction(BuildContext context, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(color: Tokens.gray50, borderRadius: BorderRadius.circular(8)),
        child: Text(label),
      ),
    );
  }
}

// --- ZAKTUALIZOWANY WIDŻET PRACOWNIKA ---
class UserStatsWidget extends StatelessWidget {
  final DashboardStats stats;
  const UserStatsWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Tokens.surface,
        borderRadius: BorderRadius.circular(Tokens.radius2xl),
        boxShadow: Tokens.shadowSm,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.trending_up, color: Colors.blue),
              SizedBox(width: 8),
              Text('Twoje statystyki', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Row(
                children: [
                  Expanded(child: _box('Ukończone', '${stats.completedCourses}', Colors.blue, 'assets/icons/circle-check-big.svg')),
                  const SizedBox(width: 12),
                  Expanded(child: _box('W trakcie', '${stats.inProgressCourses}', Colors.purple, 'assets/icons/book-open.svg')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _box('Czas nauki', stats.learningTime, Colors.green, 'assets/icons/clock.svg')),
                  const SizedBox(width: 12),
                  Expanded(child: _box('Seria dni', '${stats.streak}', Colors.orange, 'assets/icons/flame.svg')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _box(String title, String value, Color color, String iconPath) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SvgPicture.asset(iconPath, width: 16, height: 16, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- ZAKTUALIZOWANY WIDŻET ODZNAK (ZAPYTANIE Z PUNKTU 1) ---
class BadgeWidget extends StatelessWidget {
  final String userId;
  const BadgeWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Tokens.surface,
        borderRadius: BorderRadius.circular(Tokens.radius2xl),
        boxShadow: Tokens.shadowSm,
      ),
      padding: const EdgeInsets.all(16),
      child: FutureBuilder<List<BadgeModel>>(
        future: BadgeService.fetchUserBadges(userId),
        builder: (context, snapshot) {
          final earnedBadges = snapshot.data ?? [];
          final isLoading = snapshot.connectionState == ConnectionState.waiting;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.emoji_events, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Zdobyte odznaki', style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Text('${earnedBadges.length} zdobytych', style: const TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 16),
              
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (earnedBadges.isEmpty)
                Column(
                  children: const [
                    SizedBox(height: 20),
                    Icon(Icons.emoji_events_outlined, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Brak zdobytych odznak. Czas rozpocząć kurs!'),
                  ],
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: earnedBadges.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3.8,
                  ),
                  itemBuilder: (context, index) {
                    final b = earnedBadges[index];
                    return _badgeBox(b);
                  },
                ),
            ],
          );
        }
      ),
    );
  }

  Widget _badgeBox(BadgeModel b) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SvgPicture.asset(
              'assets/icons/star.svg', // Domyślna ikona, można zmienić pod pole b.icon
              width: 16, height: 16,
              colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b.name, style: const TextStyle(fontSize: 14, color: Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(b.description ?? '', style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Mentor z racji integracji w następnym punkcie pozostaje nienaruszony
class MentorCardWidget extends StatelessWidget {
  const MentorCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MentorModel>>(
      future: MentorService.fetchMentors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final mentors = snapshot.data ?? [];
        if (mentors.isEmpty) {
          return const SizedBox(); // Nie pokazujemy karty, jeśli w firmie nie ma innych pracowników
        }
        
        // Wybieramy pierwszego pracownika jako mentora (na potrzeby widoku)
        final mentor = mentors.first;
        final initials = mentor.name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join('');

        return Container(
          decoration: BoxDecoration(
            color: Tokens.surface, 
            borderRadius: BorderRadius.circular(Tokens.radius2xl), 
            border: Border.all(color: Tokens.gray200)
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.school, color: Tokens.blue), 
                  SizedBox(width: 8), 
                  Text('Twój mentor', style: TextStyle(fontWeight: FontWeight.w600, color: Tokens.textDark))
                ]
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 28, 
                    backgroundColor: Tokens.blue.withOpacity(0.1), 
                    child: Text(initials.toUpperCase(), style: const TextStyle(color: Tokens.blue, fontWeight: FontWeight.bold, fontSize: 20))
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mentor.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Tokens.textDark)),
                        const SizedBox(height: 4),
                        Text(mentor.role, style: const TextStyle(fontSize: 13, color: Tokens.textMuted2)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text('${mentor.rating}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            Text(' (${mentor.reviewCount} opinii)', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Przekazujemy prawdziwe ID oraz Name jako parametry URL do widoku
                    context.go('/mentor-rating?mentorId=${mentor.id}&mentorName=${Uri.encodeComponent(mentor.name)}&taskTitle=Współpraca wdrażeniowa');
                  },
                  icon: const Icon(Icons.rate_review_outlined, size: 16),
                  label: const Text('Oceń współpracę'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Tokens.blue), 
                    foregroundColor: Tokens.blue, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}