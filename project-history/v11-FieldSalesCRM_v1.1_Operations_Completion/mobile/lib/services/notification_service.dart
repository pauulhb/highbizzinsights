class NotificationService {
  // Adapter boundary for local notifications / push notifications.
  // Production credentials are intentionally not embedded.
  Future<void> scheduleFollowUp({
    required String id,
    required String title,
    required String body,
    required DateTime dueAt,
  }) async {
    // Connect chosen notification plugin/provider here.
  }
}
