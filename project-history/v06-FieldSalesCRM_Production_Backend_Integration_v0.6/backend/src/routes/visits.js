import { Router } from 'express';
import { z } from 'zod';
import { query } from '../db.js';
import { qualifyVisit, haversineMeters } from '../services/visitRules.js';

const router = Router();

const checkInSchema = z.object({
  id: z.string().uuid(),
  customerId: z.string().uuid(),
  latitude: z.number(),
  longitude: z.number()
});

const checkOutSchema = z.object({
  latitude: z.number(),
  longitude: z.number(),
  discussion: z.string().min(2),
  outcome: z.string().min(2),
  nextAction: z.string().min(1),
  shortVisitReason: z.string().optional().nullable()
});

router.post('/check-in', async (req, res, next) => {
  try {
    const body = checkInSchema.parse(req.body);

    const customerResult = await query(
      `SELECT id, latitude, longitude
       FROM customers
       WHERE id = $1 AND assigned_employee_id = $2`,
      [body.customerId, req.user.sub]
    );

    if (!customerResult.rowCount) {
      return res.status(404).json({ error: 'Customer not found or not assigned' });
    }

    const customer = customerResult.rows[0];
    const distance = haversineMeters(
      body.latitude, body.longitude,
      Number(customer.latitude), Number(customer.longitude)
    );

    const result = await query(
      `INSERT INTO visit_sessions(
         id, customer_id, employee_id, check_in_at,
         check_in_lat, check_in_lng, check_in_distance_m
       ) VALUES($1,$2,$3,NOW(),$4,$5,$6)
       RETURNING *`,
      [
        body.id, body.customerId, req.user.sub,
        body.latitude, body.longitude, distance
      ]
    );

    res.status(201).json({
      ...result.rows[0],
      geofenceException: distance > Number(process.env.DEFAULT_GEOFENCE_METERS || 200)
    });
  } catch (e) {
    next(e);
  }
});

router.post('/:id/check-out', async (req, res, next) => {
  try {
    const body = checkOutSchema.parse(req.body);

    const sessionResult = await query(
      `SELECT vs.*, c.latitude AS customer_lat, c.longitude AS customer_lng
       FROM visit_sessions vs
       JOIN customers c ON c.id = vs.customer_id
       WHERE vs.id = $1 AND vs.employee_id = $2 AND vs.completed_at IS NULL`,
      [req.params.id, req.user.sub]
    );

    if (!sessionResult.rowCount) {
      return res.status(404).json({ error: 'Active visit session not found' });
    }

    const s = sessionResult.rows[0];
    const now = new Date();
    const durationSeconds = Math.floor(
      (now.getTime() - new Date(s.check_in_at).getTime()) / 1000
    );

    const qualified = qualifyVisit(
      durationSeconds,
      body.shortVisitReason || null
    );

    const outDistance = haversineMeters(
      body.latitude, body.longitude,
      Number(s.customer_lat), Number(s.customer_lng)
    );

    await query('BEGIN');
    try {
      const visitResult = await query(
        `INSERT INTO visits(
           id, customer_id, employee_id, check_in_at, check_out_at,
           check_in_lat, check_in_lng, check_out_lat, check_out_lng,
           check_in_distance_m, check_out_distance_m,
           duration_seconds, qualified, short_visit_reason,
           outcome, discussion, next_action
         ) VALUES(
           $1,$2,$3,$4,NOW(),$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16
         )
         RETURNING *`,
        [
          s.id, s.customer_id, s.employee_id, s.check_in_at,
          s.check_in_lat, s.check_in_lng,
          body.latitude, body.longitude,
          s.check_in_distance_m, outDistance,
          durationSeconds, qualified,
          qualified ? null : body.shortVisitReason,
          body.outcome, body.discussion, body.nextAction
        ]
      );

      await query(
        `UPDATE visit_sessions
         SET completed_at = NOW()
         WHERE id = $1`,
        [s.id]
      );

      await query('COMMIT');
      res.json(visitResult.rows[0]);
    } catch (e) {
      await query('ROLLBACK');
      throw e;
    }
  } catch (e) {
    next(e);
  }
});

export default router;
