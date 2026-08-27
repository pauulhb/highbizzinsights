import '../models/domain_models.dart';
import 'api_client.dart';
import 'local_database.dart';

/// Pushes queued mutations to the backend. Best-effort and idempotent by
/// entity id — never duplicates a visit or order on retry. Safe to call
/// with no connectivity: failures just leave items queued.
class SyncService {
  SyncService({ApiClient? apiClient, LocalDatabase? db})
      : _api = apiClient ?? ApiClient(),
        _db = db ?? LocalDatabase.instance;

  final ApiClient _api;
  final LocalDatabase _db;

  Future<SyncResult> syncNow() async {
    final items = await _db.pendingSync();
    var succeeded = 0;
    var failed = 0;

    for (final item in items) {
      try {
        await _pushOne(item);
        if (item.id != null) await _db.removeFromQueue(item.id!);
        succeeded++;
      } catch (_) {
        if (item.id != null) await _db.bumpAttempts(item.id!);
        failed++;
      }
    }
    return SyncResult(succeeded: succeeded, failed: failed);
  }

  Future<void> _pushOne(SyncQueueItem item) async {
    switch (item.entityType) {
      case 'customer':
        final c = await _db.getCustomer(item.entityId);
        if (c == null) return;
        await _api.post('/customers', {
          'idempotency_key': c.id,
          ...c.toMap(),
        });
        await _db.markCustomerSynced(c.id);
        break;
      case 'visit':
        final visits = await _db.allVisits();
        final matches = visits.where((visit) => visit.id == item.entityId).toList();
        if (matches.isEmpty) return;
        final visit = matches.first;
        await _api.post('/visits/sync', {
          'idempotency_key': visit.id,
          ...visit.toMap(),
        });
        await _db.markVisitSynced(visit.id);
        break;
      case 'commercial_action':
        await _api.post('/commercial/sync', {
          'idempotency_key': item.entityId,
        });
        await _db.markActionSynced(item.entityId);
        break;
      default:
        break;
    }
  }
}

class SyncResult {
  SyncResult({required this.succeeded, required this.failed});
  final int succeeded;
  final int failed;
  bool get hadPendingWork => succeeded + failed > 0;
}
