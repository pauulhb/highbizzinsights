# Production Business Rules

## Customer creation
The KAM creates the Doctor, Hospital or Distributor during the first physical visit. GPS pinning is mandatory. The customer becomes an organisational master record and can be reassigned later.

## Repeat visit
The KAM searches the existing customer by name, account, city, area or phone and records the new interaction against the same master.

## Visit qualification
Minimum qualified visit duration: **15 minutes / 900 seconds**.

- Duration >= 15:00: Qualified/Productive Visit.
- Duration < 15:00: Short Visit.
- Short Visit requires a reason.
- Short Visit stays in DWR and audit history.
- Short Visit is excluded from Productive Visit KPI.
- Management can review exceptions.

## GPS rule
Check-in and check-out both capture device GPS. A configurable geofence (default 200m) compares the live position with the registered customer location. Alternate doctor practice locations are supported.

## DWR
The DWR is generated automatically from system activity and includes field start/end, total visits, qualified visits, short visits, qualified rate, customer mix, new customers, samples, leads, pipeline, orders and follow-ups.

## Report periods
Daily, Weekly, Monthly, Quarterly and Yearly.

## Hierarchy
KAM/Sales Executive → Area/State Manager → Regional/South Head → Management.

## Drill-down
Region → State → HQ → KAM → Customer → Visit.
