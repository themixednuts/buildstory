CREATE TABLE "contributors" (
    "project_id" uuid NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    "profile_id" uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    "role_id" integer NOT NULL REFERENCES roles(id),
    "updated_at" timestamp NOT NULL DEFAULT (now ()),
    "created_at" timestamp NOT NULL DEFAULT (now()),
    PRIMARY KEY ("profile_id", "project_id")
);
CREATE INDEX ON "contributors" ("profile_id");
CREATE INDEX ON "contributors" ("project_id");
ALTER TABLE contributors ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Contributors are viewable by everyone." ON contributors FOR
SELECT USING (TRUE);
CREATE POLICY "Users can insert their own contributors." ON contributors FOR
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
CREATE POLICY "Users can update their own contributors." ON contributors FOR
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
CREATE POLICY "Users can delete their own contributors." ON contributors FOR DELETE USING (
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
CREATE TRIGGER contributors_updated BEFORE
UPDATE ON contributors FOR EACH ROW EXECUTE PROCEDURE moddatetime (updated_at);