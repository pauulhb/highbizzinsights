import 'package:uuid/uuid.dart';
import '../services/api_client.dart';

class CustomerApiRepository {
  final ApiClient api;
  CustomerApiRepository({ApiClient? api}) : api = api ?? ApiClient();

  Future<List<dynamic>> search(String query) async {
    final result = await api.get('/customers', query: {'q': query});
    return List<dynamic>.from(result);
  }

  Future<Map<String, dynamic>> create({
    required String customerType,
    required String name,
    required String accountName,
    required String area,
    required String city,
    required String state,
    required String potential,
    String? phone,
    String? email,
    required double latitude,
    required double longitude,
  }) async {
    final result = await api.post('/customers', {
      'id': const Uuid().v4(),
      'customerType': customerType,
      'name': name,
      'accountName': accountName,
      'area': area,
      'city': city,
      'state': state,
      'potential': potential,
      'phone': phone,
      'email': email,
      'latitude': latitude,
      'longitude': longitude,
    });

    return Map<String, dynamic>.from(result);
  }

  Future<List<dynamic>> timeline(String customerId) async {
    final result = await api.get('/customers/$customerId/timeline');
    return List<dynamic>.from(result);
  }
}
