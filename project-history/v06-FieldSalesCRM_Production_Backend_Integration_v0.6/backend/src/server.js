import 'dotenv/config';
import express from 'express';
import cors from 'cors';

import authRoutes from './routes/auth.js';
import customerRoutes from './routes/customers.js';
import visitRoutes from './routes/visits.js';
import commercialRoutes from './routes/commercial.js';
import reportRoutes from './routes/reports.js';
import syncRoutes from './routes/sync.js';
import { requireAuth } from './middleware/auth.js';

const app = express();
app.use(cors());
app.use(express.json({ limit: '2mb' }));

app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    version: '0.6.0',
    minQualifiedVisitSeconds: Number(process.env.MIN_QUALIFIED_VISIT_SECONDS || 900)
  });
});

app.use('/v1/auth', authRoutes);
app.use('/v1/customers', requireAuth, customerRoutes);
app.use('/v1/visits', requireAuth, visitRoutes);
app.use('/v1', requireAuth, commercialRoutes);
app.use('/v1/reports', requireAuth, reportRoutes);
app.use('/v1/sync', requireAuth, syncRoutes);

app.use((err, req, res, next) => {
  console.error(err);
  const status = err.status || (err.name === 'ZodError' ? 400 : 500);
  res.status(status).json({
    error: err.message || 'Unexpected server error',
    details: err.issues || undefined
  });
});

const port = Number(process.env.PORT || 8080);
app.listen(port, () => {
  console.log(`Field Sales CRM API running on port ${port}`);
});
