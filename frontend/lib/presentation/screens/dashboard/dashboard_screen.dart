import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../ui/stat_card.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../data/services/dashboard_service.dart';
import '../../../data/models/dashboard_models.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<DashboardStats> _statsFuture;
  late Future<List<ActivityItem>> _activitiesFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = DashboardService.getStats();
    _activitiesFuture = DashboardService.getRecentActivities(limit: 10);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Welcome banner (static)
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
              Text('Witaj, admin! 👋',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              Text('Panel zarządzania firmą - przegląd aktywności i statystyk',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white70)),
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

        // Stats + activities fetched from service
        FutureBuilder<DashboardStats>(
          future: _statsFuture,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()));
            }
            if (snap.hasError) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Text('Błąd ładowania statystyk: ${snap.error}'),
              );
            }
            final stats = snap.data!;

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
                          delta: '+3 w tym miesiącu')),
                  SizedBox(
                      width: cardWidth,
                      child: StatCard(
                          iconAsset: 'assets/icons/users.svg',
                          title: 'Liczba pracowników',
                          value: stats.employees.toString(),
                          delta: '+12 w tym miesiącu')),
                  SizedBox(
                      width: cardWidth,
                      child: StatCard(
                          iconAsset: 'assets/icons/clock.svg',
                          title: 'Średni czas ukończenia',
                          value: '${stats.avgCompletionHours}h',
                          delta: '-0.5h vs poprzedni')),
                ],
              );
            });
          },
        ),

        const SizedBox(height: 20),

        // Chart + quick actions (chart stays placeholder)
        LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          final leftWidth = width >= 1000 ? width * 0.68 : width;
          final rightWidth = width >= 1000 ? width * 0.3 : width;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          SvgPicture.asset('assets/icons/chart-bar.svg',
                              width: 18, height: 18, color: Tokens.blue),
                          const SizedBox(width: 8),
                          const Text('Postęp pracowników w tym tygodniu',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 200,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (i) {
                            final heights = [
                              0.45,
                              0.55,
                              0.6,
                              0.58,
                              0.72,
                              0.4,
                              0.35
                            ];
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Container(
                                  height: 200 * heights[i],
                                  decoration: BoxDecoration(
                                    color: Tokens.blue,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (width >= 1000) const SizedBox(width: 20),
              SizedBox(
                width: rightWidth,
                child: Container(
                  decoration: BoxDecoration(
                      color: Tokens.surface,
                      borderRadius: BorderRadius.circular(Tokens.radius2xl),
                      boxShadow: Tokens.shadowSm),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Szybkie akcje',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          _quickAction(context, 'Dodaj nowy kurs'),
                          const SizedBox(height: 8),
                          _quickAction(context, 'Zaproś pracownika'),
                          const SizedBox(height: 8),
                          _quickAction(context, 'Generuj raport'),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        }),

        const SizedBox(height: 20),

        // Recent activities table (from service)
        FutureBuilder<List<ActivityItem>>(
          future: _activitiesFuture,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()));
            }
            if (snap.hasError) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Text('Błąd ładowania aktywności: ${snap.error}'),
              );
            }
            final activities = snap.data ?? [];

            return Container(
              decoration: BoxDecoration(
                  color: Tokens.surface,
                  borderRadius: BorderRadius.circular(Tokens.radius2xl),
                  boxShadow: Tokens.shadowSm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Ostatnie aktywności',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  const Divider(height: 1),
                  ...activities.map((r) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Tokens.gray200))),
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
      ],
    );
  }

  Widget _quickAction(BuildContext context, String label) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
            color: Tokens.gray50, borderRadius: BorderRadius.circular(8)),
        child: Text(label),
      ),
    );
  }
}
