CREATE UNIQUE INDEX IF NOT EXISTS one_active_visit_per_employee
ON visit_sessions(employee_id) WHERE completed_at IS NULL;

CREATE TABLE IF NOT EXISTS customer_reassignments(
 id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
 customer_id UUID NOT NULL REFERENCES customers(id),
 from_employee_id UUID NOT NULL REFERENCES employees(id),
 to_employee_id UUID NOT NULL REFERENCES employees(id),
 requested_by UUID NOT NULL REFERENCES employees(id),
 reason TEXT NOT NULL,status VARCHAR(20) NOT NULL DEFAULT 'pending',
 approved_by UUID REFERENCES employees(id),approved_at TIMESTAMPTZ,
 created_at TIMESTAMPTZ NOT NULL DEFAULT NOW());

CREATE TABLE IF NOT EXISTS attachments(
 id UUID PRIMARY KEY,customer_id UUID NOT NULL REFERENCES customers(id),
 visit_id UUID REFERENCES visits(id),employee_id UUID NOT NULL REFERENCES employees(id),
 category VARCHAR(40) NOT NULL,file_name TEXT NOT NULL,mime_type VARCHAR(100) NOT NULL,
 storage_key TEXT NOT NULL,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW());

CREATE TABLE IF NOT EXISTS audit_log(
 id BIGSERIAL PRIMARY KEY,actor_id UUID REFERENCES employees(id),action VARCHAR(100) NOT NULL,
 entity_type VARCHAR(60) NOT NULL,entity_id UUID,before_json JSONB,after_json JSONB,
 meta_json JSONB NOT NULL DEFAULT '{}'::jsonb,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW());
