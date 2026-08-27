import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../services/api_client.dart';
import '../services/local_db.dart';
import '../services/sync_service.dart';

class CustomerRepository {
  final ApiClient api;
  final SyncService sync;

  CustomerRepository({ApiClient? api, SyncService? sync})
      : api = api ?? ApiClient(),
        sync = sync ?? SyncService();

  Future<List<Customer>> search(String q) async {
    try {
      final r = await api.get('/customers', query: {'q': q});
      final list = List<dynamic>.from(r)
          .map((x) => Customer.fromJson(Map<String, dynamic>.from(x)))
          .toList();

      final db = await LocalDb.instance.db;
      for (final c in list) {
        await db.insert(
          'cached_customers',
          {
            'id': c.id,
            'payload_json': jsonEncode({
              'id': c.id,
              'customer_type': c.customerType,
              'name': c.name,
              'account_name': c.accountName,
              'area': c.area,
              'city': c.city,
              'state': c.state,
              'potential': c.potential,
              'phone': c.phone,
              'email': c.email,
              'latitude': c.latitude,
              'longitude': c.longitude,
            }),
            'updated_at': DateTime.now().toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      return list;
    } catch (_) {
      final db = await LocalDb.instance.db;
      final rows = await db.query('cached_customers');
      return rows
          .map((r) => Customer.fromJson(jsonDecode(r['payload_json'] as String)))
          .where((c) {
            final x = q.toLowerCase();
            return c.name.toLowerCase().contains(x) ||
                c.accountName.toLowerCase().contains(x) ||
                c.city.toLowerCase().contains(x) ||
                c.area.toLowerCase().contains(x) ||
                (c.phone ?? '').contains(q);
          })
          .toList();
    }
  }

  Future<Customer> create({
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
    final id = const Uuid().v4();
    final payload = {
      'id': id,
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
    };

    try {
      final r = await api.post('/customers', payload);
      return Customer.fromJson(Map<String, dynamic>.from(r));
    } catch (_) {
      await sync.enqueue(
        entityType: 'customer',
        entityId: id,
        action: 'create',
        payload: payload,
      );
      return Customer(
        id: id,
        customerType: customerType,
        name: name,
        accountName: accountName,
        area: area,
        city: city,
        state: state,
        potential: potential,
        phone: phone,
        email: email,
        latitude: latitude,
        longitude: longitude,
      );
    }
  }

  Future<List<TimelineItem>> timeline(String customerId) async {
    final r = await api.get('/customers/$customerId/timeline');
    return List<dynamic>.from(r)
        .map((x) => TimelineItem.fromJson(Map<String, dynamic>.from(x)))
        .toList();
  }
}
