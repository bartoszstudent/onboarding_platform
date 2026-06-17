import 'dart:convert';
import '../models/badge_model.dart';
import 'api_client.dart';
import 'auth_service.dart';
import '../../core/utils/token_manager.dart';

class BadgeService {
  
  /// 1. Pobieranie wszystkich dostępnych w systemie odznak z /api/badges/
  static Future<List<BadgeModel>> fetchAllBadges() async {
    final token = await TokenManager.getToken();
    final response = await ApiClient.get(
      'api/badges/',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => BadgeModel.fromJson(json)).toList();
    } else {
      throw Exception('Nie udało się pobrać konfiguracji odznak z serwera');
    }
  }

  /// 2. Pobieranie pracowników należących do firmy z /companies/{id}/users/
 static Future<List<EmployeeModel>> fetchEmployees() async {
    final token = await TokenManager.getToken();
    final currentUser = await AuthService.getCurrentUser();

    // ZMIANA TUTAJ: używamy currentUser.companyId zamiast currentUser.company
    if (currentUser == null || currentUser.companyId == null) {
      throw Exception('Brak przypisanej firmy lub niezalogowany użytkownik.');
    }

    // Pobieramy ID firmy bezpośrednio z właściwości companyId
    final companyId = currentUser.companyId!;
    
    final response = await ApiClient.get(
      'companies/$companyId/users/',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) {
        return EmployeeModel(
          id: json['user_id'].toString(),
          name: '${json['first_name']} ${json['last_name']}'.trim(),
          role: json['role'] ?? 'Pracownik',
          department: 'Firma', 
          badges: [], // Puste, póki nie zaciągniemy odznak dla każdego pojedynczo
        );
      }).toList();
    } else {
      throw Exception('Brak dostępu do pobierania listy pracowników.');
    }
  }
  /// 3. Ręczne przypisanie odznaki strzałem POST na /api/user-badges/
  static Future<bool> awardBadge(
    String employeeId,
    String badgeId,
    String? message,
  ) async {
    final token = await TokenManager.getToken();
    final response = await ApiClient.post(
      'api/user-badges/',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user': int.parse(employeeId),
        'badge': int.parse(badgeId),
        // Uwaga: 'message' nie jest jeszcze obsługiwane w UserBadgeModel, 
        // ale wysyłamy go bezpiecznie z frontu w razie przyszłej integracji
      }),
    );

    return response.statusCode == 201 || response.statusCode == 200;
  }

  /// 4. Pobieranie odznak przypisanych do konkretnego usera
  static Future<List<BadgeModel>> fetchUserBadges(String userId) async {
    final token = await TokenManager.getToken();
    final response = await ApiClient.get(
      'api/user-badges/?user_id=$userId',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      // Z backendu dostajemy obiekt w polu badge_details nałożony przez serializer
      return data.map((json) => BadgeModel.fromJson(json['badge_details'])).toList();
    }
    return [];
  }
}