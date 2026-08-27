import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._();
  LocalDatabase._();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = join(await getDatabasesPath(), 'field_sales_crm.db');

    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE customers('
          'id TEXT PRIMARY KEY, type TEXT NOT NULL, name TEXT NOT NULL, '
          'account_name TEXT NOT NULL, area TEXT NOT NULL, city TEXT NOT NULL, '
          'state TEXT NOT NULL, phone TEXT, email TEXT, potential TEXT NOT NULL, '
          'latitude REAL NOT NULL, longitude REAL NOT NULL, '
          'created_by TEXT NOT NULL, created_at TEXT NOT NULL, '
          'sync_status TEXT NOT NULL DEFAULT "pending")'
        );

        await db.execute(
          'CREATE TABLE visits('
          'id TEXT PRIMARY KEY, customer_id TEXT NOT NULL, employee_id TEXT NOT NULL, '
          'check_in_at TEXT NOT NULL, check_out_at TEXT NOT NULL, '
          'check_in_lat REAL NOT NULL, check_in_lng REAL NOT NULL, '
          'check_out_lat REAL NOT NULL, check_out_lng REAL NOT NULL, '
          'discussion TEXT NOT NULL, outcome TEXT NOT NULL, next_action TEXT NOT NULL, '
          'qualified INTEGER NOT NULL, short_visit_reason TEXT, '
          'sync_status TEXT NOT NULL DEFAULT "pending")'
        );

        await db.execute(
          'CREATE TABLE leads('
          'id TEXT PRIMARY KEY, customer_id TEXT NOT NULL, product TEXT NOT NULL, '
          'expected_value REAL NOT NULL, probability INTEGER NOT NULL, stage TEXT NOT NULL, '
          'expected_closure TEXT NOT NULL, sync_status TEXT NOT NULL DEFAULT "pending")'
        );
      },
    );
    return _db!;
  }
}
