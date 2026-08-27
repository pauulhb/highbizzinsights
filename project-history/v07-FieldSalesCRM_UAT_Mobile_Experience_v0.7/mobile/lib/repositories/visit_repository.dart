import '../services/api_client.dart';

class VisitRepository {
  final ApiClient api;
  VisitRepository({ApiClient? api}) : api = api ?? ApiClient();

  Future<Map<String, dynamic>> checkIn({
    required String customerId,
    required double latitude,
    required double longitude,
  }) async {
    final r = await api.post('/visits/check-in', {
      'id': DateTime.now().microsecondsSinceEpoch.toString().padLeft(32, '0').substring(0, 8) +
            '-0000-4000-8000-' +
            DateTime.now().microsecondsSinceEpoch.toString().padLeft(12, '0').substring(0, 12),
      'customerId': customerId,
      'latitude': latitude,
      'longitude': longitude,
    });
    return Map<String, dynamic>.from(r);
  }

  Future<Map<String, dynamic>> checkOut({
    required String visitId,
    required double latitude,
    required double longitude,
    required String discussion,
    required String outcome,
    required String nextAction,
    String? shortVisitReason,
  }) async {
    final r = await api.post('/visits/$visitId/check-out', {
      'latitude': latitude,
      'longitude': longitude,
      'discussion': discussion,
      'outcome': outcome,
      'nextAction': nextAction,
      'shortVisitReason': shortVisitReason,
    });
    return Map<String, dynamic>.from(r);
  }
}
