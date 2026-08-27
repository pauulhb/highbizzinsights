import 'package:flutter/foundation.dart';

import '../models/domain_models.dart';
import '../repositories/auth_repository.dart';

class AppState extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  AppUser? currentUser;
  bool isInitializing = true;

  bool get isLoggedIn => currentUser != null;

  Future<void> init() async {
    currentUser = await _authRepository.restoreSession();
    isInitializing = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    currentUser = await _authRepository.login(email, password);
    notifyListeners();
  }

  Future<void> logout() async {
    await _authRepository.logout();
    currentUser = null;
    notifyListeners();
  }

  bool get canViewHierarchy =>
      currentUser != null && currentUser!.role != UserRole.kam;
}
