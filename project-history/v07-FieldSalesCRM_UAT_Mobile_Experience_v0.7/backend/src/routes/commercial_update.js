import { Router } from 'express';
import { z } from 'zod';
import { query } from '../db.js';

const router = Router();

router.patch('/samples/:id', async (req, res, next) => {
  try {
    const body = z.object({
      feedbackStatus: z.string().min(2)
    }).parse(req.body);

    const result = await query(
      `UPDATE samples
       SET feedback_status = $1
       WHERE id = $2 AND employee_id = $3
       RETURNING *`,
      [body.feedbackStatus, req.params.id, req.user.sub]
    );

    res.json(result.rows[0]);
  } catch (e) {
    next(e);
  }
});

router.patch('/leads/:id', async (req, res, next) => {
  try {
    const body = z.object({
      stage: z.string().min(2).optional(),
      probability: z.number().int().min(0).max(100).optional(),
      status: z.enum(['open', 'won', 'lost']).optional()
    }).parse(req.body);

    const result = await query(
      `UPDATE leads
       SET stage = COALESCE($1, stage),
           probability = COALESCE($2, probability),
           status = COALESCE($3, status)
       WHERE id = $4 AND employee_id = $5
       RETURNING *`,
      [body.stage ?? null, body.probability ?? null, body.status ?? null, req.params.id, req.user.sub]
    );

    res.json(result.rows[0]);
  } catch (e) {
    next(e);
  }
});

export default router;
