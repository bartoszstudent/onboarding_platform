import '../models/competency_model.dart';

class CompetencyService {
  static Future<List<CompetencyPath>> getPaths() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      CompetencyPath(
        id: '1',
        name: 'Frontend Developer',
        description:
            'Opanuj nowoczesne technologie frontendowe od HTML/CSS po React.',
        category: 'Techniczne',
        totalSkills: 8,
        completedSkills: 3,
        progress: 45,
        earnedXp: 1350,
        totalXp: 3000,
        estimatedHours: 40,
        skills: [
          Skill(name: 'HTML & CSS', isCompleted: true, xp: 200, level: 'Podstawowy', progress: 100,),
          Skill(name: 'JavaScript Basics', isCompleted: true, xp: 300, level: 'Podstawowy', progress: 100,),
          Skill(name: 'React Fundamentals', isCompleted: true, xp: 500, level: 'Średniozaawansowany', progress: 100,),
          Skill(name: 'TypeScript', isCompleted: false, xp: 650, level: 'Średniozaawansowany', progress: 65,),
          Skill(name: 'State Management', isCompleted: false, xp: 500, level: 'Średniozaawansowany', progress: 0,),
          Skill(name: 'Testing', isCompleted: false, xp: 700, level: 'Zaawansowany', progress: 0,),
          Skill(name: 'Performance Optimization', isCompleted: false, xp: 600, level: 'Zaawansowany', progress: 0,),
          Skill(name: 'Advanced Patterns', isCompleted: false, xp: 400, level: 'Zaawansowany', progress: 0,),
        ],
      ),
      CompetencyPath(
        id: '2',
        name: 'Komunikacja & Prezentacja',
        description:
            'Rozwijaj umiejętności interpersonalne i prezentacyjne.',
        category: 'Miękkie',
        totalSkills: 5,
        completedSkills: 1,
        progress: 20,
        earnedXp: 300,
        totalXp: 1500,
        estimatedHours: 20,
        skills: [
          Skill(name: 'Asertywna komunikacja', isCompleted: true, xp: 300, level: 'Podstawowy', progress: 100,),
          Skill(name: 'Prezentacje publiczne', isCompleted: false, xp: 400, level: 'Średniozaawansowany', progress: 40,),
          Skill(name: 'Negocjacje', isCompleted: false, xp: 400, level: 'Średniozaawansowany', progress: 0,),
          Skill(name: 'Zarządzanie konfliktami', isCompleted: false, xp: 200, level: 'Zaawansowany', progress: 0,),
          Skill(name: 'Leadership', isCompleted: false, xp: 200, level: 'Zaawansowany', progress: 0,),
        ],
      ),
      CompetencyPath(
        id: '3',
        name: 'Procesy & Agile',
        description:
            'Poznaj metodyki Agile i narzędzia zarządzania projektami.',
        category: 'Procesy',
        totalSkills: 6,
        completedSkills: 6,
        progress: 100,
        earnedXp: 1800,
        totalXp: 1800,
        estimatedHours: 15,
        skills: [
          Skill(name: 'Advanced Patterns', isCompleted: false, xp: 200, level: 'Podstawowy', progress: 0,),
        ],
      ),
      CompetencyPath(
        id: '4',
        name: 'Bezpieczeństwo IT',
        description:
            'Podstawy cyberbezpieczeństwa i ochrony danych.',
        category: 'Compliance',
        totalSkills: 4,
        completedSkills: 0,
        progress: 0,
        earnedXp: 0,
        totalXp: 1200,
        estimatedHours: 10,
        skills: [
          Skill(name: 'Advanced Patterns', isCompleted: false, xp: 200, level: 'Podstawowy', progress: 0,),
        ],
      ),
    ];
  }
}