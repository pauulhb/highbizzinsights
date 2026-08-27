import 'package:uuid/uuid.dart';
import '../services/api_client.dart';

class CommercialRepository {
  final ApiClient api;
  CommercialRepository({ApiClient? api}) : api = api ?? ApiClient();

  Future<void> addSample({
    required String customerId,
    required String productName,
    required int quantity,
    String feedbackStatus = 'Awaiting Feedback',
  }) async {
    await api.post('/samples', {
      'id': const Uuid().v4(),
      'customerId': customerId,
      'productName': productName,
      'quantity': quantity,
      'feedbackStatus': feedbackStatus,
    });
  }

  Future<void> addLead({
    required String customerId,
    required String productName,
    required double expectedValue,
    required int probability,
    required String stage,
  }) async {
    await api.post('/leads', {
      'id': const Uuid().v4(),
      'customerId': customerId,
      'productName': productName,
      'expectedValue': expectedValue,
      'probability': probability,
      'stage': stage,
    });
  }

  Future<void> addOrder({
    required String customerId,
    required String productName,
    required int quantity,
    required double orderValue,
  }) async {
    await api.post('/orders', {
      'id': const Uuid().v4(),
      'customerId': customerId,
      'productName': productName,
      'quantity': quantity,
      'orderValue': orderValue,
    });
  }
}
