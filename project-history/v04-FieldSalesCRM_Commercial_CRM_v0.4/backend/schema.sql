CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE employees (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  employee_code VARCHAR(50) UNIQUE NOT NULL,
  full_name VARCHAR(150) NOT NULL,
  role VARCHAR(50) NOT NULL,
  manager_id UUID REFERENCES employees(id),
  state VARCHAR(100),
  hq VARCHAR(100),
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE customers (
  id UUID PRIMARY KEY,
  customer_type VARCHAR(30) NOT NULL CHECK (customer_type IN ('doctor','hospital','distributor')),
  name VARCHAR(200) NOT NULL,
  account_name VARCHAR(200) NOT NULL,
  area VARCHAR(150),
  city VARCHAR(150) NOT NULL,
  state VARCHAR(150) NOT NULL,
  phone VARCHAR(30),
  email VARCHAR(150),
  potential VARCHAR(10) CHECK (potential IN ('A+','A','B','C')),
  latitude NUMERIC(10,7) NOT NULL,
  longitude NUMERIC(10,7) NOT NULL,
  created_by UUID REFERENCES employees(id),
  assigned_to UUID REFERENCES employees(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE visits (
  id UUID PRIMARY KEY,
  customer_id UUID NOT NULL REFERENCES customers(id),
  employee_id UUID NOT NULL REFERENCES employees(id),
  check_in_at TIMESTAMPTZ NOT NULL,
  check_out_at TIMESTAMPTZ NOT NULL,
  duration_seconds INTEGER NOT NULL,
  qualified BOOLEAN NOT NULL,
  short_visit_reason VARCHAR(200),
  discussion TEXT NOT NULL,
  outcome VARCHAR(100) NOT NULL,
  next_action TEXT NOT NULL,
  next_action_due_at TIMESTAMPTZ,
  CHECK (
    (qualified = TRUE AND duration_seconds >= 900)
    OR
    (qualified = FALSE AND duration_seconds < 900 AND short_visit_reason IS NOT NULL)
  )
);

CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  product_code VARCHAR(80) UNIQUE NOT NULL,
  product_name VARCHAR(200) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE samples (
  id UUID PRIMARY KEY,
  customer_id UUID NOT NULL REFERENCES customers(id),
  product_id UUID NOT NULL REFERENCES products(id),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  given_on DATE NOT NULL,
  expected_feedback_on DATE,
  feedback_status VARCHAR(50) NOT NULL DEFAULT 'Awaiting Feedback',
  feedback_notes TEXT
);

CREATE TABLE leads (
  id UUID PRIMARY KEY,
  customer_id UUID NOT NULL REFERENCES customers(id),
  owner_id UUID NOT NULL REFERENCES employees(id),
  product_id UUID NOT NULL REFERENCES products(id),
  expected_value NUMERIC(14,2) NOT NULL DEFAULT 0,
  probability INTEGER NOT NULL CHECK (probability BETWEEN 0 AND 100),
  stage VARCHAR(50) NOT NULL,
  expected_closure DATE,
  next_action TEXT NOT NULL,
  next_action_due_at TIMESTAMPTZ,
  status VARCHAR(30) NOT NULL DEFAULT 'open',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE orders (
  id UUID PRIMARY KEY,
  customer_id UUID NOT NULL REFERENCES customers(id),
  owner_id UUID NOT NULL REFERENCES employees(id),
  product_id UUID NOT NULL REFERENCES products(id),
  quantity INTEGER NOT NULL DEFAULT 0,
  order_value NUMERIC(14,2) NOT NULL DEFAULT 0,
  po_number VARCHAR(100),
  order_date DATE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE follow_ups (
  id UUID PRIMARY KEY,
  customer_id UUID NOT NULL REFERENCES customers(id),
  employee_id UUID NOT NULL REFERENCES employees(id),
  title TEXT NOT NULL,
  due_at TIMESTAMPTZ NOT NULL,
  source_type VARCHAR(30) NOT NULL,
  source_id UUID NOT NULL,
  completed BOOLEAN NOT NULL DEFAULT FALSE,
  completed_at TIMESTAMPTZ
);

CREATE INDEX idx_leads_owner_status ON leads(owner_id, status);
CREATE INDEX idx_followups_due ON follow_ups(employee_id, completed, due_at);
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);
