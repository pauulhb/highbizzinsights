/// Business rules shared across the whole FieldSalesCRM version history:
/// - Qualified/Productive visit needs at least 15 minutes / 900 seconds.
/// - A configurable geofence (default 200m) compares live GPS against the
///   customer's verified location; outside it, the visit is flagged as a
///   Location Exception but is still recorded, never blocked.
class VisitRules {
  static const int qualifiedSeconds = 900;
  static const double defaultGeofenceMeters = 200;

  static bool isQualified(Duration duration) =>
      duration.inSeconds >= qualifiedSeconds;

  static bool isWithinGeofence(double distanceMeters,
      {double geofenceMeters = defaultGeofenceMeters}) {
    return distanceMeters <= geofenceMeters;
  }
}
