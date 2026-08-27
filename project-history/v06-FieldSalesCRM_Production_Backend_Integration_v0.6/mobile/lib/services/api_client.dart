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
  final http.Client httpClient;
  final TokenStore tokenStore;

  ApiClient({
    http.Client? httpClient,
    TokenStore? tokenStore,
  })  : httpClient = httpClient ?? http.Client(),
        tokenStore = tokenStore ?? TokenStore();

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('${Environment.apiBaseUrl}$path')
          .replace(queryParameters: query);

  Future<Map<String, String>> _headers() async {
    final token = await tokenStore.read();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final response = await httpClient.get(
      _uri(path, query),
      headers: await _headers(),
    );
    return _decode(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final response = await httpClient.post(
      _uri(path),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  dynamic _decode(http.Response response) {
    final body = response.body.isEmpty ? null : jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        response.statusCode,
        body is Map && body['error'] != null
            ? body['error'].toString()
            : 'Request failed',
      );
    }
    return body;
  }
}
