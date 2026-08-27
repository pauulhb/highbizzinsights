const rank={
  kam:10,area_manager:20,state_manager:30,regional_head:40,management:50,admin:60
};
export const minimumRole=(role)=>(req,res,next)=>{
  if(!req.user || (rank[req.user.role]||0)<rank[role])
    return res.status(403).json({error:'Insufficient permission'});
  next();
};
