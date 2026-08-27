class PilotTelemetry {
  // Adapter boundary. In production/UAT, send non-sensitive operational events.
  // Examples:
  // app_open, start_day, customer_created, visit_checkin, visit_checkout,
  // sync_failed, sync_succeeded, report_viewed.
  Future<void> track(String event,{Map<String,dynamic> meta=const {}}) async {
    // Connect to backend pilot-events endpoint or analytics provider.
  }
}
