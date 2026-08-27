# Field Sales CRM — Production Backend & Mobile Integration v0.6

This milestone moves the project from architecture-only code into a runnable backend integration foundation.

Included:
- Docker Compose
- PostgreSQL
- Node.js/Express REST API
- JWT authentication
- Customer search/create/duplicate detection
- Customer timeline API
- GPS visit check-in/check-out
- Server-side geofence-distance calculation
- Server-side 15-minute visit qualification
- Samples, Leads and Orders APIs
- Performance reporting API
- Offline batch sync/idempotency endpoint
- Flutter API client/repositories

Important:
This is suitable as a development/UAT foundation. It is not yet production hardened or store-ready.

Next milestone: v0.7 will connect the full Flutter UI to these APIs, complete offline persistence/sync, add role-aware manager views, notifications and UAT test flows.
