# Rollback Plan

Backend:
- retain previous container/image version
- apply backward-compatible DB migrations where possible
- rollback application first, database only with approved migration plan

Mobile:
- pilot users can reinstall previous UAT build
- production stores may require emergency patch rather than instant rollback

Data:
- never delete visit/customer history during rollback
- preserve sync inbox/idempotency records
- preserve audit logs
