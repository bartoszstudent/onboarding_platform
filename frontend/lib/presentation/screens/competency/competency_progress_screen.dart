import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/services/competency_service.dart';
import '../../../data/models/competency_model.dart';

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

  bool _isLoading = true;
  String? _errorMessage;

  // Stan danych z API
  int _totalXp = 0;
  List<int> _weeklyXp = [0, 0, 0, 0, 0, 0, 0];
  List<dynamic> _recentActivities = [];
  List<dynamic> _milestones = [];
  List<CompetencyPath> _allPaths = [];
  CompetencyPath? _currentPath;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAllAnalytics();
  }

  Future<void> _loadAllAnalytics() async {
    try {
      final analytics = await CompetencyService.fetchGamificationAnalytics();
      final paths = await CompetencyService.getPaths();

      if (mounted) {
        setState(() {
          _totalXp = analytics['total_xp'] ?? 0;
          _weeklyXp = List<int>.from(analytics['weekly_xp'] ?? [0, 0, 0, 0, 0, 0, 0]);
          _recentActivities = analytics['recent_activities'] ?? [];
          _milestones = analytics['milestones'] ?? [];
          _allPaths = paths;
          _currentPath = paths.firstWhere(
            (p) => p.id == widget.pathId,
            orElse: () => paths.isNotEmpty ? paths.first : throw Exception('Brak ścieżki'),
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> get currentLevel {
    if (_milestones.isEmpty) return {'level': 1, 'title': 'Nowicjusz', 'required_xp': 0};
    return _milestones.lastWhere(
      (m) => _totalXp >= (m['required_xp'] as int),
      orElse: () => _milestones.first,
    );
  }

  Map<String, dynamic>? get nextLevel {
    final nextList = _milestones.where((m) => _totalXp < (m['required_xp'] as int));
    return nextList.isNotEmpty ? nextList.first : null;
  }

  BarChartGroupData _bar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 20,
          borderRadius: BorderRadius.circular(6),
          color: Colors.blue,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null || _currentPath == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Postęp kompetencyjny")),
        body: Center(child: Text('Wystąpił błąd ładowania danych: $_errorMessage')),
      );
    }

    final int nextXpThreshold = nextLevel?['required_xp'] ?? _totalXp;
    final double progressPercent = nextXpThreshold > 0 ? (_totalXp / nextXpThreshold).clamp(0.0, 1.0) : 1.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(_currentPath!.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF7C3AED)]),
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
                    "$_totalXp XP",
                    style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: progressPercent, backgroundColor: Colors.white24, color: Colors.white),
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
            SizedBox(
              height: 520,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _overview(),
                  _activity(),
                  _radar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overview() {
    final currentLvlIdx = _milestones.indexWhere((m) => m['level'] == currentLevel['level']);
    final visibleMilestones = _milestones.skip(currentLvlIdx).take(3).toList();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        GridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.1,
          children: [
            _SmallCard("Kursy ścieżki", "${_currentPath!.totalSkills}"),
            _SmallCard("Ukończone", "${_currentPath!.completedSkills}"),
            _SmallCard("Postęp", "${_currentPath!.progress}%"),
            _SmallCard("Ogólne Lvl", "${currentLevel['level']}"),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Aktywność XP w tym tygodniu', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['Pn', 'Wt', 'Śr', 'Cz', 'Pt', 'Sb', 'Nd'];
                            if (value.toInt() >= 0 && value.toInt() < days.length) {
                              return Text(days[value.toInt()], style: const TextStyle(fontSize: 10));
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(7, (i) => _bar(i, _weeklyXp[i].toDouble())),
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
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Nadchodzące cele", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: visibleMilestones.map<Widget>((m) {
                    final unlocked = _totalXp >= (m['required_xp'] as int);
                    return Row(
                      children: [
                        Container(
                          width: 100,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: unlocked ? Colors.green.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: unlocked ? Colors.green.withOpacity(0.3) : Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              Text(unlocked ? "✅" : "🔒", style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(m['title'] ?? '', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text("${m['required_xp']} XP", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _activity() {
    if (_recentActivities.isEmpty) {
      return const Center(child: Text("Brak zarejestrowanych operacji XP w bazie."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _recentActivities.length,
      itemBuilder: (context, index) {
        final item = _recentActivities[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              const CircleAvatar(radius: 18, backgroundColor: Colors.blue, child: Icon(Icons.bolt, color: Colors.blue, size: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['reason'] ?? 'Przyznanie punktów', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(item['time_ago'] ?? 'Niedawno', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
              Text("+${item['amount']} XP", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 13)),
            ],
          ),
        );
      },
    );
  }

  Widget _radar() {
    if (_allPaths.isEmpty) return const Center(child: Text("Brak przypisanych ścieżek kompetencyjnych."));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Zrównoważenie rozwoju", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            SizedBox(
              height: 220,
              child: RadarChart(
                RadarChartData(
                  radarShape: RadarShape.polygon,
                  tickCount: 4,
                  ticksTextStyle: const TextStyle(color: Colors.transparent),
                  gridBorderData: const BorderSide(color: Color(0xFFE2E8F0)),
                  titlePositionPercentageOffset: 0.15,
                  getTitle: (index, angle) {
                    if (index >= 0 && index < _allPaths.length) {
                      return RadarChartTitle(text: _allPaths[index].name, angle: angle);
                    }
                    return const RadarChartTitle(text: '');
                  },
                  dataSets: [
                    RadarDataSet(
                      fillColor: Colors.purple.withOpacity(0.15),
                      borderColor: Colors.purple,
                      entryRadius: 3,
                      dataEntries: _allPaths.map((p) => RadarEntry(value: p.progress.toDouble())).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ..._allPaths.map((path) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  Expanded(child: Text(path.name, style: const TextStyle(fontSize: 13))),
                  SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(value: path.progress / 100, minHeight: 5, borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(width: 10),
                  Text("${path.progress}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            )),
          ],
        ),
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
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 9, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}