import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDb {
  static final LocalDb instance = LocalDb._();
  LocalDb._();
  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await openDatabase(
      join(await getDatabasesPath(), 'field_sales_uat.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE sync_queue('
          'id TEXT PRIMARY KEY, entity_type TEXT NOT NULL, entity_id TEXT NOT NULL, '
          'action TEXT NOT NULL, payload_json TEXT NOT NULL, attempts INTEGER NOT NULL DEFAULT 0, '
          'created_at TEXT NOT NULL)'
        );

        await db.execute(
          'CREATE TABLE cached_customers('
          'id TEXT PRIMARY KEY, payload_json TEXT NOT NULL, updated_at TEXT NOT NULL)'
        );

        await db.execute(
          'CREATE TABLE cached_timeline('
          'customer_id TEXT NOT NULL, payload_json TEXT NOT NULL, updated_at TEXT NOT NULL)'
        );
      },
    );
    return _db!;
  }
}
