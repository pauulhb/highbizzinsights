import {Router} from 'express';
import {z} from 'zod';
import {query} from '../db.js';
import {validateCapturedLocation} from '../services/locationPolicy.js';

const router = Router();

router.post('/:customerId/verified-location', async (req,res,next) => {
  try {
    const body = z.object({
      label:z.string().min(2).default('Primary Location'),
      address:z.string().optional().default(''),
      latitude:z.number(),
      longitude:z.number(),
      accuracyMeters:z.number().nonnegative().optional().nullable(),
      capturedAt:z.string().datetime(),
      isPrimary:z.boolean().optional().default(false)
    }).parse(req.body);

    validateCapturedLocation(body);

    const result = await query(
      `INSERT INTO customer_locations(
         id,customer_id,label,address,latitude,longitude,
         accuracy_meters,captured_at,is_primary,created_by
       ) VALUES(
         uuid_generate_v4(),$1,$2,$3,$4,$5,$6,$7,$8,$9
       )
       RETURNING *`,
      [
        req.params.customerId,
        body.label,
        body.address,
        body.latitude,
        body.longitude,
        body.accuracyMeters ?? null,
        body.capturedAt,
        body.isPrimary,
        req.user.sub
      ]
    );

    res.status(201).json(result.rows[0]);
  } catch(e) {
    next(e);
  }
});

export default router;
