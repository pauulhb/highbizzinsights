-- UAT role hierarchy seed template.
-- Replace password hashes before execution.

INSERT INTO employees(
 id,employee_code,full_name,password_hash,role,state,hq,is_active
) VALUES
('10000000-0000-0000-0000-000000000001','KAM001','UAT KAM Bengaluru','<bcrypt>','kam','Karnataka','Bengaluru',TRUE),
('10000000-0000-0000-0000-000000000002','KAM002','UAT KAM Mysuru','<bcrypt>','kam','Karnataka','Mysuru',TRUE),
('20000000-0000-0000-0000-000000000001','AM001','UAT Area Manager','<bcrypt>','area_manager','Karnataka','Bengaluru',TRUE),
('30000000-0000-0000-0000-000000000001','SM001','UAT State Manager','<bcrypt>','state_manager','Karnataka','Bengaluru',TRUE),
('40000000-0000-0000-0000-000000000001','RH001','UAT Regional Head','<bcrypt>','regional_head','South','South HQ',TRUE),
('50000000-0000-0000-0000-000000000001','MGMT001','UAT Management','<bcrypt>','management','All','Corporate',TRUE)
ON CONFLICT(employee_code) DO NOTHING;

UPDATE employees SET manager_id='20000000-0000-0000-0000-000000000001'
WHERE employee_code IN ('KAM001','KAM002');

UPDATE employees SET manager_id='30000000-0000-0000-0000-000000000001'
WHERE employee_code='AM001';

UPDATE employees SET manager_id='40000000-0000-0000-0000-000000000001'
WHERE employee_code='SM001';

UPDATE employees SET manager_id='50000000-0000-0000-0000-000000000001'
WHERE employee_code='RH001';
