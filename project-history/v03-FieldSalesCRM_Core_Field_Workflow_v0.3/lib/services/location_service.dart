import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> currentPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw Exception('Location services are disabled.');

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission is required.');
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  double distanceMeters({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) =>
      Geolocator.distanceBetween(fromLat, fromLng, toLat, toLng);
}
