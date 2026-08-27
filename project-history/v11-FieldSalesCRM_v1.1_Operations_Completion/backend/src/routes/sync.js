import {Router} from 'express';
import {z} from 'zod';
import {query} from '../db.js';
import {applySyncItem} from '../services/syncHandlers.js';

const router=Router();

const item=z.object({
  idempotencyKey:z.string().uuid(),
  entityType:z.string(),
  entityId:z.string().uuid(),
  action:z.string(),
  payload:z.record(z.any())
});

router.post('/batch',async(req,res,next)=>{
 try{
  const b=z.object({items:z.array(item).max(200)}).parse(req.body);
  const results=[];

  for(const x of b.items){
    const seen=await query(
      `SELECT 1 FROM sync_inbox WHERE idempotency_key=$1`,
      [x.idempotencyKey]
    );
    if(seen.rowCount){
      results.push({idempotencyKey:x.idempotencyKey,status:'already_processed'});
      continue;
    }

    await query('BEGIN');
    try{
      await applySyncItem(req.user,x);
      await query(
        `INSERT INTO sync_inbox(idempotency_key,employee_id,entity_type,entity_id,action)
         VALUES($1,$2,$3,$4,$5)`,
        [x.idempotencyKey,req.user.sub,x.entityType,x.entityId,x.action]
      );
      await query('COMMIT');
      results.push({idempotencyKey:x.idempotencyKey,status:'accepted'});
    }catch(e){
      await query('ROLLBACK');
      results.push({idempotencyKey:x.idempotencyKey,status:'failed',error:e.message});
    }
  }

  res.json({results});
 }catch(e){next(e);}
});
export default router;
