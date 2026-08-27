CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE employees (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  employee_code VARCHAR(50) UNIQUE NOT NULL,
  full_name VARCHAR(150) NOT NULL,
  mobile VARCHAR(30),
  email VARCHAR(150),
  role VARCHAR(50) NOT NULL,
  manager_id UUID REFERENCES employees(id),
  state VARCHAR(100),
  hq VARCHAR(100),
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE customers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_type VARCHAR(30) NOT NULL CHECK (customer_type IN ('doctor','hospital','distributor')),
  name VARCHAR(200) NOT NULL,
  account_name VARCHAR(200) NOT NULL,
  area VARCHAR(150) NOT NULL,
  city VARCHAR(150) NOT NULL,
  state VARCHAR(150) NOT NULL,
  phone VARCHAR(30),
  email VARCHAR(150),
  potential VARCHAR(10) CHECK (potential IN ('A+','A','B','C')),
  latitude NUMERIC(10,7) NOT NULL,
  longitude NUMERIC(10,7) NOT NULL,
  created_by UUID REFERENCES employees(id),
  assigned_to UUID REFERENCES employees(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE customer_locations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  label VARCHAR(100) NOT NULL,
  latitude NUMERIC(10,7) NOT NULL,
  longitude NUMERIC(10,7) NOT NULL,
  is_primary BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE visits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id UUID NOT NULL REFERENCES customers(id),
  employee_id UUID NOT NULL REFERENCES employees(id),
  customer_location_id UUID REFERENCES customer_locations(id),
  check_in_at TIMESTAMPTZ NOT NULL,
  check_out_at TIMESTAMPTZ NOT NULL,
  check_in_lat NUMERIC(10,7) NOT NULL,
  check_in_lng NUMERIC(10,7) NOT NULL,
  check_out_lat NUMERIC(10,7) NOT NULL,
  check_out_lng NUMERIC(10,7) NOT NULL,
  check_in_distance_m NUMERIC(10,2),
  check_out_distance_m NUMERIC(10,2),
  duration_seconds INTEGER NOT NULL,
  qualified BOOLEAN NOT NULL,
  short_visit_reason VARCHAR(200),
  discussion TEXT NOT NULL,
  outcome VARCHAR(100) NOT NULL,
  next_action TEXT NOT NULL,
  next_action_due_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK (
    (qualified = TRUE AND duration_seconds >= 900)
    OR
    (qualified = FALSE AND duration_seconds < 900 AND short_visit_reason IS NOT NULL)
  )
);

CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  product_code VARCHAR(80) UNIQUE,
  product_name VARCHAR(200) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE samples (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id UUID NOT NULL REFERENCES customers(id),
  visit_id UUID REFERENCES visits(id),
  product_id UUID REFERENCES products(id),
  sku VARCHAR(100),
  batch_no VARCHAR(100),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  given_on DATE NOT NULL,
  expected_feedback_on DATE,
  feedback_status VARCHAR(50) NOT NULL DEFAULT 'Awaiting Feedback',
  feedback_notes TEXT,
  created_by UUID REFERENCES employees(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE leads (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id UUID NOT NULL REFERENCES customers(id),
  owner_id UUID NOT NULL REFERENCES employees(id),
  product_id UUID REFERENCES products(id),
  expected_value NUMERIC(14,2) NOT NULL DEFAULT 0,
  probability INTEGER NOT NULL CHECK (probability BETWEEN 0 AND 100),
  stage VARCHAR(50) NOT NULL,
  expected_closure DATE,
  next_action TEXT,
  next_action_due_at TIMESTAMPTZ,
  status VARCHAR(30) NOT NULL DEFAULT 'open',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id UUID NOT NULL REFERENCES customers(id),
  owner_id UUID NOT NULL REFERENCES employees(id),
  visit_id UUID REFERENCES visits(id),
  po_number VARCHAR(100),
  order_value NUMERIC(14,2) NOT NULL,
  order_date DATE NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'received'
);

CREATE TABLE audit_log (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  employee_id UUID REFERENCES employees(id),
  entity_type VARCHAR(50) NOT NULL,
  entity_id UUID NOT NULL,
  action VARCHAR(50) NOT NULL,
  old_values JSONB,
  new_values JSONB,
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_visits_employee_date ON visits (employee_id, check_in_at);
CREATE INDEX idx_visits_customer_date ON visits (customer_id, check_in_at);
CREATE INDEX idx_customers_assigned ON customers (assigned_to);
