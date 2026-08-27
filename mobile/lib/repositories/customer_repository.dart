import 'package:uuid/uuid.dart';

import '../models/domain_models.dart';
import '../services/local_database.dart';

class CustomerRepository {
  CustomerRepository({LocalDatabase? db}) : _db = db ?? LocalDatabase.instance;

  final LocalDatabase _db;
  final _uuid = const Uuid();

  Future<List<Customer>> search(String query) => _db.searchCustomers(query);

  Future<Customer?> byId(String id) => _db.getCustomer(id);

  Future<Customer> create({
    required String name,
    required CustomerType type,
    required String accountName,
    required String area,
    required String city,
    required String state,
    required String phone,
    required String potential,
    required double lat,
    required double lng,
    required String createdBy,
  }) async {
    final customer = Customer(
      id: _uuid.v4(),
      name: name,
      type: type,
      accountName: accountName,
      area: area,
      city: city,
      state: state,
      phone: phone,
      potential: potential,
      lat: lat,
      lng: lng,
      locationVerifiedAt: DateTime.now(),
      createdBy: createdBy,
      createdAt: DateTime.now(),
    );
    await _db.upsertCustomer(customer);
    await _db.enqueueSync('customer', customer.id);
    return customer;
  }
}
