CREATE TABLE "chapters" (
    "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
    "project_id" uuid NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    "order" int NOT NULL,
    "name" text NOT NULL CHECK(name <> ''),
    "state" INTEGER NOT NULL REFERENCES states(id),
    "completed_at" timestamp,
    "updated_at" timestamp NOT NULL DEFAULT (now()),
    "created_at" timestamp NOT NULL DEFAULT (now())
);
CREATE INDEX ON chapters (project_id);
CREATE INDEX ON chapters ("state");
ALTER TABLE chapters ENABLE ROW LEVEL SECURITY;
ALTER PUBLICATION supabase_realtime
ADD TABLE chapters;
CREATE POLICY "Chapters are viewable by everyone." ON chapters FOR
SELECT USING (TRUE);
CREATE POLICY "Users can insert their own chapters." ON chapters FOR
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
CREATE POLICY "Users can update their own chapters." ON chapters FOR
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
CREATE POLICY "Users can delete their own chapters." ON chapters FOR DELETE USING (
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
CREATE TRIGGER chapters_updated BEFORE
UPDATE ON chapters FOR EACH ROW EXECUTE PROCEDURE moddatetime (updated_at);