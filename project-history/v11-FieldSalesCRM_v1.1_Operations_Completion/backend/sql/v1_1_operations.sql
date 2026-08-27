CREATE TABLE IF NOT EXISTS territories(
 id UUID PRIMARY KEY,
 state VARCHAR(100) NOT NULL,
 hq VARCHAR(100) NOT NULL,
 cities JSONB NOT NULL DEFAULT '[]'::jsonb,
 assigned_employee_id UUID REFERENCES employees(id),
 created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS territory_state_hq_idx ON territories(state,hq);

CREATE TABLE IF NOT EXISTS notification_events(
 id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
 employee_id UUID NOT NULL REFERENCES employees(id),
 event_type VARCHAR(50) NOT NULL,
 title TEXT NOT NULL,
 body TEXT NOT NULL,
 due_at TIMESTAMPTZ NOT NULL,
 delivered_at TIMESTAMPTZ,
 created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS notification_due_idx
ON notification_events(employee_id,delivered_at,due_at);
