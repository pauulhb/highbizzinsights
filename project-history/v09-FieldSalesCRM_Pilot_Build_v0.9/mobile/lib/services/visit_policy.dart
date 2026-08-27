class VisitPolicy {
  static const int minQualifiedSeconds = 900;

  static bool qualifies(Duration duration) =>
      duration.inSeconds >= minQualifiedSeconds;

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
