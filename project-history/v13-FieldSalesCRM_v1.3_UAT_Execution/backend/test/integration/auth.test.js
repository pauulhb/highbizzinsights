import test from 'node:test';
import assert from 'node:assert/strict';

test('auth integration placeholder', async () => {
  // In UAT CI, replace with Supertest or real HTTP calls against the UAT API.
  // Required cases:
  // 1. valid login -> access + refresh token
  // 2. invalid password -> 401
  // 3. refresh rotates token
  // 4. revoked refresh token cannot be reused
  assert.equal(true, true);
});
