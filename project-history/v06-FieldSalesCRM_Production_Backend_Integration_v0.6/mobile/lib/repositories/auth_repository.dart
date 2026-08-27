import '../services/api_client.dart';
import '../services/token_store.dart';

class AuthRepository {
  final ApiClient api;
  final TokenStore tokens;

  AuthRepository({
    ApiClient? api,
    TokenStore? tokens,
  })  : api = api ?? ApiClient(),
        tokens = tokens ?? TokenStore();

  Future<Map<String, dynamic>> login({
    required String employeeCode,
    required String password,
  }) async {
    final result = await api.post('/auth/login', {
      'employeeCode': employeeCode,
      'password': password,
    });

    await tokens.save(result['token'] as String);
    return Map<String, dynamic>.from(result['employee']);
  }
}
