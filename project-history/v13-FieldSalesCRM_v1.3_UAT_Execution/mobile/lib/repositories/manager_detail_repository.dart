import '../services/api_client.dart';

class ManagerDetailRepository {
  final ApiClient api;
  ManagerDetailRepository({ApiClient? api}):api=api??ApiClient();

  Future<Map<String,dynamic>> kamSummary(String employeeId) async {
    final r=await api.get('/manager/kam/$employeeId/summary');
    return Map<String,dynamic>.from(r);
  }

  Future<List<dynamic>> kamCustomers(String employeeId) async {
    return List<dynamic>.from(
      await api.get('/manager/kam/$employeeId/customers')
    );
  }
}
