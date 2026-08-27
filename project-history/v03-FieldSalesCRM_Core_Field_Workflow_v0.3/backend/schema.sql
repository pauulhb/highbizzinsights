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
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_customers_name_city ON customers (LOWER(name), LOWER(city));
CREATE INDEX idx_customers_phone ON customers (phone);

CREATE TABLE visits (
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
  discussion TEXT NOT NULL,
  outcome VARCHAR(100) NOT NULL,
  next_action TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK (
    (qualified = TRUE AND duration_seconds >= 900)
    OR
    (qualified = FALSE AND duration_seconds < 900 AND short_visit_reason IS NOT NULL)
  )
);

CREATE INDEX idx_visits_employee_date ON visits (employee_id, check_in_at);
CREATE INDEX idx_visits_customer_date ON visits (customer_id, check_in_at);
