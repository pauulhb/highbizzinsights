import { Router } from 'express';
import { z } from 'zod';
import { query } from '../db.js';

const router = Router();

router.get('/', async (req, res, next) => {
  try {
    const result = await query(
      `SELECT *
       FROM follow_ups
       WHERE employee_id = $1
       ORDER BY completed ASC, due_at ASC`,
      [req.user.sub]
    );
    res.json(result.rows);
  } catch (e) {
    next(e);
  }
});

router.patch('/:id', async (req, res, next) => {
  try {
    const body = z.object({
      completed: z.boolean()
    }).parse(req.body);

    const result = await query(
      `UPDATE follow_ups
       SET completed = $1,
           completed_at = CASE WHEN $1 THEN NOW() ELSE NULL END
       WHERE id = $2 AND employee_id = $3
       RETURNING *`,
      [body.completed, req.params.id, req.user.sub]
    );

    if (!result.rowCount) {
      return res.status(404).json({ error: 'Follow-up not found' });
    }

    res.json(result.rows[0]);
  } catch (e) {
    next(e);
  }
});

export default router;
