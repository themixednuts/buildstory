CREATE TABLE "reports" (
    "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
    "profile_id" uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    "reported_by" uuid NOT NULL REFERENCES profiles(id),
    "reason" text,
    "created_at" timestamp NOT NULL DEFAULT (now())
);
CREATE INDEX ON reports (profile_id);
CREATE INDEX ON reports (reported_by);
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Reports are viewable by everyone." ON reports FOR
SELECT USING (TRUE);
CREATE POLICY "Users can insert their own reports." ON reports FOR
INSERT WITH CHECK (
        (
            SELECT auth.uid ()
        ) = reported_by
    );
CREATE POLICY "Users can delete their own reports." ON reports FOR DELETE USING (
    (
        SELECT auth.uid ()
    ) = reported_by
);
CREATE OR REPLACE FUNCTION check_recent_report() RETURNS TRIGGER AS $$
DECLARE last_report_time TIMESTAMP;
time_difference INTERVAL;
BEGIN -- Get the timestamp of the most recent post by the same user
SELECT MAX(created_at) INTO last_report_time
FROM reports
WHERE reported_by = NEW.reported_by;
-- Calculate the time difference between the current timestamp and the timestamp of the most recent post
time_difference := NOW() - last_report_time;
-- Check if the time difference is less than 1 minute
IF time_difference < INTERVAL '1 minute' THEN -- Raise an exception with the time remaining until the user can insert another post
RAISE EXCEPTION 'Cannot make a report of this profile for another [%]',
(INTERVAL '1 minute' - time_difference)::TEXT;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER prevent_duplicate_reports BEFORE
INSERT ON reports FOR EACH ROW EXECUTE FUNCTION check_recent_report();