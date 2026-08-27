import test from 'node:test';
import assert from 'node:assert/strict';

function qualifies(seconds) {
  return seconds >= 900;
}

test('14:59 is short', () => {
  assert.equal(qualifies(899), false);
});

test('15:00 is qualified', () => {
  assert.equal(qualifies(900), true);
});

test('15:01 is qualified', () => {
  assert.equal(qualifies(901), true);
});
