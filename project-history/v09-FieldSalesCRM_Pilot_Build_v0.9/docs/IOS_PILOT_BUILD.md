# iOS Pilot Build

Prerequisites:
- macOS
- Xcode
- Flutter SDK
- Apple Developer account
- Signing certificate / provisioning profile
- UAT API URL

Suggested command:

flutter build ios --release --dart-define=API_BASE_URL=https://uat-api.example.com/v1

Then archive/sign in Xcode and distribute through TestFlight for pilot users.
