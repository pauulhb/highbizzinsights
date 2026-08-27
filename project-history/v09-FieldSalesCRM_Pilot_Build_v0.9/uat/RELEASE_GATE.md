# Release Gate

Do NOT progress from pilot to v1.0 if any of these remain:
- Critical login/security defect
- Qualified visit rule can be bypassed
- Visit timestamps can be altered by client
- Data loss during offline sync
- KAM can see unauthorized customers/team
- Manager reports materially disagree with source records
- Duplicate orders created by retry/sync
- Customer reassignment corrupts history

High-severity defects should be closed or formally accepted by management before release.
