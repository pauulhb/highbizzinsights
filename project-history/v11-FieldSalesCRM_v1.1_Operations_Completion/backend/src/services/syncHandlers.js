import {query} from '../db.js';

export async function applySyncItem(user,item) {
  const p=item.payload;

  switch(item.entityType) {
    case 'customer':
      if(item.action==='create') {
        await query(
          `INSERT INTO customers(
            id,customer_type,name,account_name,area,city,state,potential,phone,email,
            latitude,longitude,assigned_employee_id,created_by
          ) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$13)
          ON CONFLICT(id) DO NOTHING`,
          [p.id,p.customerType,p.name,p.accountName,p.area||'',p.city,p.state,p.potential,
           p.phone||null,p.email||null,p.latitude,p.longitude,user.sub]
        );
      }
      return;

    case 'sample':
      if(item.action==='create') {
        await query(
          `INSERT INTO samples(id,customer_id,employee_id,product_name,quantity,given_on,feedback_status)
           VALUES($1,$2,$3,$4,$5,CURRENT_DATE,$6)
           ON CONFLICT(id) DO NOTHING`,
          [p.id,p.customerId,user.sub,p.productName,p.quantity,p.feedbackStatus||'Awaiting Feedback']
        );
      }
      return;

    case 'lead':
      if(item.action==='create') {
        await query(
          `INSERT INTO leads(id,customer_id,employee_id,product_name,expected_value,probability,stage,status)
           VALUES($1,$2,$3,$4,$5,$6,$7,'open')
           ON CONFLICT(id) DO NOTHING`,
          [p.id,p.customerId,user.sub,p.productName,p.expectedValue||0,p.probability||0,p.stage]
        );
      }
      return;

    case 'order':
      if(item.action==='create') {
        await query(
          `INSERT INTO orders(id,customer_id,employee_id,product_name,quantity,order_value,order_date)
           VALUES($1,$2,$3,$4,$5,$6,CURRENT_DATE)
           ON CONFLICT(id) DO NOTHING`,
          [p.id,p.customerId,user.sub,p.productName,p.quantity||0,p.orderValue||0]
        );
      }
      return;

    case 'followup':
      if(item.action==='create') {
        await query(
          `INSERT INTO follow_ups(id,customer_id,employee_id,title,due_at,completed)
           VALUES($1,$2,$3,$4,$5,FALSE)
           ON CONFLICT(id) DO NOTHING`,
          [p.id,p.customerId,user.sub,p.title,p.dueAt]
        );
      }
      return;

    default:
      throw Object.assign(new Error(`Unsupported sync entity ${item.entityType}`),{status:422});
  }
}
