# iOS Release Engineering

Required:
- macOS/Xcode
- Apple Developer account
- bundle identifier
- signing certificate
- provisioning profile
- location permission text
- UAT/Production API URLs

Pilot/TestFlight:
flutter build ios --release --dart-define=APP_ENV=uat --dart-define=API_BASE_URL=https://<uat-api>/v1

Archive in Xcode and distribute through TestFlight.
