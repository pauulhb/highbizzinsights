import test from 'node:test';
import assert from 'node:assert/strict';
import {api} from './testClient.js';

test('health endpoint reports 900 second visit rule', async () => {
  const r = await api('/health');
  assert.equal(r.status, 200);
  assert.equal(r.body.minQualifiedVisitSeconds, 900);
});

// End-to-end 14:59 / 15:00 tests should run against a controllable UAT clock
// or a dedicated test endpoint disabled outside test environments.
