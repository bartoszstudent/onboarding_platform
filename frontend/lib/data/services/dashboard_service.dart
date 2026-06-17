import 'dart:convert';
import 'dart:math';
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
  static Future<List<double>> getWeeklyActivity() async {
    try {
      final token = await TokenManager.getToken();
      final response = await ApiClient.get(
        'api/gamification/analytics/',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        
        // Backend zwraca 7-elementową tablicę 'weekly_xp' (Pn-Nd)
        final List<dynamic> weeklyXp = data['weekly_xp'] ?? [0, 0, 0, 0, 0, 0, 0];
        List<double> values = weeklyXp.map((e) => (e as num).toDouble()).toList();
        
        // Szukamy wartości maksymalnej, aby znormalizować słupki (max słupek = 100% wysokości kontenera)
        double maxVal = values.reduce(max);
        if (maxVal == 0) return List.generate(7, (index) => 0.05); // Zabezpieczenie, by chociaż linia 5% była widoczna dla pustych dni
        
        // Przekształcamy XP na ułamki od 0.0 do 1.0 (minimalna wysokość słupka to 0.05 by zawsze był widoczny punkt zaczepienia)
        return values.map((e) => (e / maxVal) > 0.05 ? (e / maxVal) : 0.05).toList();
      } else {
        return List.generate(7, (index) => 0.05);
      }
    } catch (e) {
      return List.generate(7, (index) => 0.05);
    }
  }
  /// Pobiera listę ostatnich osiągnięć (aktywności XP) dla osi czasu w profilu pracownika
  static Future<List<Map<String, String>>> getRecentAchievements() async {
    try {
      final token = await TokenManager.getToken();
      final response = await ApiClient.get(
        'api/gamification/analytics/',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        
        // Zwracamy listę z backendu (domyślnie pustą, jeśli jej brakuje)
        final List<dynamic> recent = data['recent_activities'] ?? [];
        
        return recent.map<Map<String, String>>((item) {
          // Formatowanie daty z backendu np. "2026-06-17T09:51:00Z" na "17.06.2026"
          String dateStr = '';
          if (item['created_at'] != null) {
            DateTime dt = DateTime.parse(item['created_at']);
            dateStr = "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}";
          }
          
          String reason = item['reason'] ?? 'Aktywność na platformie';
          int amount = item['amount'] ?? 0;
          
          // Ustawianie ikon na podstawie słów kluczowych w uzasadnieniu z bazy
          String icon = "⚡"; // Domyślna ikona zdobytych XP
          if (reason.toLowerCase().contains("odznaka")) icon = "🏆";
          if (reason.toLowerCase().contains("quiz")) icon = "📝";
          if (reason.toLowerCase().contains("kurs")) icon = "🎓";
          
          return {
            "date": dateStr,
            "title": "Zdobyto $amount XP",
            "desc": reason,
            "icon": icon,
          };
        }).toList();
      }
    } catch (e) {
      throw Exception('Błąd pobierania historii osiągnięć: $e');
    }
    return [];
  }
}