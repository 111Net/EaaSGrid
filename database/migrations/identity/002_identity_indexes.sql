
CREATE INDEX IF NOT EXISTS idx_users_email
ON users(email);

CREATE INDEX IF NOT EXISTS idx_sessions_user
ON user_sessions(user_id);

CREATE INDEX IF NOT EXISTS idx_audit_user
ON audit_logs(user_id);

