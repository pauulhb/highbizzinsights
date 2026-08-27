import 'package:connectivity_plus/connectivity_plus.dart';

class SyncService {
  Future<bool> hasNetwork() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Future<void> syncPendingRecords() async {
    if (!await hasNetwork()) return;
    // Production: upload pending rows using idempotency keys,
    // apply audit/conflict policy, then mark successful rows synced.
  }
}
