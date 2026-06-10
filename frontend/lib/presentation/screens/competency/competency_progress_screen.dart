import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompetencyProgressScreen extends StatefulWidget {
  final String pathId;

  const CompetencyProgressScreen({
    super.key,
    required this.pathId,
  });

  @override
  State<CompetencyProgressScreen> createState() =>
      _CompetencyProgressScreenState();
}

class _CompetencyProgressScreenState extends State<CompetencyProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final int totalXp = 1950;

  final milestones = const [
    {'level': 1, 'title': 'Nowicjusz', 'xp': 0},
    {'level': 2, 'title': 'Uczeń', 'xp': 500},
    {'level': 3, 'title': 'Praktykant', 'xp': 1500},
    {'level': 4, 'title': 'Junior', 'xp': 3000},
    {'level': 5, 'title': 'Mid', 'xp': 6000},
  ];

  final recentActivity = const [
    {'title': 'TypeScript — Generics', 'xp': 150, 'time': '2h temu', 'icon': 'book-open.svg'},
    {'title': 'Quick Learner badge', 'xp': 200, 'time': '1d temu', 'icon': 'award.svg'},
    {'title': 'React Fundamentals', 'xp': 500, 'time': '3d temu', 'icon': 'star.svg'},
  ];

  final radarData = const [
    {'subject': 'Frontend', 'value': 80},
    {'subject': 'Backend', 'value': 30},
    {'subject': 'Komunikacja', 'value': 60},
    {'subject': 'Agile', 'value': 100},
    {'subject': 'Security', 'value': 10},
    {'subject': 'DevOps', 'value': 25},
  ];

  BarChartGroupData _bar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 80,
          borderRadius: BorderRadius.circular(6),
          color: Colors.blue,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Map get currentLevel =>
      milestones.lastWhere((m) => totalXp >= (m['xp'] as int));

  Map? get nextLevel =>
      milestones.where((m) => totalXp < (m['xp'] as int)).isNotEmpty
          ? milestones.where((m) => totalXp < (m['xp'] as int)).first
          : null;

  @override
  Widget build(BuildContext context) {
    final nextXp = nextLevel?['xp'] ?? 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Postęp kompetencyjny"),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Poziom ${currentLevel['level']} — ${currentLevel['title']}",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "$totalXp XP",
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: totalXp / nextXp,
                    backgroundColor: Colors.white24,
                    color: Colors.white,
                  ),
                ],
              ),
            ),

            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Przegląd"),
                Tab(text: "Aktywność"),
                Tab(text: "Mapa kompetencji"),
              ],
            ),

           _buildTabs(),
          ],
        ),
      ),
    );
  }

  Widget _overview() {
    final currentIndex = milestones.lastIndexWhere(
      (m) => totalXp >= (m['xp'] as int),
    );

    final visibleMilestones = milestones.take(currentIndex + 3).toList();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        
        GridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3.2,
          children: const [
            _SmallCard("Kursy", "4"),
            _SmallCard("Skills", "10"),
            _SmallCard("Odznaki", "3"),
            _SmallCard("Seria dni", "7"),
          ],
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'XP w tym tygodniu',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                   
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['Pn', 'Wt', 'Śr', 'Cz', 'Pt', 'Sb', 'Nd'];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                days[value.toInt()],
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                      ),

                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),

                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),

                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        left: BorderSide(color: Colors.grey, width: 1),
                        bottom: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),

                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                    ),

                    barGroups: [
                      _bar(0, 120),
                      _bar(1, 200),
                      _bar(2, 80),
                      _bar(3, 340),
                      _bar(4, 160),
                      _bar(5, 0),
                      _bar(6, 50),
                    ],

                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipPadding: const EdgeInsets.all(8),
                        tooltipMargin: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${rod.toY.toInt()} XP',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Kamienie milowe",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(visibleMilestones.length, (i) {
                    final m = visibleMilestones[i];
                    final unlocked = totalXp >= (m['xp'] as int);

                    return Row(
                      children: [
                        Container(
                          width: 90,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: unlocked
                                ? Colors.blue.withOpacity(0.06)
                                : Colors.grey.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: unlocked
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text("⭐", style: TextStyle(fontSize: 18)),

                              const SizedBox(height: 6),

                              Text(
                                m['title'] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "${m['xp']} XP",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (i != visibleMilestones.length - 1) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              ">",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _activity() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: recentActivity.map((a) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  'assets/icons/${a['icon']}',
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a['title'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      a['time'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                "+${a['xp']} XP",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _radar() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Mapa kompetencji",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 350,
              child: RadarChart(
                RadarChartData(
                  radarShape: RadarShape.polygon,

                  tickCount: 5,
                  ticksTextStyle: const TextStyle(
                    color: Colors.transparent,
                  ),

                  gridBorderData: const BorderSide(
                    color: Color(0xFFD9D9D9),
                  ),

                  titlePositionPercentageOffset: 0.15,

                  getTitle: (index, angle) {
                    final titles = [
                      "Frontend",
                      "Backend",
                      "Komunikacja",
                      "Agile",
                      "Security",
                      "DevOps",
                    ];

                    return RadarChartTitle(
                      text: titles[index],
                      angle: angle,
                    );
                  },

                  dataSets: [
                    RadarDataSet(
                      fillColor: Colors.blue.withOpacity(0.25),
                      borderColor: Colors.blue,
                      entryRadius: 2,

                      dataEntries: const [
                        RadarEntry(value: 80),
                        RadarEntry(value: 30),
                        RadarEntry(value: 60),
                        RadarEntry(value: 100),
                        RadarEntry(value: 10),
                        RadarEntry(value: 25),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: radarData.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 12.3,
              ),
              itemBuilder: (context, index) {
                final item = radarData[index];

                return _CompetencyCard(
                  title: item['subject'] as String,
                  value: item['value'] as int,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: TabBarView(
        controller: _tabController,
        children: [
          _overview(),
          _activity(),
          _radar(),
        ],
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  final String title;
  final String value;

  const _SmallCard(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompetencyCard extends StatelessWidget {
  final String title;
  final int value;

  const _CompetencyCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),

          SizedBox(
            width: 100,
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 6,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(width: 12),

          Text(
            "$value%",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}