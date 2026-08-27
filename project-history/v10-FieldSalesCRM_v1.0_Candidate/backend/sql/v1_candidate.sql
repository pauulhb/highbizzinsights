CREATE TABLE IF NOT EXISTS refresh_tokens(
  id BIGSERIAL PRIMARY KEY,
  employee_id UUID NOT NULL REFERENCES employees(id),
  token_hash TEXT UNIQUE NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  revoked_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS refresh_tokens_employee_idx
ON refresh_tokens(employee_id,revoked_at,expires_at);

CREATE UNIQUE INDEX IF NOT EXISTS one_active_visit_per_employee
ON visit_sessions(employee_id) WHERE completed_at IS NULL;

ALTER TABLE visits
DROP CONSTRAINT IF EXISTS visits_qualified_rule;

ALTER TABLE visits
ADD CONSTRAINT visits_qualified_rule CHECK (
 (qualified=TRUE AND duration_seconds>=900)
 OR
 (qualified=FALSE AND duration_seconds<900 AND short_visit_reason IS NOT NULL)
);
