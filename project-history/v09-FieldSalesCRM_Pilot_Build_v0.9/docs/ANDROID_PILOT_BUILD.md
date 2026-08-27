# Android Pilot Build

Prerequisites:
- Flutter SDK
- Android SDK
- Java/JDK compatible with current Flutter
- UAT API URL
- Android signing key for signed APK/AAB

Suggested commands:

flutter pub get

flutter run --dart-define=API_BASE_URL=https://uat-api.example.com/v1

For a signed release build after signing is configured:

flutter build apk --release --dart-define=API_BASE_URL=https://uat-api.example.com/v1

or

flutter build appbundle --release --dart-define=API_BASE_URL=https://uat-api.example.com/v1

Do not embed production secrets in Dart source.
