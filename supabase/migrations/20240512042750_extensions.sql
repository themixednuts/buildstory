CREATE EXTENSION IF NOT EXISTS moddatetime SCHEMA "extensions";
ALTER ROLE authenticator
SET pgrst.db_aggregates_enabled = 'true';
NOTIFY pgrst,
'reload config';