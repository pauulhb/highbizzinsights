import {query} from '../db.js';
export async function teamIds(user){
  if(user.role==='kam') return [user.sub];
  const r=await query(
    `WITH RECURSIVE t AS(
       SELECT id FROM employees WHERE id=$1
       UNION ALL
       SELECT e.id FROM employees e JOIN t ON e.manager_id=t.id
     ) SELECT id FROM t`,
    [user.sub]
  );
  return r.rows.map(x=>x.id);
}
