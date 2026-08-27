import test from 'node:test';
import assert from 'node:assert/strict';
import {api} from './testClient.js';

test('invalid login returns 401', async () => {
  const r = await api('/auth/login',{
    method:'POST',
    body:{employeeCode:'INVALID',password:'INVALID'}
  });
  assert.equal(r.status,401);
});
