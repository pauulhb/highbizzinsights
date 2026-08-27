import { Router } from 'express';

const router = Router();

router.get('/pilot-health', (req, res) => {
  res.json({
    status: 'ready_for_uat',
    version: '0.9.0',
    minQualifiedVisitSeconds: 900,
    continuousTrackingRequired: false
  });
});

export default router;
