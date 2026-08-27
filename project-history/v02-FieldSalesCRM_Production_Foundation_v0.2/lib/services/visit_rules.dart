class VisitRules {
  static const int minimumQualifiedMinutes = 15;
  static const double defaultGeofenceMeters = 200;

  static bool isQualified(Duration duration) =>
      duration.inSeconds >= minimumQualifiedMinutes * 60;

  static bool requiresShortVisitReason(Duration duration) =>
      !isQualified(duration);

  static const List<String> shortVisitReasons = [
    'Doctor unavailable',
    'Emergency / clinical priority',
    'Purchase team unavailable',
    'Sample / document drop only',
    'Customer requested short meeting',
    'Meeting moved to alternate location',
    'Other',
  ];
}
