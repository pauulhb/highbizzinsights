-- Read-only production-candidate checks.

SELECT 'qualified_rule_check' AS check_name,
       COUNT(*) AS invalid_rows
FROM visits
WHERE (qualified=TRUE AND duration_seconds<900)
   OR (qualified=FALSE AND duration_seconds>=900);

SELECT 'parallel_active_visit_check' AS check_name,
       employee_id,COUNT(*) AS active_count
FROM visit_sessions
WHERE completed_at IS NULL
GROUP BY employee_id
HAVING COUNT(*)>1;

SELECT 'employee_hierarchy_check' AS check_name,
       COUNT(*) AS active_users_without_manager
FROM employees
WHERE is_active=TRUE
  AND role NOT IN ('management','admin')
  AND manager_id IS NULL;
