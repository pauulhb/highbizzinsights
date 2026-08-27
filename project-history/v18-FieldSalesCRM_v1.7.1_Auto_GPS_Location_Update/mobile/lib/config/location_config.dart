class LocationConfig {
  static const double defaultGeofenceMeters = 200;
  static const double preferredAccuracyMeters = 25;

  // Manual location manipulation is deliberately disabled.
  static const bool allowManualCoordinates = false;
  static const bool allowDraggablePin = false;
  static const bool continuousBackgroundTracking = false;
}
