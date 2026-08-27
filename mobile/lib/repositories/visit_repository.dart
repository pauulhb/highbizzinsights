import 'package:uuid/uuid.dart';

import '../models/domain_models.dart';
import '../services/local_database.dart';
import '../services/location_service.dart';
import '../services/visit_rules.dart';

class VisitCheckInResult {
  VisitCheckInResult({required this.visit, required this.isLocationException, this.distanceMeters});
  final Visit visit;
  final bool isLocationException;
  final double? distanceMeters;
}

class VisitRepository {
  VisitRepository({LocalDatabase? db, LocationService? locationService})
      : _db = db ?? LocalDatabase.instance,
        _location = locationService ?? LocationService();

  final LocalDatabase _db;
  final LocationService _location;
  final _uuid = const Uuid();

  Future<VisitCheckInResult> checkIn({
    required Customer customer,
    required String kamId,
  }) async {
    final position = await _location.captureCurrentLocation();
    double? distance;
    var exception = false;
    if (customer.hasVerifiedLocation) {
      distance = _location.distanceMeters(
          customer.lat!, customer.lng!, position.latitude, position.longitude);
      exception = !VisitRules.isWithinGeofence(distance);
    }

    final visit = Visit(
      id: _uuid.v4(),
      customerId: customer.id,
      kamId: kamId,
      checkInAt: DateTime.now(),
      checkInLat: position.latitude,
      checkInLng: position.longitude,
      isLocationException: exception,
    );
    await _db.upsertVisit(visit);
    return VisitCheckInResult(
        visit: visit, isLocationException: exception, distanceMeters: distance);
  }

  Future<Visit> checkOut({
    required Visit visit,
    required Customer customer,
    required String discussionNotes,
    required String nextAction,
  }) async {
    final position = await _location.captureCurrentLocation();
    var exception = visit.isLocationException;
    if (customer.hasVerifiedLocation) {
      final distance = _location.distanceMeters(
          customer.lat!, customer.lng!, position.latitude, position.longitude);
      exception = exception || !VisitRules.isWithinGeofence(distance);
    }

    visit
      ..checkOutAt = DateTime.now()
      ..checkOutLat = position.latitude
      ..checkOutLng = position.longitude
      ..discussionNotes = discussionNotes
      ..nextAction = nextAction
      ..isLocationException = exception;

    await _db.upsertVisit(visit);
    await _db.enqueueSync('visit', visit.id);
    return visit;
  }

  Future<List<Visit>> historyFor(String customerId) => _db.visitsForCustomer(customerId);
}
