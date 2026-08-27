# FieldSalesCRM — Mobile App

A field sales CRM for pharma/medical KAMs: customer creation with mandatory
GPS pinning, GPS-verified check-in/check-out visits, a 15-minute qualified
visit rule, geofence-based Location Exceptions, offline-first local storage
with best-effort background sync, commercial actions (samples, feedback,
leads, orders), DWR-style reporting, and a manager hierarchy drill-down.

This is a consolidated rebuild of the `FieldSalesCRM` product line, unifying
everything described across the 17 milestone drops in `../project-history/`
(v0.1 prototype through v1.7.1) into one buildable Flutter app rather than
17 separate partial snapshots.

## Structure

```
lib/
  models/        Customer, Visit, CommercialAction, AppUser, SyncQueueItem
  services/      local SQLite db, GPS capture, visit rules, API client, sync
  repositories/  offline-first read/write operations over the services
  screens/       login, dashboard, customers, visit session, reports, manager
  widgets/       shared UI (stat tiles, location capture card)
```

## Running locally

Requires the Flutter SDK (stable channel) and Android Studio / an Android
SDK + emulator or device.

```
flutter pub get
flutter run
```

Demo accounts (any password) are listed on the login screen, one per role
in the hierarchy (KAM, Area Manager, State Manager, Regional Head,
Management, Admin) so the manager drill-down can be tried without a real
backend.

## Building an APK

```
flutter build apk --release
```

The `.github/workflows/build-apk.yml` workflow at the repo root does this
automatically on every push that touches `mobile/**` and uploads the APK as
a downloadable build artifact.

## Backend

`ApiClient` points at a placeholder `https://api.fieldsalescrm.example.com`.
Every write goes to the local database first and is queued for sync — the
app is fully usable with no backend at all. Point `ApiClient.baseUrl` at a
real deployment (see the `backend/` folders under `../project-history/` for
the intended route shapes: `/auth/login`, `/customers`, `/visits/sync`,
`/commercial/sync`) to enable real sync.

## Known limitations of this build

- Location is shown as raw coordinates, not an embedded map — adding
  `google_maps_flutter` needs a Google Maps API key wired into the Android
  manifest, which is left as a follow-up rather than guessed at here.
- The manager hierarchy tree is a small static demo dataset, not backed by
  a live org-chart endpoint.
