# iOS Signing Handoff

Required:
1. macOS + Xcode build host.
2. Apple Developer account.
3. Final bundle identifier.
4. Distribution certificate.
5. Provisioning profile / automatic signing access.
6. App Store Connect access for TestFlight/App Store.

Candidate command:
flutter build ios --release \
  --dart-define=APP_ENV=production \
  --dart-define=API_BASE_URL=https://<production-api>/v1

Archive/distribute through Xcode after successful build.
