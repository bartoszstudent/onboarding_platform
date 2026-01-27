import 'dart:convert';
import 'api_client.dart';
import '../models/company_model.dart';

class CompanyService {
  /// Tworzy nową firmę
  static Future<Company> createCompany({
    required String name,
    required String domain,
    String? logoUrl,
    String? primaryColor,
    String? secondaryColor,
    String? accentColor,
  }) async {
    final company = Company(
      name: name,
      domain: domain,
      logoUrl: logoUrl,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      accentColor: accentColor,
    );

    final response = await ApiClient.post(
      'api/companies/',
      body: jsonEncode(company.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return Company.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Błąd tworzenia firmy: ${response.body}');
    }
  }

  /// Pobiera listę wszystkich firm
  static Future<List<Company>> listCompanies() async {
    final response = await ApiClient.get('api/companies/list/');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Company.fromJson(json)).toList();
    } else {
      throw Exception('Błąd pobierania firm: ${response.body}');
    }
  }

  /// Pobiera szczegóły jednej firmy
  static Future<Company> getCompany(int id) async {
    final response = await ApiClient.get('api/companies/$id/');

    if (response.statusCode == 200) {
      return Company.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Błąd pobierania firmy: ${response.body}');
    }
  }
}
