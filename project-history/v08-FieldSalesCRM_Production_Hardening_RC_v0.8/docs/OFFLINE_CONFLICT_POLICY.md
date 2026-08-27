# Offline Conflict Policy
Server wins: visit timestamps/duration/qualification, ownership, approvals and audit fields.
Last-write-wins where permitted: meeting notes, next action, professional contact updates and potential.
Manual review: duplicate merges, conflicting reassignments, approved order changes and concurrent manager edits.
Every queued mutation uses an idempotency key and remains queued until accepted or resolved.
