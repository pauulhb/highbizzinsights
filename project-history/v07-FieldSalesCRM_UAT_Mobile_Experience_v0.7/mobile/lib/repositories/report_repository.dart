import '../models/models.dart';
import '../services/api_client.dart';

class ReportRepository {
  final ApiClient api;
  ReportRepository({ApiClient? api}) : api = api ?? ApiClient();

  Future<PerformanceSnapshot> performance(String period) async {
    final r = await api.get('/reports/performance', query: {'period': period});
    return PerformanceSnapshot.fromJson(Map<String, dynamic>.from(r));
  }
}
