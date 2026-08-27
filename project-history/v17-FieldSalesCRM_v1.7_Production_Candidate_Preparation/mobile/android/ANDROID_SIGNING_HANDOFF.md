# Android Signing Handoff

Required from organization:
1. Final package identifier.
2. Organization-controlled signing keystore.
3. Keystore alias.
4. Secure password delivery mechanism.
5. Play Console account if store distribution is planned.

Never place signing passwords in the repository.

Candidate command:
flutter build appbundle --release \
  --dart-define=APP_ENV=production \
  --dart-define=API_BASE_URL=https://<production-api>/v1
