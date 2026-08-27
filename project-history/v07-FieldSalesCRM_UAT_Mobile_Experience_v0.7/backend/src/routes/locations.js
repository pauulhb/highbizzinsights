import { Router } from 'express';
import { z } from 'zod';
import { query } from '../db.js';

const router = Router();

router.get('/:customerId/locations', async (req, res, next) => {
  try {
    const result = await query(
      `SELECT *
       FROM customer_locations
       WHERE customer_id = $1
       ORDER BY is_primary DESC, label ASC`,
      [req.params.customerId]
    );
    res.json(result.rows);
  } catch (e) {
    next(e);
  }
});

router.post('/:customerId/locations', async (req, res, next) => {
  try {
    const body = z.object({
      id: z.string().uuid(),
      label: z.string().min(2),
      address: z.string().optional().default(''),
      latitude: z.number(),
      longitude: z.number(),
      isPrimary: z.boolean().optional().default(false)
    }).parse(req.body);

    const result = await query(
      `INSERT INTO customer_locations(
         id, customer_id, label, address, latitude, longitude, is_primary
       ) VALUES($1,$2,$3,$4,$5,$6,$7)
       RETURNING *`,
      [
        body.id,
        req.params.customerId,
        body.label,
        body.address,
        body.latitude,
        body.longitude,
        body.isPrimary
      ]
    );

    res.status(201).json(result.rows[0]);
  } catch (e) {
    next(e);
  }
});

export default router;
