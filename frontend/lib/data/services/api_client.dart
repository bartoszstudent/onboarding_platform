import 'package:http/http.dart' as http;

class ApiClient {
  static const baseUrl = 'https://api.onboardly.app';

  static Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) {
    return http.get(Uri.parse('$baseUrl/$endpoint'), headers: headers);
  }

  static Future<http.Response> post(
    String endpoint, {
    Object? body,
    Map<String, String>? headers,
  }) {
    return http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
      body: body,
    );
  }
}
