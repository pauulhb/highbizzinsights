export const serverWins=new Set([
'check_in_at','check_out_at','duration_seconds','qualified','assigned_employee_id','approved_by','approved_at'
]);
export function conflictStrategy(field){
 if(serverWins.has(field)) return 'server_wins';
 if(['discussion','next_action','phone','email','potential'].includes(field)) return 'last_write_wins';
 return 'manual_review';
}
