-- UAT seed template.
-- Replace <bcrypt-hash> values with real UAT-only hashes before execution.

INSERT INTO employees(
  id,employee_code,full_name,password_hash,role,manager_id,state,hq,is_active
) VALUES
('11000000-0000-0000-0000-000000000001','KAM001','Pilot KAM Bengaluru','<bcrypt-hash>','kam',
 '21000000-0000-0000-0000-000000000001','Karnataka','Bengaluru',TRUE),
('11000000-0000-0000-0000-000000000002','KAM002','Pilot KAM Mysuru','<bcrypt-hash>','kam',
 '21000000-0000-0000-0000-000000000001','Karnataka','Mysuru',TRUE),
('21000000-0000-0000-0000-000000000001','AM001','Pilot Area Manager','<bcrypt-hash>','area_manager',
 '31000000-0000-0000-0000-000000000001','Karnataka','Bengaluru',TRUE),
('31000000-0000-0000-0000-000000000001','SM001','Pilot State Manager','<bcrypt-hash>','state_manager',
 '41000000-0000-0000-0000-000000000001','Karnataka','Bengaluru',TRUE),
('41000000-0000-0000-0000-000000000001','RH001','Pilot Regional Head','<bcrypt-hash>','regional_head',
 '51000000-0000-0000-0000-000000000001','South','South HQ',TRUE),
('51000000-0000-0000-0000-000000000001','MGMT001','Pilot Management','<bcrypt-hash>','management',
 NULL,'All','Corporate',TRUE)
ON CONFLICT(employee_code) DO NOTHING;

INSERT INTO territories(id,state,hq,cities,assigned_employee_id) VALUES
('61000000-0000-0000-0000-000000000001','Karnataka','Bengaluru','["Bengaluru","Tumakuru","Kolar"]',
 '11000000-0000-0000-0000-000000000001'),
('61000000-0000-0000-0000-000000000002','Karnataka','Mysuru','["Mysuru","Mandya","Hassan"]',
 '11000000-0000-0000-0000-000000000002')
ON CONFLICT(id) DO NOTHING;
