import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/environment.dart';
import 'token_store.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

class ApiClient {
  final http.Client client;
  final TokenStore tokens;

  ApiClient({http.Client? client, TokenStore? tokens})
      : client = client ?? http.Client(),
        tokens = tokens ?? TokenStore();

  Uri uri(String path, [Map<String, String>? query]) =>
      Uri.parse('${Environment.apiBaseUrl}$path').replace(queryParameters: query);

  Future<Map<String, String>> headers() async {
    final token = await tokens.readToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final r = await client.get(uri(path, query), headers: await headers());
    return decode(r);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final r = await client.post(
      uri(path),
      headers: await headers(),
      body: jsonEncode(body),
    );
    return decode(r);
  }

  Future<dynamic> patch(String path, Map<String, dynamic> body) async {
    final r = await client.patch(
      uri(path),
      headers: await headers(),
      body: jsonEncode(body),
    );
    return decode(r);
  }

  dynamic decode(http.Response r) {
    final body = r.body.isEmpty ? null : jsonDecode(r.body);
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw ApiException(
        r.statusCode,
        body is Map && body['error'] != null ? body['error'].toString() : 'Request failed',
      );
    }
    return body;
  }
}
