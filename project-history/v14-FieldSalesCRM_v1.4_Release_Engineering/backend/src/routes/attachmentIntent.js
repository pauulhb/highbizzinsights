import {Router} from 'express';
import {z} from 'zod';
import {validateAttachment} from '../services/attachmentPolicy.js';
import {storageAdapter} from '../services/storageAdapter.js';

const router=Router();

router.post('/intent',async(req,res,next)=>{
  try{
    const b=z.object({
      customerId:z.string().uuid(),
      visitId:z.string().uuid().optional().nullable(),
      category:z.enum(['purchase_order','quotation','business_card','document']),
      fileName:z.string().min(1),
      mimeType:z.string().min(3),
      sizeBytes:z.number().int().positive()
    }).parse(req.body);

    validateAttachment(b);

    const intent=await storageAdapter().createUploadIntent({
      fileName:b.fileName,
      mimeType:b.mimeType,
      customerId:b.customerId
    });

    res.json({...intent,category:b.category,visitId:b.visitId||null});
  }catch(e){next(e);}
});

export default router;
