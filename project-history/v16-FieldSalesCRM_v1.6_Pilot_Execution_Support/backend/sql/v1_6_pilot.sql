CREATE TABLE IF NOT EXISTS pilot_events(
  id BIGSERIAL PRIMARY KEY,
  employee_id UUID REFERENCES employees(id),
  event_type VARCHAR(80) NOT NULL,
  entity_type VARCHAR(50),
  entity_id UUID,
  meta JSONB NOT NULL DEFAULT '{}'::jsonb,
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS pilot_events_emp_time
ON pilot_events(employee_id,occurred_at DESC);

CREATE INDEX IF NOT EXISTS pilot_events_type_time
ON pilot_events(event_type,occurred_at DESC);
