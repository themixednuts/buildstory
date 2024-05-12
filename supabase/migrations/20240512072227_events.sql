CREATE TABLE "events" (
  "id" serial PRIMARY KEY NOT NULL,
  "project_id" uuid NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  "title" text NOT NULL,
  "start_date" timestamptz NOT NULL,
  "end_date" timestamptz NOT NULL,
  "updated_at" timestamp NOT NULL DEFAULT (now()),
  "created_at" timestamp NOT NULL DEFAULT (now())
);
CREATE INDEX ON "events" ("project_id");
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER PUBLICATION supabase_realtime
ADD TABLE events;
CREATE POLICY "Events are viewable by everyone." ON events FOR
SELECT USING (TRUE);
CREATE POLICY "Users can insert their own events." ON events FOR
INSERT WITH CHECK (
    (
      SELECT auth.uid ()
    ) = (
      SELECT p.profile_id
      FROM projects p
      WHERE p.id = project_id
    )
    OR (
      SELECT auth.uid()
    ) IN (
      SELECT profile_id
      FROM contributors
      WHERE role_id IN (1, 2)
    )
  );
CREATE POLICY "Users can update their own events." ON events FOR
UPDATE USING (
    (
      SELECT auth.uid ()
    ) = (
      SELECT p.profile_id
      FROM projects p
      WHERE p.id = project_id
    )
    OR (
      SELECT auth.uid()
    ) IN (
      SELECT profile_id
      FROM contributors
      WHERE role_id IN (1, 2)
    )
  );
CREATE POLICY "Users can delete their own events." ON events FOR DELETE USING (
  (
    SELECT auth.uid ()
  ) = (
    SELECT p.profile_id
    FROM projects p
    WHERE p.id = project_id
  )
  OR (
    SELECT auth.uid()
  ) IN (
    SELECT profile_id
    FROM contributors
    WHERE role_id IN (1, 2)
  )
);
CREATE TRIGGER events_updated BEFORE
UPDATE ON events FOR EACH ROW EXECUTE PROCEDURE moddatetime (updated_at);