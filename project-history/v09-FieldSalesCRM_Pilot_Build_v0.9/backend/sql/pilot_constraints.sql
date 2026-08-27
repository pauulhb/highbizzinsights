-- Prevent more than one active visit per employee.
CREATE UNIQUE INDEX IF NOT EXISTS one_active_visit_per_employee
ON visit_sessions(employee_id)
WHERE completed_at IS NULL;

-- Protect the 15-minute rule at database level.
ALTER TABLE visits
DROP CONSTRAINT IF EXISTS visits_qualified_rule;

ALTER TABLE visits
ADD CONSTRAINT visits_qualified_rule CHECK (
  (qualified = TRUE AND duration_seconds >= 900)
  OR
  (qualified = FALSE AND duration_seconds < 900 AND short_visit_reason IS NOT NULL)
);

-- Useful pilot indexes.
CREATE INDEX IF NOT EXISTS idx_visits_emp_day
ON visits(employee_id, check_in_at);

CREATE INDEX IF NOT EXISTS idx_leads_emp_status
ON leads(employee_id, status);

CREATE INDEX IF NOT EXISTS idx_followups_emp_due
ON follow_ups(employee_id, completed, due_at);
