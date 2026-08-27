class AppConfig {
  static const String appName = 'Field Sales CRM';
  static const bool brandNeutral = true;

  static const int minQualifiedVisitSeconds = 900;
  static const double defaultGeofenceMeters = 200;

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080/v1',
  );

  static const List<String> reportPeriods = [
    'daily','weekly','monthly','quarterly','yearly'
  ];
}
