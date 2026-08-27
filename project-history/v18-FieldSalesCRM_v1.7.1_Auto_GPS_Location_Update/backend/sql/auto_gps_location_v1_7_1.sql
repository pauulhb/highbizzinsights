ALTER TABLE customer_locations
ADD COLUMN IF NOT EXISTS accuracy_meters NUMERIC(10,2);

ALTER TABLE customer_locations
ADD COLUMN IF NOT EXISTS captured_at TIMESTAMPTZ;

ALTER TABLE customer_locations
ADD COLUMN IF NOT EXISTS created_by UUID REFERENCES employees(id);

ALTER TABLE visits
ADD COLUMN IF NOT EXISTS check_in_accuracy_m NUMERIC(10,2);

ALTER TABLE visits
ADD COLUMN IF NOT EXISTS check_out_accuracy_m NUMERIC(10,2);

-- Location history must be retained.
-- Existing customer coordinates are not overwritten during normal repeat visits.

CREATE INDEX IF NOT EXISTS customer_locations_history_idx
ON customer_locations(customer_id,captured_at DESC);
