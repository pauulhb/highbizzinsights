# FieldNexus Mobile Prototype

Brand-neutral prototype for a field-sales CRM designed for KAMs/Sales teams visiting doctors, hospitals and distributors.

## What is included in v0.1
- KAM / Management role selection
- KAM home dashboard
- Start Day action
- Customer search
- First-time customer creation
- Customer GPS-pin placeholder
- Duplicate-customer check
- Customer detail and visit history
- Visit check-in
- Live visit timer
- 15-minute minimum productive-visit rule
- Mandatory short-visit reason
- Discussion notes and next action
- Sample status / feedback
- Lead creation and pipeline
- Visit reports
- Management KPI screen

## Important business rule implemented
A customer visit is counted as a Qualified/Productive Visit only when the elapsed time from check-in to check-out is at least 15 minutes.

Visits under 15 minutes:
1. are still saved,
2. require a reason,
3. are marked Short Visit,
4. are excluded from the productive-call KPI,
5. remain visible to management for review.

## Current prototype limitations
This is an interactive front-end prototype using in-memory demo data. The following production integrations are intentionally not connected yet:
- real GPS/device location
- secure login / OTP
- cloud database / API
- offline database and sync engine
- push notifications
- camera and document upload
- real maps
- manager hierarchy and territory master
- order workflow
- sample inventory
- report export

## Recommended production stack
- Flutter for Android and iOS
- NestJS / Node.js API
- PostgreSQL database
- Google Maps Platform
- Firebase Cloud Messaging
- AWS / Azure / Google Cloud storage and hosting
- Local SQLite/Drift for offline mobile data

## Run locally
1. Install Flutter SDK.
2. Create a new Flutter project if needed:
   flutter create fieldnexus
3. Replace `pubspec.yaml` and `lib/main.dart` with the files from this prototype.
4. Run:
   flutter pub get
   flutter run

## Next development milestone
Production foundation:
1. authentication and role hierarchy
2. PostgreSQL schema
3. API contracts
4. real GPS and geofencing
5. offline-first storage/sync
6. report engine
7. samples, orders and lead workflow
8. management drill-down
