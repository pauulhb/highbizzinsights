import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/domain_models.dart';

class LocalDatabase {
  LocalDatabase._internal();
  static final LocalDatabase instance = LocalDatabase._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'field_sales_crm.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE customers (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            type TEXT NOT NULL,
            account_name TEXT,
            area TEXT,
            city TEXT,
            state TEXT,
            phone TEXT,
            potential TEXT,
            lat REAL,
            lng REAL,
            location_verified_at TEXT,
            created_by TEXT,
            created_at TEXT NOT NULL,
            synced INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE visits (
            id TEXT PRIMARY KEY,
            customer_id TEXT NOT NULL,
            kam_id TEXT NOT NULL,
            check_in_at TEXT NOT NULL,
            check_out_at TEXT,
            check_in_lat REAL NOT NULL,
            check_in_lng REAL NOT NULL,
            check_out_lat REAL,
            check_out_lng REAL,
            discussion_notes TEXT,
            next_action TEXT,
            is_location_exception INTEGER NOT NULL DEFAULT 0,
            synced INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE commercial_actions (
            id TEXT PRIMARY KEY,
            visit_id TEXT NOT NULL,
            type TEXT NOT NULL,
            fields_json TEXT,
            created_at TEXT NOT NULL,
            synced INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE sync_queue (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            entity_type TEXT NOT NULL,
            entity_id TEXT NOT NULL,
            created_at TEXT NOT NULL,
            attempts INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  // Customers
  Future<void> upsertCustomer(Customer c) async {
    final db = await database;
    await db.insert('customers', c.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Customer>> searchCustomers(String query) async {
    final db = await database;
    final rows = query.trim().isEmpty
        ? await db.query('customers', orderBy: 'created_at DESC')
        : await db.query(
            'customers',
            where:
                'name LIKE ? OR account_name LIKE ? OR city LIKE ? OR area LIKE ? OR phone LIKE ?',
            whereArgs: List.filled(5, '%$query%'),
            orderBy: 'created_at DESC',
          );
    return rows.map(Customer.fromMap).toList();
  }

  Future<Customer?> getCustomer(String id) async {
    final db = await database;
    final rows = await db.query('customers', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Customer.fromMap(rows.first);
  }

  // Visits
  Future<void> upsertVisit(Visit v) async {
    final db = await database;
    await db.insert('visits', v.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Visit>> visitsForCustomer(String customerId) async {
    final db = await database;
    final rows = await db.query('visits',
        where: 'customer_id = ?',
        whereArgs: [customerId],
        orderBy: 'check_in_at DESC');
    return rows.map(Visit.fromMap).toList();
  }

  Future<List<Visit>> visitsBetween(DateTime start, DateTime end) async {
    final db = await database;
    final rows = await db.query(
      'visits',
      where: 'check_in_at >= ? AND check_in_at <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'check_in_at DESC',
    );
    return rows.map(Visit.fromMap).toList();
  }

  Future<List<Visit>> allVisits() async {
    final db = await database;
    final rows = await db.query('visits', orderBy: 'check_in_at DESC');
    return rows.map(Visit.fromMap).toList();
  }

  // Commercial actions
  Future<void> insertCommercialAction(CommercialAction a) async {
    final db = await database;
    await db.insert('commercial_actions', a.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CommercialAction>> actionsForVisit(String visitId) async {
    final db = await database;
    final rows = await db.query('commercial_actions',
        where: 'visit_id = ?', whereArgs: [visitId]);
    return rows.map(CommercialAction.fromMap).toList();
  }

  Future<List<CommercialAction>> allCommercialActions() async {
    final db = await database;
    final rows = await db.query('commercial_actions', orderBy: 'created_at DESC');
    return rows.map(CommercialAction.fromMap).toList();
  }

  // Sync queue
  Future<void> enqueueSync(String entityType, String entityId) async {
    final db = await database;
    await db.insert('sync_queue', {
      'entity_type': entityType,
      'entity_id': entityId,
      'created_at': DateTime.now().toIso8601String(),
      'attempts': 0,
    });
  }

  Future<List<SyncQueueItem>> pendingSync() async {
    final db = await database;
    final rows = await db.query('sync_queue', orderBy: 'created_at ASC');
    return rows.map(SyncQueueItem.fromMap).toList();
  }

  Future<void> removeFromQueue(int id) async {
    final db = await database;
    await db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> bumpAttempts(int id) async {
    final db = await database;
    await db.rawUpdate(
        'UPDATE sync_queue SET attempts = attempts + 1 WHERE id = ?', [id]);
  }

  Future<void> markCustomerSynced(String id) async {
    final db = await database;
    await db.update('customers', {'synced': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> markVisitSynced(String id) async {
    final db = await database;
    await db.update('visits', {'synced': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> markActionSynced(String id) async {
    final db = await database;
    await db.update('commercial_actions', {'synced': 1},
        where: 'id = ?', whereArgs: [id]);
  }
}
