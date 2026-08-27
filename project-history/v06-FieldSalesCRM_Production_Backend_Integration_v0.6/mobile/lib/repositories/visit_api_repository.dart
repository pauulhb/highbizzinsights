import 'package:uuid/uuid.dart';
import '../services/api_client.dart';

class VisitApiRepository {
  final ApiClient api;
  VisitApiRepository({ApiClient? api}) : api = api ?? ApiClient();

  Future<Map<String, dynamic>> checkIn({
    required String customerId,
    required double latitude,
    required double longitude,
  }) async {
    final result = await api.post('/visits/check-in', {
      'id': const Uuid().v4(),
      'customerId': customerId,
      'latitude': latitude,
      'longitude': longitude,
    });

    return Map<String, dynamic>.from(result);
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
    final result = await api.post('/visits/$visitId/check-out', {
      'latitude': latitude,
      'longitude': longitude,
      'discussion': discussion,
      'outcome': outcome,
      'nextAction': nextAction,
      'shortVisitReason': shortVisitReason,
    });

    return Map<String, dynamic>.from(result);
  }
}
