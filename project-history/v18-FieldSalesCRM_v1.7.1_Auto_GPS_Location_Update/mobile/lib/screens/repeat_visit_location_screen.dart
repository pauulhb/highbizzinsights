import 'package:flutter/material.dart';
import '../services/repeat_visit_location_validator.dart';
import '../widgets/location_status_card.dart';

class RepeatVisitLocationScreen extends StatefulWidget {
  final String customerName;
  final double registeredLat;
  final double registeredLng;

  const RepeatVisitLocationScreen({
    super.key,
    required this.customerName,
    required this.registeredLat,
    required this.registeredLng,
  });

  @override
  State<RepeatVisitLocationScreen> createState() =>
      _RepeatVisitLocationScreenState();
}

class _RepeatVisitLocationScreenState
    extends State<RepeatVisitLocationScreen> {
  VisitLocationValidation? result;
  bool busy = false;

  Future<void> check() async {
    try {
      setState(() => busy = true);

      result = await RepeatVisitLocationValidator().validate(
        registeredLat: widget.registeredLat,
        registeredLng: widget.registeredLng,
      );

      setState(() {});
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Location')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.customerName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          LocationStatusCard(
            location: result?.current,
            verified: result?.withinGeofence == true,
            distanceMeters: result?.distanceMeters,
            withinGeofence: result?.withinGeofence,
          ),

          if (result != null && !result!.withinGeofence)
            const Card(
              child: ListTile(
                leading: Icon(Icons.warning_amber_outlined),
                title: Text('Location Exception'),
                subtitle: Text(
                  'Your current position is outside the approved customer geofence. '
                  'The visit may continue, but management will see it as a location exception.',
                ),
              ),
            ),

          const SizedBox(height: 12),

          FilledButton.icon(
            onPressed: busy ? null : check,
            icon: const Icon(Icons.my_location),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('CHECK LOCATION STATUS'),
            ),
          ),

          if (result != null) ...[
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () => Navigator.pop(context, {
                'latitude': result!.current.latitude,
                'longitude': result!.current.longitude,
                'accuracyMeters': result!.current.accuracyMeters,
                'distanceMeters': result!.distanceMeters,
                'withinGeofence': result!.withinGeofence,
              }),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('CONTINUE TO CHECK-IN'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
