import {Router} from 'express';
import {z} from 'zod';
import {query} from '../db.js';
import {minimumRole} from '../middleware/rbac.js';

const router=Router();
router.use(minimumRole('state_manager'));

router.get('/employees',async(req,res,next)=>{
  try{
    const r=await query(
      `SELECT id,employee_code,full_name,role,manager_id,state,hq,is_active
       FROM employees ORDER BY state,hq,full_name`
    );
    res.json(r.rows);
  }catch(e){next(e);}
});

router.patch('/employees/:id',async(req,res,next)=>{
  try{
    const b=z.object({
      managerId:z.string().uuid().optional().nullable(),
      state:z.string().optional(),
      hq:z.string().optional(),
      isActive:z.boolean().optional()
    }).parse(req.body);

    const r=await query(
      `UPDATE employees SET
        manager_id=COALESCE($1,manager_id),
        state=COALESCE($2,state),
        hq=COALESCE($3,hq),
        is_active=COALESCE($4,is_active)
       WHERE id=$5 RETURNING id,employee_code,full_name,role,manager_id,state,hq,is_active`,
      [b.managerId??null,b.state??null,b.hq??null,b.isActive??null,req.params.id]
    );

    if(!r.rowCount) return res.status(404).json({error:'Employee not found'});
    res.json(r.rows[0]);
  }catch(e){next(e);}
});

export default router;
