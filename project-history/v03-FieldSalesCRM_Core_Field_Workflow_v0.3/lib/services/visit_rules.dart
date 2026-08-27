class VisitRules {
  static const int minimumQualifiedSeconds = 900;
  static const double defaultGeofenceMeters = 200;

  static bool isQualified(Duration duration) =>
      duration.inSeconds >= minimumQualifiedSeconds;

  static bool isWithinGeofence(double distanceMeters) =>
      distanceMeters <= defaultGeofenceMeters;

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
