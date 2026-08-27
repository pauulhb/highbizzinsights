import 'package:connectivity_plus/connectivity_plus.dart';

enum SyncEntityType { customer, customerLocation, visit, sample, lead, order, followUp, audit }

class SyncQueueItem {
  final String id;
  final SyncEntityType entityType;
  final String entityId;
  final String action;
  final String payloadJson;
  final DateTime createdAt;
  int attempts;

  SyncQueueItem({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.payloadJson,
    required this.createdAt,
    this.attempts = 0,
  });
}

class SyncQueueService {
  final List<SyncQueueItem> queue = [];

  Future<bool> hasNetwork() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  void enqueue(SyncQueueItem item) {
    queue.add(item);
  }

  Future<void> process() async {
    if (!await hasNetwork()) return;

    final pending = List<SyncQueueItem>.from(queue);
    for (final item in pending) {
      try {
        // Production: send item to REST API with idempotency key = item.id.
        // On HTTP 2xx, remove from queue.
        queue.remove(item);
      } catch (_) {
        item.attempts += 1;
      }
    }
  }
}
