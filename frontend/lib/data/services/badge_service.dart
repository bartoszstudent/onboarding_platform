import 'dart:async';
import '../models/badge_model.dart';

class BadgeService {
  static final List<BadgeModel> _mockBadges = [
    const BadgeModel(
      id: 'b1',
      name: 'Szybki Start',
      description: 'Ukończono onboarding przed terminem.',
      icon: 'zap',
      category: 'Onboarding',
      rarity: BadgeRarity.common,
      xpReward: 100,
    ),
    const BadgeModel(
      id: 'b2',
      name: 'Team Player',
      description: 'Aktywnie wspierał kolegów z zespołu.',
      icon: 'medal',
      category: 'Współpraca',
      rarity: BadgeRarity.common,
      xpReward: 150,
    ),
    const BadgeModel(
      id: 'b3',
      name: 'Mentor Buddy',
      description: 'Wyjątkowo zaangażowany mentor.',
      icon: 'trophy',
      category: 'Mentoring',
      rarity: BadgeRarity.rare,
      xpReward: 300,
    ),
    const BadgeModel(
      id: 'b4',
      name: 'Code Master',
      description: 'Wyjątkowa jakość kodu i architektury.',
      icon: 'target',
      category: 'Techniczna',
      rarity: BadgeRarity.rare,
      xpReward: 250,
    ),
    const BadgeModel(
      id: 'b5',
      name: 'Komunikator',
      description: 'Wzorowa komunikacja w zespole.',
      icon: 'star',
      category: 'Miękkie',
      rarity: BadgeRarity.common,
      xpReward: 100,
    ),
    const BadgeModel(
      id: 'b6',
      name: 'Innowator',
      description: 'Zaproponował innowacyjne rozwiązanie.',
      icon: 'flame',
      category: 'Kreatywność',
      rarity: BadgeRarity.epic,
      xpReward: 500,
    ),
    const BadgeModel(
      id: 'b7',
      name: 'Compliance Pro',
      description: 'Wzorowe przestrzeganie procedur.',
      icon: 'medal',
      category: 'Compliance',
      rarity: BadgeRarity.common,
      xpReward: 150,
    ),
    const BadgeModel(
      id: 'b8',
      name: 'Legenda Onboardingu',
      description: 'Perfekcyjnie ukończony cały program onboardingowy.',
      icon: 'crown',
      category: 'Onboarding',
      rarity: BadgeRarity.legendary,
      xpReward: 1000,
    ),
  ];

  static final List<EmployeeModel> _mockEmployees = [
    const EmployeeModel(
      id: 'e1',
      name: 'Jan Kowalski',
      role: 'Frontend Developer',
      department: 'Engineering',
      badges: ['b1', 'b2'],
    ),
    const EmployeeModel(
      id: 'e2',
      name: 'Marta Szymańska',
      role: 'UX Designer',
      department: 'Design',
      badges: ['b5'],
    ),
    const EmployeeModel(
      id: 'e3',
      name: 'Krzysztof Nowicki',
      role: 'Backend Developer',
      department: 'Engineering',
      badges: [],
    ),
    const EmployeeModel(
      id: 'e4',
      name: 'Agata Wiśniewska',
      role: 'QA Engineer',
      department: 'QA',
      badges: ['b1', 'b7'],
    ),
  ];

  static Future<List<BadgeModel>> fetchAllBadges() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockBadges);
  }

  static Future<List<EmployeeModel>> fetchEmployees() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_mockEmployees);
  }

  static Future<bool> awardBadge(
    String employeeId,
    String badgeId,
    String? message,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _mockEmployees.indexWhere((e) => e.id == employeeId);
    if (idx != -1) {
      final old = _mockEmployees[idx];
      if (!old.badges.contains(badgeId)) {
        _mockEmployees[idx] = EmployeeModel(
          id: old.id,
          name: old.name,
          role: old.role,
          department: old.department,
          badges: [...old.badges, badgeId],
          avatar: old.avatar,
        );
      }
    }
    return true;
  }

  static Future<List<BadgeModel>> fetchUserBadges(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Simulating user e1 is Jan Kowalski
    final employee = _mockEmployees.firstWhere(
      (e) => e.id == userId || e.name.contains(userId),
      orElse: () => _mockEmployees.first,
    );
    return _mockBadges
        .where((badge) => employee.badges.contains(badge.id))
        .toList();
  }
}
