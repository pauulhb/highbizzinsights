import { Router } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { z } from 'zod';
import { query } from '../db.js';

const router = Router();

const loginSchema = z.object({
  employeeCode: z.string().min(1),
  password: z.string().min(1)
});

router.post('/login', async (req, res, next) => {
  try {
    const body = loginSchema.parse(req.body);

    const result = await query(
      `SELECT id, employee_code, full_name, role, manager_id, state, hq, password_hash, is_active
       FROM employees
       WHERE employee_code = $1`,
      [body.employeeCode]
    );

    if (!result.rowCount || !result.rows[0].is_active) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const employee = result.rows[0];
    const ok = await bcrypt.compare(body.password, employee.password_hash);

    if (!ok) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const token = jwt.sign(
      {
        sub: employee.id,
        employeeCode: employee.employee_code,
        role: employee.role,
        state: employee.state,
        hq: employee.hq
      },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '8h' }
    );

    res.json({
      token,
      employee: {
        id: employee.id,
        employeeCode: employee.employee_code,
        fullName: employee.full_name,
        role: employee.role,
        managerId: employee.manager_id,
        state: employee.state,
        hq: employee.hq
      }
    });
  } catch (e) {
    next(e);
  }
});

export default router;
