CREATE TABLE "checkpoints" (
    "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
    "chapter_id" uuid NOT NULL REFERENCES chapters(id) ON DELETE CASCADE,
    "order" int NOT NULL,
    "name" text NOT NULL CHECK(name <> ''),
    "state" INTEGER NOT NULL REFERENCES states(id),
    "completed_at" timestamp,
    "updated_at" timestamp NOT NULL DEFAULT (now()),
    "created_at" timestamp NOT NULL DEFAULT (now())
);
CREATE INDEX ON checkpoints (chapter_id);
CREATE INDEX ON checkpoints ("state");
ALTER TABLE checkpoints ENABLE ROW LEVEL SECURITY;
ALTER PUBLICATION supabase_realtime
ADD TABLE checkpoints;
CREATE POLICY "Checkpoints are viewable by everyone." ON checkpoints FOR
SELECT USING (TRUE);
CREATE POLICY "Users can insert their own checkpoints." ON checkpoints FOR
INSERT WITH CHECK (
        (
            SELECT auth.uid ()
        ) = (
            SELECT p.profile_id
            FROM projects p
            WHERE p.id = (
                    SELECT project_id
                    FROM chapters
                    WHERE id = chapter_id
                )
        )
        OR (
            SELECT auth.uid()
        ) IN (
            SELECT profile_id
            FROM contributors
            WHERE role_id IN (1, 2)
        )
    );
CREATE POLICY "Users can update their own checkpoints." ON checkpoints FOR
UPDATE USING (
        (
            SELECT auth.uid ()
        ) = (
            SELECT p.profile_id
            FROM projects p
            WHERE p.id = (
                    SELECT project_id
                    FROM chapters
                    WHERE id = chapter_id
                )
        )
        OR (
            SELECT auth.uid()
        ) IN (
            SELECT profile_id
            FROM contributors
            WHERE role_id IN (1, 2)
        )
    );
CREATE POLICY "Users can delete their own checkpoints." ON checkpoints FOR DELETE USING (
    (
        SELECT auth.uid ()
    ) = (
        SELECT p.profile_id
        FROM projects p
        WHERE p.id = (
                SELECT project_id
                FROM chapters
                WHERE id = chapter_id
            )
    )
    OR (
        SELECT auth.uid()
    ) IN (
        SELECT profile_id
        FROM contributors
        WHERE role_id IN (1, 2)
    )
);
CREATE TRIGGER checkpoints_updated BEFORE
UPDATE ON checkpoints FOR EACH ROW EXECUTE PROCEDURE moddatetime (updated_at);