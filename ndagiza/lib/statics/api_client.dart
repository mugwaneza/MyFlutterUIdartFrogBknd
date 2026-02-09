import 'dart:convert';
import 'package:http/http.dart' as http;
import '../security/app_auth.dart';

class ApiClient {
  static Future<http.Response> get(String url) async {
    final token = await AppAuth.getToken();

    return http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  static Future<http.Response> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    final token = await AppAuth.getToken();

    return http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }
}
