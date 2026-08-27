import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  static const accessKey = 'access_token';
  static const refreshKey = 'refresh_token';

  Future<void> save(String access, String refresh) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(accessKey, access);
    await p.setString(refreshKey, refresh);
  }

  Future<String?> access() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(accessKey);
  }

  Future<String?> refresh() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(refreshKey);
  }

  Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(accessKey);
    await p.remove(refreshKey);
  }
}
