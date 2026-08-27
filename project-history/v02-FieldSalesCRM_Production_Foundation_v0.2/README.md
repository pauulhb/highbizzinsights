# Field Sales CRM — Production Foundation v0.2

This advances the earlier prototype into a production-oriented, brand-neutral mobile foundation for iOS and Android.

## Included
- Flutter starter architecture
- customer, visit, lead, sample and order domain models
- GPS service using geolocator
- offline SQLite foundation
- sync service scaffold
- PostgreSQL server schema
- OpenAPI endpoint contract
- business rules and roadmap
- 15-minute qualified-visit rule built into the database design

## Important
This is source architecture, not a deployed commercial app. A live app still requires backend implementation, cloud deployment, authentication, production maps/GPS configuration, offline sync completion, QA/security testing, and App Store/Play Store release signing.

## Next coding milestone
Build authenticated customer CRUD + duplicate detection + real GPS visit session + offline save/sync. After that, add samples, leads, orders, follow-ups and reporting.
