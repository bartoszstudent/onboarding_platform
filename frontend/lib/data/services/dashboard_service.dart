import 'dart:async';
import '../models/dashboard_models.dart';
class DashboardService {
  static Future<DashboardStats> getStats() async {
    // simulate network latency
    await Future.delayed(const Duration(milliseconds: 600));


    return DashboardStats(courses: 24, employees: 156, avgCompletionHours: 4.5);
  }

  static Future<List<ActivityItem>> getRecentActivities(
      {int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Example mock list matching design
    final mock = [
      ActivityItem(
        user: 'Jan Kowalski',
        action: 'Ukończył kurs',
        course: 'Wprowadzenie do React',
        time: '2 godz. temu',
      ),
      ActivityItem(
        user: 'Anna Nowak',
        action: 'Rozpoczął kurs',
        course: 'TypeScript Podstawy',
        time: '5 godz. temu',
      ),
      ActivityItem(
        user: 'Piotr Wiśniewski',
        action: 'Ukończył kurs',
        course: 'Git i GitHub',
        time: '1 dzień temu',
      ),
      ActivityItem(
        user: 'Maria Lewandowska',
        action: 'Rozpoczęła kurs',
        course: 'CSS Advanced',
        time: '2 dni temu',
      ),
    ];

    return mock.take(limit).toList();
  }
}
