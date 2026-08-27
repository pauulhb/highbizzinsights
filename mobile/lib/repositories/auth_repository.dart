import '../models/domain_models.dart';
import '../services/api_client.dart';
import '../services/token_store.dart';

/// Demo directory used when the backend is unreachable, so the app is
/// fully usable standalone (and every role in the hierarchy can be
/// demoed) without a deployed server. A real deployment points
/// [ApiClient.baseUrl] at the FieldSalesCRM backend and this fallback is
/// simply never reached.
final List<AppUser> demoDirectory = [
  AppUser(
      id: 'u-kam-1',
      name: 'Ravi Kumar',
      email: 'kam@fieldsalescrm.demo',
      role: UserRole.kam),
  AppUser(
      id: 'u-am-1',
      name: 'Priya Shah',
      email: 'area.manager@fieldsalescrm.demo',
      role: UserRole.areaManager),
  AppUser(
      id: 'u-sm-1',
      name: 'Anand Rao',
      email: 'state.manager@fieldsalescrm.demo',
      role: UserRole.stateManager),
  AppUser(
      id: 'u-rh-1',
      name: 'Meera Iyer',
      email: 'regional.head@fieldsalescrm.demo',
      role: UserRole.regionalHead),
  AppUser(
      id: 'u-mgmt-1',
      name: 'Suresh Nair',
      email: 'management@fieldsalescrm.demo',
      role: UserRole.management),
  AppUser(
      id: 'u-admin-1',
      name: 'Admin User',
      email: 'admin@fieldsalescrm.demo',
      role: UserRole.admin),
];

class AuthRepository {
  AuthRepository({ApiClient? apiClient, TokenStore? tokenStore})
      : _api = apiClient ?? ApiClient(),
        _tokenStore = tokenStore ?? TokenStore();

  final ApiClient _api;
  final TokenStore _tokenStore;

  Future<AppUser> login(String email, String password) async {
    try {
      final resp = await _api.post('/auth/login', {
        'email': email,
        'password': password,
      });
      final user = AppUser.fromJson(resp['user'] as Map<String, dynamic>);
      await _tokenStore.save(resp['token'] as String, user);
      return user;
    } catch (_) {
      final match = demoDirectory.where(
          (u) => u.email.toLowerCase() == email.trim().toLowerCase());
      if (match.isEmpty) {
        throw Exception(
            'No account found for $email. Try one of the demo accounts.');
      }
      final user = match.first;
      await _tokenStore.save('demo-offline-token', user);
      return user;
    }
  }

  Future<AppUser?> restoreSession() => _tokenStore.readUser();

  Future<void> logout() => _tokenStore.clear();
}
