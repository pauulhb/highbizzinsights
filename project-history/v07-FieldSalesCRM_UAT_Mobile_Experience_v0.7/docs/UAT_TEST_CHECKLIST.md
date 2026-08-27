# UAT Test Checklist v0.7

## Authentication
- [ ] Login with valid KAM account
- [ ] Invalid password rejected
- [ ] Token persists after app restart
- [ ] Logout clears token

## First customer visit
- [ ] Create Doctor
- [ ] Create Hospital
- [ ] Create Distributor
- [ ] GPS permission prompt appears
- [ ] Current GPS pin captured
- [ ] Duplicate customer warning works
- [ ] Offline creation enters sync queue
- [ ] Sync completes when network returns

## Repeat visit
- [ ] Search by doctor name
- [ ] Search by hospital
- [ ] Search by city
- [ ] Search by area
- [ ] Search by phone
- [ ] Customer opens from cached data when offline

## Visit validation
- [ ] GPS check-in captured
- [ ] Geofence exception displayed outside 200m
- [ ] Timer starts from server check-in time
- [ ] 14:59 requires short-visit reason
- [ ] 15:00 qualifies automatically
- [ ] Discussion required
- [ ] Next action required
- [ ] GPS check-out captured
- [ ] Qualified visit appears in report
- [ ] Short visit appears separately

## Customer timeline
- [ ] Visit visible
- [ ] Sample visible
- [ ] Lead visible
- [ ] Order visible
- [ ] Follow-up visible

## Commercial CRM
- [ ] Record sample
- [ ] Update sample feedback
- [ ] Create lead
- [ ] Change lead stage
- [ ] Mark lead Won / Lost
- [ ] Record order
- [ ] View order in timeline

## Reporting
- [ ] Daily report
- [ ] Weekly report
- [ ] Monthly report
- [ ] Quarterly report
- [ ] Yearly report
- [ ] Qualified visit rate correct
- [ ] Pipeline value correct
- [ ] Order value correct

## Management
- [ ] Manager sees correct role
- [ ] Drill-down permissions verified
- [ ] Short visits visible for review
- [ ] KAM cannot access unauthorized team data

## Offline / Sync
- [ ] App works with network disabled
- [ ] Pending sync count increases
- [ ] Duplicate sync requests do not create duplicate server records
- [ ] Failed sync retries safely
