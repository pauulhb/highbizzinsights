import 'package:flutter/material.dart';
import '../services/automatic_location_service.dart';
import '../widgets/location_status_card.dart';

class CaptureCustomerLocationScreen extends StatefulWidget {
  final String customerName;

  const CaptureCustomerLocationScreen({
    super.key,
    required this.customerName,
  });

  @override
  State<CaptureCustomerLocationScreen> createState() =>
      _CaptureCustomerLocationScreenState();
}

class _CaptureCustomerLocationScreenState
    extends State<CaptureCustomerLocationScreen> {
  CapturedLocation? captured;
  bool busy = false;

  Future<void> capture() async {
    try {
      setState(() => busy = true);
      final result = await AutomaticLocationService().captureCurrentLocation();
      setState(() => captured = result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void confirm() {
    if (captured == null) return;

    Navigator.pop(context, {
      'latitude': captured!.latitude,
      'longitude': captured!.longitude,
      'accuracyMeters': captured!.accuracyMeters,
      'capturedAt': captured!.capturedAt.toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Status')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.customerName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.lock_location_outlined),
              title: Text('Automatic GPS Capture'),
              subtitle: Text(
                'Location is detected automatically from the device. '
                'The map pin cannot be dragged and coordinates cannot be entered manually.',
              ),
            ),
          ),
          const SizedBox(height: 12),
          LocationStatusCard(
            location: captured,
            verified: captured != null,
          ),
          const SizedBox(height: 12),

          // Production integration point:
          // render Google Maps here centered on captured.latitude/captured.longitude.
          // Marker must be non-draggable.
          Container(
            height: 220,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              captured == null
                  ? 'Google Maps preview appears after GPS capture'
                  : 'Google Maps preview\nMarker locked at detected GPS position',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: busy ? null : capture,
            icon: const Icon(Icons.my_location),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('CAPTURE CURRENT LOCATION'),
            ),
          ),
          if (captured != null) ...[
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: confirm,
              icon: const Icon(Icons.check_circle_outline),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('USE CURRENT LOCATION'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
