import crypto from 'crypto';
import jwt from 'jsonwebtoken';
import {query} from '../db.js';

export function accessToken(employee) {
  return jwt.sign(
    {
      sub:employee.id,
      role:employee.role,
      state:employee.state,
      hq:employee.hq
    },
    process.env.JWT_SECRET,
    {expiresIn:'30m'}
  );
}

export async function issueRefreshToken(employeeId) {
  const raw = crypto.randomBytes(48).toString('hex');
  const hash = crypto.createHash('sha256').update(raw).digest('hex');
  await query(
    `INSERT INTO refresh_tokens(employee_id,token_hash,expires_at)
     VALUES($1,$2,NOW()+INTERVAL '30 days')`,
    [employeeId,hash]
  );
  return raw;
}

export async function rotateRefreshToken(raw) {
  const hash = crypto.createHash('sha256').update(raw).digest('hex');
  const r = await query(
    `SELECT rt.*,e.id,e.role,e.state,e.hq,e.full_name
     FROM refresh_tokens rt
     JOIN employees e ON e.id=rt.employee_id
     WHERE rt.token_hash=$1 AND rt.revoked_at IS NULL AND rt.expires_at>NOW()`,
    [hash]
  );
  if(!r.rowCount) throw Object.assign(new Error('Invalid refresh token'),{status:401});

  await query(`UPDATE refresh_tokens SET revoked_at=NOW() WHERE id=$1`,[r.rows[0].id]);
  const next = await issueRefreshToken(r.rows[0].employee_id);
  return {employee:r.rows[0],refreshToken:next};
}

export async function revokeRefreshToken(raw) {
  const hash = crypto.createHash('sha256').update(raw).digest('hex');
  await query(`UPDATE refresh_tokens SET revoked_at=NOW() WHERE token_hash=$1`,[hash]);
}
