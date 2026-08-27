import {Router} from 'express';
import {query} from '../db.js';
import {minimumRole} from '../middleware/rbac.js';
import {teamIds} from '../services/teamScope.js';

const router=Router();
router.use(minimumRole('area_manager'));

router.get('/kam/:employeeId/summary',async(req,res,next)=>{
  try{
    const visible=await teamIds(req.user);
    if(!visible.includes(req.params.employeeId)) {
      return res.status(403).json({error:'Employee outside reporting scope'});
    }

    const r=await query(
      `SELECT e.id,e.full_name,e.state,e.hq,
              COUNT(v.id)::int total_visits,
              COUNT(v.id) FILTER(WHERE v.qualified)::int qualified_visits,
              COUNT(v.id) FILTER(WHERE NOT v.qualified)::int short_visits,
              COALESCE(SUM(o.order_value),0)::numeric order_value
       FROM employees e
       LEFT JOIN visits v ON v.employee_id=e.id
         AND v.check_in_at>=date_trunc('month',NOW())
       LEFT JOIN orders o ON o.employee_id=e.id
         AND o.order_date>=date_trunc('month',NOW())::date
       WHERE e.id=$1
       GROUP BY e.id`,
      [req.params.employeeId]
    );
    if(!r.rowCount) return res.status(404).json({error:'Employee not found'});
    res.json(r.rows[0]);
  }catch(e){next(e);}
});

router.get('/kam/:employeeId/customers',async(req,res,next)=>{
  try{
    const visible=await teamIds(req.user);
    if(!visible.includes(req.params.employeeId)) {
      return res.status(403).json({error:'Employee outside reporting scope'});
    }

    const r=await query(
      `SELECT id,name,account_name,customer_type,city,state,potential
       FROM customers
       WHERE assigned_employee_id=$1
       ORDER BY name`,
      [req.params.employeeId]
    );
    res.json(r.rows);
  }catch(e){next(e);}
});

export default router;
