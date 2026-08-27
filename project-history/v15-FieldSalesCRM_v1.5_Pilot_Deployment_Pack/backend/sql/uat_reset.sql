-- UAT-only reset. NEVER run in Production.
-- Keeps employees/territories but clears pilot transaction data.

TRUNCATE TABLE
  attachments,
  follow_ups,
  orders,
  leads,
  samples,
  visits,
  visit_sessions,
  customer_locations,
  customers,
  sync_inbox
RESTART IDENTITY CASCADE;
