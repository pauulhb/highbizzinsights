import 'package:flutter/material.dart';
import '../services/automatic_location_service.dart';

class LocationStatusCard extends StatelessWidget {
  final CapturedLocation? location;
  final bool verified;
  final double? distanceMeters;
  final bool? withinGeofence;

  const LocationStatusCard({
    super.key,
    this.location,
    this.verified = false,
    this.distanceMeters,
    this.withinGeofence,
  });

  @override
  Widget build(BuildContext context) {
    if (location == null) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.location_searching),
          title: Text('Location not captured'),
          subtitle: Text('Tap Capture Current Location to use device GPS.'),
        ),
      );
    }

    return Card(
      child: ListTile(
        leading: Icon(
          verified ? Icons.verified_outlined : Icons.location_on_outlined,
        ),
        title: Text(verified ? 'GPS Location Verified' : 'GPS Location Captured'),
        subtitle: Text(
          [
            'Accuracy: ±${location!.accuracyMeters.toStringAsFixed(0)} m',
            'Captured: ${location!.capturedAt}',
            if (distanceMeters != null)
              'Distance from registered location: ${distanceMeters!.toStringAsFixed(0)} m',
            if (withinGeofence != null)
              withinGeofence! ? 'Within Approved Location' : 'Location Exception',
          ].join('\n'),
        ),
        isThreeLine: true,
      ),
    );
  }
}
