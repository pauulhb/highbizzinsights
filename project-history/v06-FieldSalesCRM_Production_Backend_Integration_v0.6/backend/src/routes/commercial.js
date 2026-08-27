import { Router } from 'express';
import { z } from 'zod';
import { query } from '../db.js';

const router = Router();

router.post('/samples', async (req, res, next) => {
  try {
    const body = z.object({
      id: z.string().uuid(),
      customerId: z.string().uuid(),
      productName: z.string().min(2),
      quantity: z.number().int().positive(),
      feedbackStatus: z.string().default('Awaiting Feedback')
    }).parse(req.body);

    const result = await query(
      `INSERT INTO samples(
         id, customer_id, employee_id, product_name, quantity,
         given_on, feedback_status
       ) VALUES($1,$2,$3,$4,$5,CURRENT_DATE,$6)
       RETURNING *`,
      [body.id, body.customerId, req.user.sub, body.productName, body.quantity, body.feedbackStatus]
    );

    res.status(201).json(result.rows[0]);
  } catch (e) {
    next(e);
  }
});

router.post('/leads', async (req, res, next) => {
  try {
    const body = z.object({
      id: z.string().uuid(),
      customerId: z.string().uuid(),
      productName: z.string().min(2),
      expectedValue: z.number().nonnegative(),
      probability: z.number().int().min(0).max(100),
      stage: z.string().min(2)
    }).parse(req.body);

    const result = await query(
      `INSERT INTO leads(
         id, customer_id, employee_id, product_name,
         expected_value, probability, stage
       ) VALUES($1,$2,$3,$4,$5,$6,$7)
       RETURNING *`,
      [
        body.id, body.customerId, req.user.sub, body.productName,
        body.expectedValue, body.probability, body.stage
      ]
    );

    res.status(201).json(result.rows[0]);
  } catch (e) {
    next(e);
  }
});

router.post('/orders', async (req, res, next) => {
  try {
    const body = z.object({
      id: z.string().uuid(),
      customerId: z.string().uuid(),
      productName: z.string().min(2),
      quantity: z.number().int().nonnegative(),
      orderValue: z.number().nonnegative()
    }).parse(req.body);

    const result = await query(
      `INSERT INTO orders(
         id, customer_id, employee_id, product_name,
         quantity, order_value, order_date
       ) VALUES($1,$2,$3,$4,$5,$6,CURRENT_DATE)
       RETURNING *`,
      [
        body.id, body.customerId, req.user.sub, body.productName,
        body.quantity, body.orderValue
      ]
    );

    res.status(201).json(result.rows[0]);
  } catch (e) {
    next(e);
  }
});

export default router;
