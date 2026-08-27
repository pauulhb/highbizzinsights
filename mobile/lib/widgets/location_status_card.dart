import 'package:flutter/material.dart';

/// Shared "Capture Current Location" control. Per the v1.7.1 rule there is
/// no draggable pin and no manual latitude/longitude entry anywhere in the
/// app — this is the only way a coordinate ever gets set.
class LocationStatusCard extends StatelessWidget {
  const LocationStatusCard({
    super.key,
    required this.lat,
    required this.lng,
    required this.isCapturing,
    required this.onCapture,
    this.title = 'Location',
  });

  final double? lat;
  final double? lng;
  final bool isCapturing;
  final VoidCallback onCapture;
  final String title;

  @override
  Widget build(BuildContext context) {
    final captured = lat != null && lng != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              captured ? Icons.check_circle : Icons.location_off,
              color: captured ? Colors.green : Colors.grey,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    captured
                        ? '${lat!.toStringAsFixed(6)}, ${lng!.toStringAsFixed(6)}'
                        : 'Not captured yet',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: isCapturing ? null : onCapture,
              icon: isCapturing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
              label: Text(captured ? 'Recapture' : 'Capture Current Location'),
            ),
          ],
        ),
      ),
    );
  }
}
