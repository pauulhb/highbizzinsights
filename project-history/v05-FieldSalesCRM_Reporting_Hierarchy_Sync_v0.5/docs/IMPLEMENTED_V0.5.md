# Implemented in v0.5

## Employee hierarchy
- KAM
- Area Manager
- State Manager
- Regional/South Head
- Management
- recursive team visibility rules
- direct-report lookup

## Territory model
- State
- HQ
- covered cities
- employee assignment

## Customer ownership
- customer assigned to employee
- supports later reassignment
- organisation retains the master record

## Multiple customer locations
Doctors and institutional accounts can hold more than one visit location:
- primary hospital
- secondary hospital
- clinic
- visiting hospital
- distributor branch

## Customer timeline
Combines:
- Visits
- Samples
- Leads
- Orders
- Follow-ups
into one chronological account history.

## Reporting
Filters:
- Daily
- Weekly
- Monthly
- Quarterly
- Yearly
- State
- HQ
- Employee

KPIs:
- Total Visits
- Qualified Visits
- Short Visits
- Qualified Rate
- Unique Customers
- Samples
- Leads
- Pipeline Value
- Orders
- Order Value
- Follow-ups

## Sync
- queue model for offline-created records
- connectivity check
- idempotency-key pattern
- retry attempts
- server sync inbox table

## Export
- CSV report service included
- PDF endpoint reserved in API contract

## Notifications
- due follow-up notification logic
- production push scheduling remains a later integration

## Audit
- server audit log schema
- entity/action/employee/timestamp structure
