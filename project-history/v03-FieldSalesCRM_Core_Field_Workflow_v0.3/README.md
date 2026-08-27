# Field Sales CRM — Core Field Workflow v0.3

This version moves beyond the earlier architecture package and implements the core operational mobile flow for iOS and Android:

First Visit:
New Customer → Device GPS Pin → Duplicate Check → Save Offline

Repeat Visit:
Search Existing Customer → Select → GPS Check-In → Live Timer → Meeting Notes → Next Action → GPS Check-Out → Save Offline

The 15-minute qualified-visit rule is enforced in mobile logic and repeated in the production PostgreSQL schema.

## Important
This is still source code, not a deployed App Store / Play Store application. Real production use requires API deployment, authentication, environment configuration, platform permission files, security review, sync completion, testing and signing.

## Recommended next build
Commercial CRM v0.4:
Samples + feedback, leads, orders, follow-ups, customer timeline, DWR and management dashboard.
