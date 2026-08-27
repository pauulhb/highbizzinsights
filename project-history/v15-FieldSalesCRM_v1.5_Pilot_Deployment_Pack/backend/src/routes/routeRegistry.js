// Central route registry checklist for v1.5 pilot deployment.
// Wire existing route modules into the application server.

export const routeRegistry = [
  ['public', '/health'],
  ['public', '/ready'],
  ['auth', '/v1/auth'],
  ['customers', '/v1/customers'],
  ['visits', '/v1/visits'],
  ['samples', '/v1/samples'],
  ['leads', '/v1/leads'],
  ['orders', '/v1/orders'],
  ['followups', '/v1/followups'],
  ['reports', '/v1/reports'],
  ['sync', '/v1/sync'],
  ['manager', '/v1/manager'],
  ['reassignments', '/v1/reassignments'],
  ['territories', '/v1/territories'],
  ['admin', '/v1/admin'],
  ['attachments', '/v1/attachments'],
  ['exports', '/v1/exports'],
  ['pdf', '/v1/pdf']
];

export function assertPilotRules() {
  if (Number(process.env.MIN_QUALIFIED_VISIT_SECONDS || 900) !== 900) {
    throw new Error('Pilot blocked: MIN_QUALIFIED_VISIT_SECONDS must equal 900.');
  }
}
