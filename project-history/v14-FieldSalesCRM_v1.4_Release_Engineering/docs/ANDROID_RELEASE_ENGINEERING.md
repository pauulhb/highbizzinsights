# Android Release Engineering

Before producing signed pilot/release builds:
- install Flutter/Android SDK/JDK
- configure package name
- configure app display name
- configure final app icon
- add location permissions
- configure UAT/Production API URLs
- create organization-controlled keystore
- store signing secrets outside source control
- enable code shrinking only after testing

Pilot:
flutter build apk --release --dart-define=APP_ENV=uat --dart-define=API_BASE_URL=https://<uat-api>/v1

Play Store:
flutter build appbundle --release --dart-define=APP_ENV=production --dart-define=API_BASE_URL=https://<prod-api>/v1
