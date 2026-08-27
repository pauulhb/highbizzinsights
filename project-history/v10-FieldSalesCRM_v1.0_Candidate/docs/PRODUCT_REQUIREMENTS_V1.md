# Product Requirements v1

## Users
KAM / Sales Executive
Area Manager
State Manager
Regional/South Head
Management
Admin

## Customer types
Doctor
Hospital
Distributor

## First visit
Create customer, capture professional contact details, hospital/account, area/city/state,
potential, GPS pin and first meeting report.

## Repeat visit
Search customer, review history, check in, spend visit time, record discussion, commercial action,
next action and check out.

## Visit rule
15 minutes minimum for Qualified/Productive Visit.
Short visits remain recorded and require a reason.
Server timestamps and database validation are authoritative.

## Commercial CRM
Products
Samples
Feedback
Leads
Pipeline stages
Orders
Follow-ups

## Reporting
Daily / Weekly / Monthly / Quarterly / Yearly
Region -> State -> HQ -> KAM -> Customer -> Visit

## Offline
Cache customer records.
Queue mutations.
Sync using idempotency keys.
Never duplicate orders/visits due to retry.

## Privacy
No continuous background employee tracking required in the core design.
Use visit-linked GPS only.
