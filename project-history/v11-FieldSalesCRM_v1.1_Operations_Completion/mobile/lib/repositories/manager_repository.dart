import '../services/api_client.dart';

class ManagerRepository {
  final ApiClient api;
  ManagerRepository({ApiClient? api}):api=api??ApiClient();

  Future<List<dynamic>> states() async =>
      List<dynamic>.from(await api.get('/manager/states'));

  Future<List<dynamic>> hqs() async =>
      List<dynamic>.from(await api.get('/manager/hqs'));

  Future<List<dynamic>> kams() async =>
      List<dynamic>.from(await api.get('/manager/kams'));
}
