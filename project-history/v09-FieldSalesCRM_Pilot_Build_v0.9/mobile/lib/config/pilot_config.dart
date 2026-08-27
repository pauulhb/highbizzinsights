class PilotConfig {
  static const String appName = 'Field Sales CRM';
  static const bool brandNeutral = true;

  static const int minimumQualifiedVisitSeconds = 900;
  static const double defaultGeofenceMeters = 200;

  static const List<String> reportPeriods = [
    'daily','weekly','monthly','quarterly','yearly'
  ];

  static const List<String> customerTypes = [
    'doctor','hospital','distributor'
  ];
}
