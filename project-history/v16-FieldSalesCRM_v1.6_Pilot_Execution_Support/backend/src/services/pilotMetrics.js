import {query} from '../db.js';

export async function pilotDailyMetrics(date = new Date()) {
  const r = await query(
    `SELECT
       COUNT(DISTINCT v.employee_id)::int active_kams,
       COUNT(v.id)::int total_visits,
       COUNT(v.id) FILTER(WHERE v.qualified)::int qualified_visits,
       COUNT(v.id) FILTER(WHERE NOT v.qualified)::int short_visits,
       COUNT(DISTINCT v.customer_id)::int unique_customers
     FROM visits v
     WHERE v.check_in_at::date = $1::date`,
    [date.toISOString().slice(0,10)]
  );

  const c = await query(
    `SELECT
       COUNT(*)::int samples,
       (SELECT COUNT(*) FROM leads WHERE created_at::date=$1::date)::int leads,
       (SELECT COALESCE(SUM(expected_value),0) FROM leads
          WHERE created_at::date=$1::date AND status='open')::numeric pipeline,
       (SELECT COUNT(*) FROM orders WHERE order_date=$1::date)::int orders,
       (SELECT COALESCE(SUM(order_value),0) FROM orders WHERE order_date=$1::date)::numeric order_value
     FROM samples WHERE given_on=$1::date`,
    [date.toISOString().slice(0,10)]
  );

  return {...r.rows[0], ...c.rows[0]};
}
