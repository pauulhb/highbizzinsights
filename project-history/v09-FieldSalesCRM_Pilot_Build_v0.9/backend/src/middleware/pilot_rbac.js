const roleRank = {
  kam: 10,
  area_manager: 20,
  state_manager: 30,
  regional_head: 40,
  management: 50,
  admin: 60
};

export function atLeast(role) {
  return (req, res, next) => {
    const current = roleRank[req.user?.role] || 0;
    if (current < roleRank[role]) {
      return res.status(403).json({ error: 'Access denied' });
    }
    next();
  };
}
