CREATE TABLE IF NOT EXISTS release_audit(
  id BIGSERIAL PRIMARY KEY,
  build_version VARCHAR(50) NOT NULL,
  environment VARCHAR(30) NOT NULL,
  deployed_by VARCHAR(150),
  deployed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  notes TEXT
);

CREATE INDEX IF NOT EXISTS release_audit_env_idx
ON release_audit(environment,deployed_at DESC);
