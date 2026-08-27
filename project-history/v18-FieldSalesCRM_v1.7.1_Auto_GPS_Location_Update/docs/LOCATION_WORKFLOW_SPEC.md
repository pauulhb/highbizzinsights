# Automatic Location Workflow

## First Customer Visit
New Customer
→ Complete Customer Details
→ Tap Capture Current Location
→ Device GPS captures coordinates
→ Google Maps opens/centres on detected position
→ Marker is non-draggable
→ Accuracy and capture time are shown
→ KAM taps Use Current Location
→ Coordinates stored against the customer account

No manual coordinate entry is available.

## Repeat Customer Visit
Search Customer
→ Open Customer
→ Tap Location Status / Check-In
→ Device captures current GPS automatically
→ System calculates distance to registered customer location
→ Google Maps displays registered/current position
→ Within geofence = Location Verified
→ Outside geofence = Location Exception
→ Continue to Check-In
→ Check-Out captures GPS again independently

## Alternate Doctor Location
Do not move the original pin.
Create an additional verified location:
- Primary Hospital
- Secondary Hospital
- Clinic
- Visiting Hospital

Each alternate location must be captured using live device GPS.

## Management
Store:
- GPS coordinates
- GPS accuracy
- capture timestamp
- distance from registered customer location
- geofence exception status
- employee ID

Continuous background tracking is not required.
