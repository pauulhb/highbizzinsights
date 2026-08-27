import {Router} from 'express';
import {z} from 'zod';
import {query} from '../db.js';
import {minimumRole} from '../middleware/rbac.js';

const router=Router();

router.get('/',minimumRole('area_manager'),async(req,res,next)=>{
 try{
  const r=await query(`SELECT * FROM territories ORDER BY state,hq`);
  res.json(r.rows);
 }catch(e){next(e);}
});

router.post('/',minimumRole('state_manager'),async(req,res,next)=>{
 try{
  const b=z.object({
    id:z.string().uuid(),
    state:z.string().min(2),
    hq:z.string().min(2),
    cities:z.array(z.string()).min(1),
    assignedEmployeeId:z.string().uuid().optional().nullable()
  }).parse(req.body);

  const r=await query(
    `INSERT INTO territories(id,state,hq,cities,assigned_employee_id)
     VALUES($1,$2,$3,$4,$5)
     ON CONFLICT(id) DO UPDATE SET state=EXCLUDED.state,hq=EXCLUDED.hq,
       cities=EXCLUDED.cities,assigned_employee_id=EXCLUDED.assigned_employee_id
     RETURNING *`,
    [b.id,b.state,b.hq,JSON.stringify(b.cities),b.assignedEmployeeId||null]
  );
  res.status(201).json(r.rows[0]);
 }catch(e){next(e);}
});

export default router;
