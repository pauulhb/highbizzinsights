import '../config/location_config.dart';
import 'automatic_location_service.dart';

class VisitLocationValidation {
  final CapturedLocation current;
  final double distanceMeters;
  final bool withinGeofence;

  VisitLocationValidation({
    required this.current,
    required this.distanceMeters,
    required this.withinGeofence,
  });
}

class RepeatVisitLocationValidator {
  final AutomaticLocationService gps;

  RepeatVisitLocationValidator({AutomaticLocationService? gps})
      : gps = gps ?? AutomaticLocationService();

  Future<VisitLocationValidation> validate({
    required double registeredLat,
    required double registeredLng,
  }) async {
    final current = await gps.captureCurrentLocation();

    final distance = gps.distanceMeters(
      currentLat: current.latitude,
      currentLng: current.longitude,
      customerLat: registeredLat,
      customerLng: registeredLng,
    );

    return VisitLocationValidation(
      current: current,
      distanceMeters: distance,
      withinGeofence: distance <= LocationConfig.defaultGeofenceMeters,
    );
  }
}
