import 'dart:convert';
import '../models/dashboard_models.dart';
import 'api_client.dart';
import '../../core/utils/token_manager.dart';

class DashboardService {
  // Prosty system zapobiegający dublowaniu zapytań, 
  // gdy ekran renderuje statystyki i aktywności w tym samym czasie
  static Map<String, dynamic>? _cachedData;
  static DateTime? _lastFetch;

  static Future<void> _fetchDashboardDataIfNeeded() async {
    final now = DateTime.now();
    // Odświeżamy dane z serwera, tylko jeśli ostatnie zapytanie było ponad 5 sekund temu
    if (_cachedData != null && _lastFetch != null && now.difference(_lastFetch!).inSeconds < 5) {
      return;
    }

    final token = await TokenManager.getToken();
    final response = await ApiClient.get(
      'api/dashboard/',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      _cachedData = jsonDecode(utf8.decode(response.bodyBytes));
      _lastFetch = now;
    } else {
      throw Exception('Nie udało się pobrać danych dashboardu.');
    }
  }

  static Future<DashboardStats> getStats() async {
    try {
      await _fetchDashboardDataIfNeeded();
      return DashboardStats.fromJson(_cachedData!['stats']);
    } catch (e) {
      // W razie błędów połączenia zwracamy wyzerowany obiekt
      return DashboardStats(courses: 0, employees: 0, avgCompletionHours: 0.0);
    }
  }

  static Future<List<ActivityItem>> getRecentActivities({int limit = 10}) async {
    try {
      await _fetchDashboardDataIfNeeded();
      final List<dynamic> activitiesJson = _cachedData!['activities'] ?? [];
      
      return activitiesJson
          .map((json) => ActivityItem.fromJson(json))
          .take(limit)
          .toList();
    } catch (e) {
      return [];
    }
  }
}