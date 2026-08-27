import 'api_client.dart';

class VisitGuard {
  final ApiClient api;
  VisitGuard({ApiClient? api}) : api = api ?? ApiClient();

  Future<void> ensureNoActiveVisit() async {
    final r = await api.get('/visits/active');
    if(r != null) {
      throw Exception('Complete the current active customer visit before starting another.');
    }
  }
}
