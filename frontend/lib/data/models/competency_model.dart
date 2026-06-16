class CompetencyPath {
  final String id;
  final String name;
  final String description;
  final String category;

  final int totalSkills;
  final int completedSkills;
  final int progress;

  final int earnedXp;
  final int totalXp;

  final int estimatedHours;

  final List<Skill> skills;

  const CompetencyPath({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.totalSkills,
    required this.completedSkills,
    required this.progress,
    required this.earnedXp,
    required this.totalXp,
    required this.estimatedHours,
    required this.skills,
  });

  factory CompetencyPath.fromJson(Map<String, dynamic> json) {
    final rawSkills = json['skills'];
    return CompetencyPath(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      totalSkills: json['totalSkills'] ?? 0,
      completedSkills: json['completedSkills'] ?? 0,
      progress: json['progress'] ?? 0,
      earnedXp: json['earnedXp'] ?? 0,
      totalXp: json['totalXp'] ?? 0,
      estimatedHours: json['estimatedHours'] ?? 0,
      skills: (rawSkills is List)
    ? rawSkills
        .whereType<Map<String, dynamic>>()
        .map((e) => Skill(
          name: e['name']?.toString() ?? '',
          isCompleted: e['isCompleted'] == true,
          xp: e['xp'] ?? 0,
          level: (e['level'] ?? 'Podstawowy').toString(),
          progress: e['progress'] ?? 0,
        ))
        .toList()
    : <Skill>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'totalSkills': totalSkills,
      'completedSkills': completedSkills,
      'progress': progress,
      'earnedXp': earnedXp,
      'totalXp': totalXp,
      'estimatedHours': estimatedHours,
    };
  }
}

class Skill {
  final String name;
  final bool isCompleted;

  final int xp;
  final String level;
  final int progress;

  Skill({
    required this.name,
    required this.isCompleted,
    this.xp = 0,
    this.level = 'Podstawowy',
    this.progress = 0,
  });
}