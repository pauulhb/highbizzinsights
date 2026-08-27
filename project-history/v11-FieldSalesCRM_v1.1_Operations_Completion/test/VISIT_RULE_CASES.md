# Visit Rule Automated Test Cases

Expected:
- 00:00 -> Short
- 14:59 -> Short
- 15:00 -> Qualified
- 15:01 -> Qualified
- Short visit without reason -> Reject
- Short visit with reason -> Save
- Second active visit for same KAM -> Reject
- Retry same idempotency key -> No duplicate
