import { Router } from 'express';
import { z } from 'zod';
import { query } from '../db.js';

const router = Router();

const createSchema = z.object({
  id: z.string().uuid(),
  customerType: z.enum(['doctor', 'hospital', 'distributor']),
  name: z.string().min(2),
  accountName: z.string().min(2),
  area: z.string().optional().default(''),
  city: z.string().min(2),
  state: z.string().min(2),
  potential: z.enum(['A+', 'A', 'B', 'C']),
  phone: z.string().optional().nullable(),
  email: z.string().email().optional().nullable(),
  latitude: z.number(),
  longitude: z.number()
});

router.get('/', async (req, res, next) => {
  try {
    const search = String(req.query.q || '').trim();
    const like = `%${search}%`;

    const result = await query(
      `SELECT *
       FROM customers
       WHERE assigned_employee_id = $1
         AND (
           $2 = '' OR
           name ILIKE $3 OR account_name ILIKE $3 OR
           city ILIKE $3 OR area ILIKE $3 OR phone ILIKE $3
         )
       ORDER BY name ASC
       LIMIT 100`,
      [req.user.sub, search, like]
    );

    res.json(result.rows);
  } catch (e) {
    next(e);
  }
});

router.get('/:id/timeline', async (req, res, next) => {
  try {
    const customerId = req.params.id;

    const [visits, samples, leads, orders, followUps] = await Promise.all([
      query(`SELECT 'visit' AS type, check_out_at AS at, outcome AS title, discussion AS detail
             FROM visits WHERE customer_id = $1`, [customerId]),
      query(`SELECT 'sample' AS type, given_on::timestamptz AS at,
                    product_name AS title, feedback_status AS detail
             FROM samples WHERE customer_id = $1`, [customerId]),
      query(`SELECT 'lead' AS type, created_at AS at, product_name AS title,
                    stage || ' | ₹' || expected_value::text AS detail
             FROM leads WHERE customer_id = $1`, [customerId]),
      query(`SELECT 'order' AS type, order_date::timestamptz AS at, product_name AS title,
                    '₹' || order_value::text AS detail
             FROM orders WHERE customer_id = $1`, [customerId]),
      query(`SELECT 'followup' AS type, due_at AS at, title,
                    CASE WHEN completed THEN 'Completed' ELSE 'Pending' END AS detail
             FROM follow_ups WHERE customer_id = $1`, [customerId])
    ]);

    const all = [
      ...visits.rows,
      ...samples.rows,
      ...leads.rows,
      ...orders.rows,
      ...followUps.rows
    ].sort((a, b) => new Date(b.at) - new Date(a.at));

    res.json(all);
  } catch (e) {
    next(e);
  }
});

router.post('/', async (req, res, next) => {
  try {
    const body = createSchema.parse(req.body);

    const duplicate = await query(
      `SELECT id, name, account_name, city, phone
       FROM customers
       WHERE (
         LOWER(name) = LOWER($1) AND LOWER(city) = LOWER($2)
       ) OR (
         $3 IS NOT NULL AND phone = $3
       )
       LIMIT 5`,
      [body.name, body.city, body.phone || null]
    );

    if (duplicate.rowCount > 0 && req.query.force !== 'true') {
      return res.status(409).json({
        error: 'Possible duplicate customer',
        matches: duplicate.rows
      });
    }

    const result = await query(
      `INSERT INTO customers(
         id, customer_type, name, account_name, area, city, state,
         potential, phone, email, latitude, longitude,
         assigned_employee_id, created_by
       ) VALUES(
         $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$13
       )
       RETURNING *`,
      [
        body.id, body.customerType, body.name, body.accountName,
        body.area, body.city, body.state, body.potential,
        body.phone || null, body.email || null,
        body.latitude, body.longitude, req.user.sub
      ]
    );

    res.status(201).json(result.rows[0]);
  } catch (e) {
    next(e);
  }
});

export default router;
