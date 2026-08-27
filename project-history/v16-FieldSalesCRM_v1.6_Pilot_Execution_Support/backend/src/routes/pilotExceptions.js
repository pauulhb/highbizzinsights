import {Router} from 'express';
import {query} from '../db.js';
import {minimumRole} from '../middleware/rbac.js';
import {teamIds} from '../services/teamScope.js';

const router=Router();
router.use(minimumRole('area_manager'));

router.get('/short-visits',async(req,res,next)=>{
  try{
    const ids=await teamIds(req.user);
    const r=await query(
      `SELECT v.id,v.employee_id,e.full_name,c.name customer_name,
              v.check_in_at,v.check_out_at,v.duration_seconds,v.short_visit_reason
       FROM visits v
       JOIN employees e ON e.id=v.employee_id
       JOIN customers c ON c.id=v.customer_id
       WHERE v.employee_id=ANY($1::uuid[]) AND v.qualified=FALSE
       ORDER BY v.check_in_at DESC LIMIT 500`,
      [ids]
    );
    res.json(r.rows);
  }catch(e){next(e);}
});

router.get('/geofence',async(req,res,next)=>{
  try{
    const ids=await teamIds(req.user);
    const r=await query(
      `SELECT v.id,v.employee_id,e.full_name,c.name customer_name,
              v.check_in_distance_m,v.check_out_distance_m,v.check_in_at
       FROM visits v
       JOIN employees e ON e.id=v.employee_id
       JOIN customers c ON c.id=v.customer_id
       WHERE v.employee_id=ANY($1::uuid[])
         AND (v.check_in_distance_m>200 OR v.check_out_distance_m>200)
       ORDER BY v.check_in_at DESC LIMIT 500`,
      [ids]
    );
    res.json(r.rows);
  }catch(e){next(e);}
});

export default router;
