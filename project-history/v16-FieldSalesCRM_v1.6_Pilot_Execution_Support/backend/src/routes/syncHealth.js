import {Router} from 'express';
import {query} from '../db.js';
import {minimumRole} from '../middleware/rbac.js';

const router=Router();

router.get('/sync-health',minimumRole('area_manager'),async(req,res,next)=>{
  try{
    const r=await query(
      `SELECT
         COUNT(*)::int processed_items,
         MAX(received_at) last_processed_at
       FROM sync_inbox
       WHERE received_at>=NOW()-INTERVAL '24 hours'`
    );
    res.json(r.rows[0]);
  }catch(e){next(e);}
});

export default router;
