import '../services/api_client.dart';

class TerritoryRepository {
  final ApiClient api;
  TerritoryRepository({ApiClient? api}):api=api??ApiClient();

  Future<List<dynamic>> list() async =>
      List<dynamic>.from(await api.get('/territories'));
}
