import { Router } from 'express';
import { query } from '../db.js';

const router = Router();

function periodStart(period) {
  switch (period) {
    case 'weekly': return `date_trunc('week', NOW())`;
    case 'monthly': return `date_trunc('month', NOW())`;
    case 'quarterly': return `date_trunc('quarter', NOW())`;
    case 'yearly': return `date_trunc('year', NOW())`;
    default: return `date_trunc('day', NOW())`;
  }
}

router.get('/performance', async (req, res, next) => {
  try {
    const period = String(req.query.period || 'daily');
    const start = periodStart(period);
    const employeeId = String(req.query.employee_id || req.user.sub);

    const [visits, samples, leads, orders, followups] = await Promise.all([
      query(
        `SELECT COUNT(*)::int total,
                COUNT(*) FILTER (WHERE qualified)::int qualified,
                COUNT(*) FILTER (WHERE NOT qualified)::int short
         FROM visits
         WHERE employee_id = $1 AND check_in_at >= ${start}`,
        [employeeId]
      ),
      query(
        `SELECT COUNT(*)::int total
         FROM samples
         WHERE employee_id = $1 AND given_on >= (${start})::date`,
        [employeeId]
      ),
      query(
        `SELECT COUNT(*)::int total,
                COALESCE(SUM(expected_value) FILTER (WHERE status='open'),0)::numeric pipeline
         FROM leads
         WHERE employee_id = $1 AND created_at >= ${start}`,
        [employeeId]
      ),
      query(
        `SELECT COUNT(*)::int total,
                COALESCE(SUM(order_value),0)::numeric value
         FROM orders
         WHERE employee_id = $1 AND order_date >= (${start})::date`,
        [employeeId]
      ),
      query(
        `SELECT COUNT(*)::int total
         FROM follow_ups
         WHERE employee_id = $1 AND due_at >= ${start}`,
        [employeeId]
      )
    ]);

    const v = visits.rows[0];
    const rate = v.total === 0 ? 0 : (v.qualified / v.total) * 100;

    res.json({
      period,
      employeeId,
      totalVisits: v.total,
      qualifiedVisits: v.qualified,
      shortVisits: v.short,
      qualifiedVisitRate: Number(rate.toFixed(1)),
      samples: samples.rows[0].total,
      leads: leads.rows[0].total,
      pipelineValue: Number(leads.rows[0].pipeline),
      orders: orders.rows[0].total,
      orderValue: Number(orders.rows[0].value),
      followUps: followups.rows[0].total
    });
  } catch (e) {
    next(e);
  }
});

export default router;
