# Field Sales CRM v1.7.1 — Automatic GPS Location Update

This update changes the customer location workflow so location cannot be manually moved or edited.

Core rule:
- No draggable pin.
- No manual latitude/longitude entry.
- KAM taps "Capture Current Location".
- Device GPS automatically captures the current position.
- Google Maps displays the captured position for confirmation.
- Stored customer coordinates become the verified account location.
- Repeat visits automatically compare live GPS with the saved customer location.
- Check-In and Check-Out both capture location independently.
- Visits outside the allowed geofence are retained as Location Exceptions.
- Alternate practice locations must be added as separate verified locations.
- Qualified Visit still requires at least 15 minutes / 900 seconds.
