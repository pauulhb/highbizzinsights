import 'package:geolocator/geolocator.dart';

class CapturedLocation {
  final double latitude;
  final double longitude;
  final double accuracyMeters;
  final DateTime capturedAt;

  CapturedLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.capturedAt,
  });
}

class AutomaticLocationService {
  Future<CapturedLocation> captureCurrentLocation() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw Exception('Location services are disabled on this device.');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission is required to verify field visits.');
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return CapturedLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracyMeters: position.accuracy,
      capturedAt: DateTime.now(),
    );
  }

  double distanceMeters({
    required double currentLat,
    required double currentLng,
    required double customerLat,
    required double customerLng,
  }) {
    return Geolocator.distanceBetween(
      currentLat,
      currentLng,
      customerLat,
      customerLng,
    );
  }
}
