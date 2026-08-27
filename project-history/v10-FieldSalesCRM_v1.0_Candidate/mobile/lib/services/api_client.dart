import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'token_store.dart';

class ApiClient {
  final http.Client client;
  final TokenStore tokens;

  ApiClient({http.Client? client, TokenStore? tokens})
      : client = client ?? http.Client(),
        tokens = tokens ?? TokenStore();

  Uri uri(String path,[Map<String,String>? query]) =>
      Uri.parse('${AppConfig.apiBaseUrl}$path').replace(queryParameters: query);

  Future<Map<String,String>> headers() async {
    final t = await tokens.access();
    return {
      'Content-Type':'application/json',
      if(t != null) 'Authorization':'Bearer $t',
    };
  }

  Future<dynamic> get(String path,{Map<String,String>? query}) async {
    final r = await client.get(uri(path,query),headers:await headers());
    return _decode(r);
  }

  Future<dynamic> post(String path,Map<String,dynamic> body) async {
    var r = await client.post(uri(path),headers:await headers(),body:jsonEncode(body));
    if(r.statusCode == 401 && await _tryRefresh()) {
      r = await client.post(uri(path),headers:await headers(),body:jsonEncode(body));
    }
    return _decode(r);
  }

  Future<dynamic> patch(String path,Map<String,dynamic> body) async {
    var r = await client.patch(uri(path),headers:await headers(),body:jsonEncode(body));
    if(r.statusCode == 401 && await _tryRefresh()) {
      r = await client.patch(uri(path),headers:await headers(),body:jsonEncode(body));
    }
    return _decode(r);
  }

  Future<bool> _tryRefresh() async {
    final refresh = await tokens.refresh();
    if(refresh == null) return false;
    final r = await client.post(
      uri('/auth/refresh'),
      headers:{'Content-Type':'application/json'},
      body:jsonEncode({'refreshToken':refresh}),
    );
    if(r.statusCode < 200 || r.statusCode >= 300) return false;
    final j = jsonDecode(r.body);
    await tokens.save(j['accessToken'],j['refreshToken']);
    return true;
  }

  dynamic _decode(http.Response r) {
    final body = r.body.isEmpty ? null : jsonDecode(r.body);
    if(r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception(
        body is Map && body['error'] != null ? body['error'].toString() : 'Request failed'
      );
    }
    return body;
  }
}
