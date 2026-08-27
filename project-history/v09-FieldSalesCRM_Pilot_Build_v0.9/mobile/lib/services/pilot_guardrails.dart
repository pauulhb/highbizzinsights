class PilotGuardrails {
  // Pilot controls to validate before live use.
  static const bool preventParallelVisits = true;
  static const bool requireGpsAtCheckIn = true;
  static const bool requireGpsAtCheckOut = true;
  static const bool requireDiscussion = true;
  static const bool requireNextAction = true;
  static const bool requireShortVisitReason = true;
  static const bool continuousBackgroundTracking = false;
}
