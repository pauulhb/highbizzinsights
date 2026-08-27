import {Router} from 'express';
import {query} from '../db.js';
import {minimumRole} from '../middleware/rbac.js';
import {teamIds} from '../services/teamScope.js';

const router=Router();
router.use(minimumRole('area_manager'));

router.get('/states',async(req,res,next)=>{
 try{
  const ids=await teamIds(req.user);
  const r=await query(
    `SELECT state,COUNT(*)::int employees
     FROM employees WHERE id=ANY($1::uuid[]) GROUP BY state ORDER BY state`,
    [ids]
  );
  res.json(r.rows);
 }catch(e){next(e);}
});

router.get('/hqs',async(req,res,next)=>{
 try{
  const ids=await teamIds(req.user);
  const r=await query(
    `SELECT state,hq,COUNT(*)::int employees
     FROM employees WHERE id=ANY($1::uuid[])
     GROUP BY state,hq ORDER BY state,hq`,
    [ids]
  );
  res.json(r.rows);
 }catch(e){next(e);}
});

router.get('/kams',async(req,res,next)=>{
 try{
  const ids=await teamIds(req.user);
  const r=await query(
    `SELECT id,full_name,state,hq
     FROM employees WHERE id=ANY($1::uuid[]) AND role='kam'
     ORDER BY state,hq,full_name`,
    [ids]
  );
  res.json(r.rows);
 }catch(e){next(e);}
});

export default router;
