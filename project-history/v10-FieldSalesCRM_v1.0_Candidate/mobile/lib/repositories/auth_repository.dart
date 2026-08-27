import '../models/models.dart';
import '../services/api_client.dart';
import '../services/token_store.dart';

class AuthRepository {
  final ApiClient api;
  final TokenStore tokens;

  AuthRepository({ApiClient? api,TokenStore? tokens})
      : api = api ?? ApiClient(),
        tokens = tokens ?? TokenStore();

  Future<EmployeeSession> login(String employeeCode,String password) async {
    final r = await api.post('/auth/login',{
      'employeeCode':employeeCode,
      'password':password
    });
    await tokens.save(r['accessToken'],r['refreshToken']);
    return EmployeeSession.fromJson(Map<String,dynamic>.from(r['employee']));
  }

  Future<void> logout() async {
    final refresh = await tokens.refresh();
    if(refresh != null) {
      try { await api.post('/auth/logout',{'refreshToken':refresh}); } catch(_) {}
    }
    await tokens.clear();
  }
}
