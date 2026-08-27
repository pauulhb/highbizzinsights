-- Demo password is: demo123
-- bcrypt hash generated for local/UAT demonstration only.
INSERT INTO employees(
  id, employee_code, full_name, password_hash, role, state, hq
) VALUES(
  '11111111-1111-1111-1111-111111111111',
  'KAM001',
  'Demo KAM',
  '$2a$10$QROaVZCuIBo33EGnsYqpje2JmVd9lR6HZjUCF9uZDXsUx2lO5XHYW',
  'kam',
  'Karnataka',
  'Bengaluru'
)
ON CONFLICT (employee_code) DO NOTHING;
