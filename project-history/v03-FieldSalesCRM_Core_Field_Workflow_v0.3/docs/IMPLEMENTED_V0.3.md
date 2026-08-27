# Implemented in v0.3

## Core first-visit customer flow
- Doctor / Hospital / Distributor customer type
- customer master creation
- GPS pin captured from device
- duplicate warning using name + city and phone
- local SQLite persistence

## Repeat-visit flow
- search by customer name
- account/hospital
- city
- area
- phone
- select customer and start visit

## GPS visit workflow
- GPS check-in
- distance from customer pin
- configurable 200m geofence rule
- location-exception warning
- live visit timer
- mandatory meeting notes
- mandatory next action
- GPS check-out
- distance from customer pin at checkout

## 15-minute rule
- >= 900 seconds = Qualified / Productive Visit
- < 900 seconds = Short Visit
- Short Visit requires reason
- Short Visit remains recorded but is excluded from productive-call KPI
- PostgreSQL schema repeats the same rule with a CHECK constraint

## Offline-first foundation
- customers and visits saved to SQLite
- sync_status field retained for future server upload
