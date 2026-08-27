import {Router} from 'express';
import bcrypt from 'bcryptjs';
import {z} from 'zod';
import {query} from '../db.js';
import {accessToken,issueRefreshToken,rotateRefreshToken,revokeRefreshToken} from '../services/tokens.js';

const router=Router();

router.post('/login',async(req,res,next)=>{
 try{
  const b=z.object({employeeCode:z.string(),password:z.string()}).parse(req.body);
  const r=await query(
   `SELECT * FROM employees WHERE employee_code=$1 AND is_active=TRUE`,
   [b.employeeCode]
  );
  if(!r.rowCount || !await bcrypt.compare(b.password,r.rows[0].password_hash)) {
    return res.status(401).json({error:'Invalid credentials'});
  }
  const e=r.rows[0];
  res.json({
    accessToken:accessToken(e),
    refreshToken:await issueRefreshToken(e.id),
    employee:{id:e.id,fullName:e.full_name,role:e.role,state:e.state,hq:e.hq}
  });
 }catch(e){next(e);}
});

router.post('/refresh',async(req,res,next)=>{
 try{
  const b=z.object({refreshToken:z.string().min(20)}).parse(req.body);
  const x=await rotateRefreshToken(b.refreshToken);
  res.json({
    accessToken:accessToken(x.employee),
    refreshToken:x.refreshToken
  });
 }catch(e){next(e);}
});

router.post('/logout',async(req,res,next)=>{
 try{
  const b=z.object({refreshToken:z.string().min(20)}).parse(req.body);
  await revokeRefreshToken(b.refreshToken);
  res.json({ok:true});
 }catch(e){next(e);}
});

export default router;
