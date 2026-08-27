import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uuid/uuid.dart';
import 'api_client.dart';
import 'local_db.dart';

class SyncService {
  final ApiClient api;
  SyncService({ApiClient? api}) : api = api ?? ApiClient();

  Future<void> enqueue({
    required String entityType,
    required String entityId,
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    final db = await LocalDb.instance.db;
    await db.insert('sync_queue', {
      'id': const Uuid().v4(),
      'entity_type': entityType,
      'entity_id': entityId,
      'action': action,
      'payload_json': jsonEncode(payload),
      'attempts': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<int> pendingCount() async {
    final db = await LocalDb.instance.db;
    final rows = await db.rawQuery('SELECT COUNT(*) c FROM sync_queue');
    return Sqflite.firstIntValue(rows) ?? 0;
  }

  Future<void> flush() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) return;

    final db = await LocalDb.instance.db;
    final rows = await db.query('sync_queue', orderBy: 'created_at ASC', limit: 100);
    if (rows.isEmpty) return;

    final items = rows.map((r) => {
      'idempotencyKey': r['id'],
      'entityType': r['entity_type'],
      'entityId': r['entity_id'],
      'action': r['action'],
      'payload': jsonDecode(r['payload_json'] as String),
    }).toList();

    final result = await api.post('/sync/batch', {'items': items});
    final processed = <String>{};

    for (final x in List<dynamic>.from(result['results'])) {
      if (x['status'] == 'accepted' || x['status'] == 'already_processed') {
        processed.add(x['idempotencyKey']);
      }
    }

    for (final id in processed) {
      await db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
    }
  }
}
