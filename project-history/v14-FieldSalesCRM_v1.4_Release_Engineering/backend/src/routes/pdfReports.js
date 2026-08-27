import {Router} from 'express';
import {buildPerformancePdf} from '../services/pdfReportService.js';

const router=Router();

router.post('/performance',async(req,res,next)=>{
  try{
    const result=await buildPerformancePdf(req.body);
    res.json(result);
  }catch(e){next(e);}
});

export default router;
