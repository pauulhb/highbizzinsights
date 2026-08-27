import {Router} from 'express';
import {pilotDailyMetrics} from '../services/pilotMetrics.js';
import {minimumRole} from '../middleware/rbac.js';

const router=Router();

router.get('/daily',minimumRole('area_manager'),async(req,res,next)=>{
  try{
    const date=req.query.date ? new Date(String(req.query.date)) : new Date();
    res.json(await pilotDailyMetrics(date));
  }catch(e){next(e);}
});

export default router;
