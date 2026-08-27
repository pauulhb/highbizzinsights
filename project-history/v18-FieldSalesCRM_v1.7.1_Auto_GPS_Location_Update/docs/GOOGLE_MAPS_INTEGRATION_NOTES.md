# Google Maps Integration Notes

Production mobile build should use the official Google Maps SDK for Android/iOS.

Important implementation rules:
- map camera may be moved/zoomed for viewing
- location marker itself must NOT be draggable
- stored coordinates come only from device GPS capture
- do not infer new stored coordinates from the map camera centre
- user may recapture current GPS if accuracy is poor
- API keys must be restricted to the application's Android/iOS package identifiers
- API keys must not be committed to public source control
