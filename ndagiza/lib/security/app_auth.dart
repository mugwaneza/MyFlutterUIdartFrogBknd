import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ndagiza/statics/ApiUrls.dart';

class AppAuth {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'app_token';

  static Future<void> init() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null) {
      await _requestToken();
    }
  }

  static Future<void> _requestToken() async {
    final response = await http.post(
      Uri.parse(ApiUrls.appToken),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'appId': 'nozasecretId-api'}),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      await _storage.write(key: _tokenKey, value: token);
    } else {
      throw Exception('App authentication failed');
    }
  }

  static Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }
}
