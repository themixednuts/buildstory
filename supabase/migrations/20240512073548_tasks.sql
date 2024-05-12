CREATE TABLE "tasks" (
    "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
    "checkpoint_id" uuid NOT NULL REFERENCES checkpoints(id) ON DELETE CASCADE,
    "assigned_to" uuid NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    "assigned_by" uuid NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "state" INTEGER NOT NULL REFERENCES states(id),
    "completed_at" timestamp,
    "updated_at" timestamp NOT NULL DEFAULT (now()),
    "created_at" timestamp NOT NULL DEFAULT (now())
);
CREATE INDEX ON tasks (checkpoint_id);
CREATE INDEX ON tasks (assigned_to);
CREATE INDEX ON tasks (assigned_by);
CREATE INDEX ON tasks ("state");
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER PUBLICATION supabase_realtime
ADD TABLE tasks;
CREATE POLICY "Tasks are viewable by everyone." ON tasks FOR
SELECT USING (TRUE);
CREATE POLICY "Users can insert their own tasks." ON tasks FOR
INSERT WITH CHECK (
        (
            SELECT auth.uid ()
        ) = (
            SELECT p.profile_id
            FROM projects p
            WHERE p.id = (
                    SELECT project_id
                    FROM chapters
                    WHERE id = (
                            SELECT chapter_id
                            FROM checkpoints
                            WHERE id = checkpoint_id
                        )
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
CREATE POLICY "Users can update their own tasks." ON tasks FOR
UPDATE USING (
        (
            SELECT auth.uid ()
        ) = (
            SELECT p.profile_id
            FROM projects p
            WHERE p.id = (
                    SELECT project_id
                    FROM chapters
                    WHERE id = (
                            SELECT chapter_id
                            FROM checkpoints
                            WHERE id = checkpoint_id
                        )
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
CREATE POLICY "Users can delete their own tasks." ON tasks FOR DELETE USING (
    (
        SELECT auth.uid ()
    ) = (
        SELECT p.profile_id
        FROM projects p
        WHERE p.id = (
                SELECT project_id
                FROM chapters
                WHERE id = (
                        SELECT chapter_id
                        FROM checkpoints
                        WHERE id = checkpoint_id
                    )
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
CREATE TRIGGER tasks_updated BEFORE
UPDATE ON tasks FOR EACH ROW EXECUTE PROCEDURE moddatetime (updated_at);