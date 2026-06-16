import 'dart:async';
import '../models/mentor_model.dart';

class MentorService {
  static final List<MentorModel> _mockMentors = [
    const MentorModel(
      id: '1',
      name: 'Piotr Wiśniewski',
      role: 'Senior Frontend Developer',
      department: 'Engineering',
      rating: 4.9,
      reviewCount: 24,
      activeTasksCount: 2,
      expertise: ['React', 'TypeScript', 'CSS', 'UX'],
    ),
    const MentorModel(
      id: '2',
      name: 'Anna Nowak',
      role: 'HR Business Partner',
      department: 'Human Resources',
      rating: 4.7,
      reviewCount: 31,
      activeTasksCount: 4,
      expertise: ['Onboarding', 'Procesy HR', 'Komunikacja'],
    ),
    const MentorModel(
      id: '3',
      name: 'Tomasz Kowalczyk',
      role: 'Backend Lead',
      department: 'Engineering',
      rating: 4.8,
      reviewCount: 18,
      activeTasksCount: 1,
      expertise: ['Node.js', 'PostgreSQL', 'Docker', 'Architektura'],
    ),
    const MentorModel(
      id: '4',
      name: 'Maria Lewandowska',
      role: 'Product Manager',
      department: 'Product',
      rating: 4.6,
      reviewCount: 15,
      activeTasksCount: 3,
      expertise: ['Roadmap', 'Agile', 'Stakeholder Management'],
    ),
    const MentorModel(
      id: '5',
      name: 'Krzysztof Zając',
      role: 'DevOps Engineer',
      department: 'Infrastructure',
      rating: 4.5,
      reviewCount: 9,
      activeTasksCount: 2,
      expertise: ['CI/CD', 'Kubernetes', 'AWS'],
    ),
  ];

  static Future<List<MentorModel>> fetchMentors() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_mockMentors);
  }

  static Future<bool> assignMentor(String mentorId, String? taskTitle) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Update active task count for simulation
    final idx = _mockMentors.indexWhere((m) => m.id == mentorId);
    if (idx != -1) {
      final old = _mockMentors[idx];
      _mockMentors[idx] = MentorModel(
        id: old.id,
        name: old.name,
        role: old.role,
        department: old.department,
        rating: old.rating,
        reviewCount: old.reviewCount,
        activeTasksCount: old.activeTasksCount + 1,
        expertise: old.expertise,
        avatar: old.avatar,
      );
    }
    return true;
  }

  static Future<bool> submitRating({
    required String mentorId,
    required int rating,
    required String comment,
    Map<String, int>? criteriaRatings,
    List<String>? tags,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate updating rating and review count
    final idx = _mockMentors.indexWhere((m) => m.id == mentorId);
    if (idx != -1) {
      final old = _mockMentors[idx];
      final newReviewCount = old.reviewCount + 1;
      final newRating = ((old.rating * old.reviewCount) + rating) / newReviewCount;
      _mockMentors[idx] = MentorModel(
        id: old.id,
        name: old.name,
        role: old.role,
        department: old.department,
        rating: double.parse(newRating.toStringAsFixed(1)),
        reviewCount: newReviewCount,
        activeTasksCount: old.activeTasksCount,
        expertise: old.expertise,
        avatar: old.avatar,
      );
    }
    return true;
  }
}
