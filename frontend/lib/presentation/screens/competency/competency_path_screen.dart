import 'package:flutter/material.dart';
import '../../../data/services/competency_service.dart';
import '../../../data/models/competency_model.dart';
import 'competency_progress_screen.dart';

class CompetencyPathScreen extends StatefulWidget {
  const CompetencyPathScreen({super.key});

  @override
  State<CompetencyPathScreen> createState() =>
      _CompetencyPathScreenState();
}

class _CompetencyPathScreenState extends State<CompetencyPathScreen> {
  late Future<List<CompetencyPath>> _pathsFuture;
  String? expandedPathId;

  @override
  void initState() {
    super.initState();
    _pathsFuture = CompetencyService.getPaths();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ścieżki kompetencji',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              'Rozwijaj umiejętności i zdobywaj XP',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),

        const SizedBox(height: 20),

        FutureBuilder<List<CompetencyPath>>(
          future: _pathsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Błąd ładowania ścieżek: ${snapshot.error}',
                ),
              );
            }

            final paths = snapshot.data ?? [];

            final earnedXp =
              paths.fold<int>(0, (sum, p) => sum + p.earnedXp);

            final targetXp =
              paths.fold<int>(0, (sum, p) => sum + p.totalXp);

            final totalXp =
                paths.fold<int>(0, (sum, p) => sum + p.earnedXp);

            final completedPaths =
                paths.where((p) => p.progress == 100).length;

            final totalSkills =
                paths.fold<int>(0, (sum, p) => sum + p.totalSkills);

            final completedSkills =
                paths.fold<int>(0, (sum, p) => sum + p.completedSkills);

            final overallProgress = totalSkills == 0
                ? 0
                : ((completedSkills / totalSkills) * 100).round();

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatBlock(
                          title: 'Łączne XP',
                          value: totalXp.toString(),
                        ),
                      ),
                      Expanded(
                        child: _StatBlock(
                          title: 'Postęp ogólny',
                          value: '$overallProgress%',
                          progress: overallProgress / 100,
                        ),
                      ),
                      Expanded(
                        child: _StatBlock(
                          title: 'Ukończone ścieżki',
                          value: '$completedPaths/${paths.length}',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                ...paths.map(
                  (path) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            expandedPathId =
                                expandedPathId == path.id ? null : path.id;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(path.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                                      subtitle: Text(path.description, style: const TextStyle(fontSize: 12),),
                                    ),
                                  ),

                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CompetencyProgressScreen(
                                            pathId: path.id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text("Szczegóły"),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'XP: ${path.earnedXp} / $targetXp',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Umiejętności: ${path.completedSkills}/${path.totalSkills}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        value: (path.progress / 100).clamp(0.0, 1.0),
                                        minHeight: 8,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${path.progress}%',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                              if (expandedPathId == path.id) ...[
                                const SizedBox(height: 12),

                                const Text("Umiejętności",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(height: 8),

                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: path.skills.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 6,
                                    mainAxisSpacing: 6,
                                    childAspectRatio: 6.3,
                                  ),
                                  itemBuilder: (context, index) {
                                    final skill = path.skills[index];
                                    final isCompleted = skill.isCompleted;

                                    return Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? Colors.green.withOpacity(0.08)
                                            : Colors.orange.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isCompleted ? Colors.green : Colors.orange,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                isCompleted ? Icons.check_circle : Icons.trending_up,
                                                color: isCompleted ? Colors.green : Colors.orange,
                                                size: 14,
                                              ),
                                              Text(
                                                "Lvl ${skill.level}",
                                                style: const TextStyle(fontSize: 11),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 8),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  skill.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              Text(
                                                "${skill.xp} XP",
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 10),

                                          if (skill.progress < 100)
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 6),

                                                LinearProgressIndicator(
                                                  value: (skill.progress / 100).clamp(0.0, 1.0),
                                                  minHeight: 5,
                                                ),

                                                const SizedBox(height: 4),

                                                Text(
                                                  "${skill.progress}%",
                                                  style: const TextStyle(fontSize: 10),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    );
                                  }),

                                const SizedBox(height: 12),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
class _StatBlock extends StatelessWidget {
  final String title;
  final String value;
  final double? progress;

  const _StatBlock({
    required this.title,
    required this.value,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFBFDBFE),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (progress != null) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(
                Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}