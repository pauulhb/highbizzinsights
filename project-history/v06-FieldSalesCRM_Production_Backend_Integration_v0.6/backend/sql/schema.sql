CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS employees (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  employee_code VARCHAR(50) UNIQUE NOT NULL,
  full_name VARCHAR(150) NOT NULL,
  password_hash TEXT NOT NULL,
  role VARCHAR(50) NOT NULL,
  manager_id UUID REFERENCES employees(id),
  state VARCHAR(100) NOT NULL,
  hq VARCHAR(100) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS customers (
  id UUID PRIMARY KEY,
  customer_type VARCHAR(30) NOT NULL CHECK (customer_type IN ('doctor','hospital','distributor')),
  name VARCHAR(200) NOT NULL,
  account_name VARCHAR(200) NOT NULL,
  area VARCHAR(150),
  city VARCHAR(150) NOT NULL,
  state VARCHAR(150) NOT NULL,
  potential VARCHAR(10) NOT NULL CHECK (potential IN ('A+','A','B','C')),
  phone VARCHAR(30),
  email VARCHAR(150),
  latitude NUMERIC(10,7) NOT NULL,
  longitude NUMERIC(10,7) NOT NULL,
  assigned_employee_id UUID NOT NULL REFERENCES employees(id),
  created_by UUID NOT NULL REFERENCES employees(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS visit_sessions (
  id UUID PRIMARY KEY,
  customer_id UUID NOT NULL REFERENCES customers(id),
  employee_id UUID NOT NULL REFERENCES employees(id),
  check_in_at TIMESTAMPTZ NOT NULL,
  check_in_lat NUMERIC(10,7) NOT NULL,
  check_in_lng NUMERIC(10,7) NOT NULL,
  check_in_distance_m NUMERIC(10,2) NOT NULL,
  completed_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS visits (
  id UUID PRIMARY KEY,
  customer_id UUID NOT NULL REFERENCES customers(id),
  employee_id UUID NOT NULL REFERENCES employees(id),
  check_in_at TIMESTAMPTZ NOT NULL,
  check_out_at TIMESTAMPTZ NOT NULL,
  check_in_lat NUMERIC(10,7) NOT NULL,
  check_in_lng NUMERIC(10,7) NOT NULL,
  check_out_lat NUMERIC(10,7) NOT NULL,
  check_out_lng NUMERIC(10,7) NOT NULL,
  check_in_distance_m NUMERIC(10,2) NOT NULL,
  check_out_distance_m NUMERIC(10,2) NOT NULL,
  duration_seconds INTEGER NOT NULL,
  qualified BOOLEAN NOT NULL,
  short_visit_reason VARCHAR(200),
  outcome VARCHAR(100) NOT NULL,
  discussion TEXT NOT NULL,
  next_action TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK (
    (qualified = TRUE AND duration_seconds >= 900)
    OR
    (qualified = FALSE AND duration_seconds < 900 AND short_visit_reason IS NOT NULL)
  )
);

CREATE TABLE IF NOT EXISTS samples (
  id UUID PRIMARY KEY,
  customer_id UUID NOT NULL REFERENCES customers(id),
  employee_id UUID NOT NULL REFERENCES employees(id),
  product_name VARCHAR(200) NOT NULL,
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  given_on DATE NOT NULL,
  feedback_status VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS leads (
  id UUID PRIMARY KEY,
  customer_id UUID NOT NULL REFERENCES customers(id),
  employee_id UUID NOT NULL REFERENCES employees(id),
  product_name VARCHAR(200) NOT NULL,
  expected_value NUMERIC(14,2) NOT NULL DEFAULT 0,
  probability INTEGER NOT NULL CHECK (probability BETWEEN 0 AND 100),
  stage VARCHAR(50) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'open',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS orders (
  id UUID PRIMARY KEY,
  customer_id UUID NOT NULL REFERENCES customers(id),
  employee_id UUID NOT NULL REFERENCES employees(id),
  product_name VARCHAR(200) NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 0,
  order_value NUMERIC(14,2) NOT NULL DEFAULT 0,
  order_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS follow_ups (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id UUID NOT NULL REFERENCES customers(id),
  employee_id UUID NOT NULL REFERENCES employees(id),
  title TEXT NOT NULL,
  due_at TIMESTAMPTZ NOT NULL,
  completed BOOLEAN NOT NULL DEFAULT FALSE,
  completed_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS sync_inbox (
  idempotency_key UUID PRIMARY KEY,
  employee_id UUID NOT NULL REFERENCES employees(id),
  entity_type VARCHAR(50) NOT NULL,
  entity_id UUID NOT NULL,
  action VARCHAR(50) NOT NULL,
  received_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_customer_assigned ON customers(assigned_employee_id);
CREATE INDEX IF NOT EXISTS idx_visit_emp_date ON visits(employee_id, check_in_at);
CREATE INDEX IF NOT EXISTS idx_lead_emp_status ON leads(employee_id, status);
CREATE INDEX IF NOT EXISTS idx_order_emp_date ON orders(employee_id, order_date);
