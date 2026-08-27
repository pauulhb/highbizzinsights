import 'package:sqflite/sqflite.dart';
import '../models/domain_models.dart';
import '../services/local_database.dart';

class CustomerRepository {
  Future<void> save(Customer customer) async {
    final db = await LocalDatabase.instance.database;
    await db.insert(
      'customers',
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Customer>> search(String query) async {
    final db = await LocalDatabase.instance.database;
    final q = '%${query.trim()}%';
    final rows = await db.query(
      'customers',
      where:
          'name LIKE ? OR account_name LIKE ? OR city LIKE ? OR area LIKE ? OR phone LIKE ?',
      whereArgs: [q, q, q, q, q],
      orderBy: 'name ASC',
    );
    return rows.map(Customer.fromMap).toList();
  }

  Future<List<Customer>> all() async {
    final db = await LocalDatabase.instance.database;
    final rows = await db.query('customers', orderBy: 'name ASC');
    return rows.map(Customer.fromMap).toList();
  }

  Future<List<Customer>> possibleDuplicates({
    required String name,
    required String city,
    String? phone,
  }) async {
    final db = await LocalDatabase.instance.database;
    final rows = await db.query(
      'customers',
      where:
          '(LOWER(name) = LOWER(?) AND LOWER(city) = LOWER(?)) OR (phone IS NOT NULL AND phone = ?)',
      whereArgs: [name.trim(), city.trim(), phone ?? ''],
    );
    return rows.map(Customer.fromMap).toList();
  }
}
