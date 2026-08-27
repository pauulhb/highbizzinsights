import '../services/api_client.dart';

class ReportApiRepository {
  final ApiClient api;
  ReportApiRepository({ApiClient? api}) : api = api ?? ApiClient();

  Future<Map<String, dynamic>> performance({
    String period = 'daily',
    String? employeeId,
  }) async {
    final result = await api.get(
      '/reports/performance',
      query: {
        'period': period,
        if (employeeId != null) 'employee_id': employeeId,
      },
    );
    return Map<String, dynamic>.from(result);
  }
}
