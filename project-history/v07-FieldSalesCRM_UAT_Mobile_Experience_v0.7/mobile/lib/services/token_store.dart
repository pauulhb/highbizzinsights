import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  static const _tokenKey = 'auth_token';
  static const _employeeKey = 'employee_json';

  Future<void> saveToken(String token) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_tokenKey, token);
  }

  Future<String?> readToken() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_tokenKey);
  }

  Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_tokenKey);
    await p.remove(_employeeKey);
  }
}
