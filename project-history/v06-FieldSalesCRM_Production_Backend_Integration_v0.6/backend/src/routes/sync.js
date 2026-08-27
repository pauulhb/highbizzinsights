import { Router } from 'express';
import { z } from 'zod';
import { query } from '../db.js';

const router = Router();

const itemSchema = z.object({
  idempotencyKey: z.string().uuid(),
  entityType: z.string().min(2),
  entityId: z.string().uuid(),
  action: z.string().min(2),
  payload: z.record(z.any())
});

router.post('/batch', async (req, res, next) => {
  try {
    const body = z.object({
      items: z.array(itemSchema).max(200)
    }).parse(req.body);

    const results = [];

    for (const item of body.items) {
      const existing = await query(
        `SELECT idempotency_key
         FROM sync_inbox
         WHERE idempotency_key = $1`,
        [item.idempotencyKey]
      );

      if (existing.rowCount) {
        results.push({
          idempotencyKey: item.idempotencyKey,
          status: 'already_processed'
        });
        continue;
      }

      await query(
        `INSERT INTO sync_inbox(
           idempotency_key, employee_id, entity_type, entity_id, action
         ) VALUES($1,$2,$3,$4,$5)`,
        [
          item.idempotencyKey,
          req.user.sub,
          item.entityType,
          item.entityId,
          item.action
        ]
      );

      // Production expansion:
      // route payload through entity-specific service in one DB transaction.
      results.push({
        idempotencyKey: item.idempotencyKey,
        status: 'accepted'
      });
    }

    res.json({ results });
  } catch (e) {
    next(e);
  }
});

export default router;
