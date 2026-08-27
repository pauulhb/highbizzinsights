import 'dart:convert';

import 'package:http/http.dart' as http;

import 'token_store.dart';

/// Thin REST wrapper. The app is offline-first: every write lands in the
/// local database immediately and is queued here for best-effort sync.
/// If [baseUrl] is unreachable, callers should catch [ApiException] and
/// keep the item queued rather than fail the user action.
class ApiClient {
  ApiClient({this.baseUrl = 'https://api.fieldsalescrm.example.com'});

  final String baseUrl;
  final TokenStore _tokenStore = TokenStore();

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStore.readToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> body) async {
    try {
      final resp = await http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: await _headers(),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        if (resp.body.isEmpty) return {};
        return jsonDecode(resp.body) as Map<String, dynamic>;
      }
      throw ApiException('Server returned ${resp.statusCode}');
    } catch (e) {
      throw ApiException('Network unavailable: $e');
    }
  }

  Future<Map<String, dynamic>> get(String path) async {
    try {
      final resp = await http
          .get(Uri.parse('$baseUrl$path'), headers: await _headers())
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        if (resp.body.isEmpty) return {};
        return jsonDecode(resp.body) as Map<String, dynamic>;
      }
      throw ApiException('Server returned ${resp.statusCode}');
    } catch (e) {
      throw ApiException('Network unavailable: $e');
    }
  }
}

class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}
