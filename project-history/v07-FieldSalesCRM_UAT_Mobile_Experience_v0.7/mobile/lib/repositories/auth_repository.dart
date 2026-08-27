import '../models/models.dart';
import '../services/api_client.dart';
import '../services/token_store.dart';

class AuthRepository {
  final ApiClient api;
  final TokenStore tokens;

  AuthRepository({ApiClient? api, TokenStore? tokens})
      : api = api ?? ApiClient(),
        tokens = tokens ?? TokenStore();

  Future<EmployeeSession> login(String employeeCode, String password) async {
    final r = await api.post('/auth/login', {
      'employeeCode': employeeCode,
      'password': password,
    });

    await tokens.saveToken(r['token']);
    return EmployeeSession.fromJson(Map<String, dynamic>.from(r['employee']));
  }
}
