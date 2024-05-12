CREATE TABLE "projects" (
    "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
    "profile_id" uuid NOT NULL,
    "title" varchar(25) NOT NULL,
    "description" text,
    "logo" text,
    "url" text,
    "state" integer NOT NULL REFERENCES states(id) ON DELETE CASCADE,
    "updated_at" timestamp NOT NULL DEFAULT (now ()),
    "created_at" timestamp NOT NULL DEFAULT (now())
);
CREATE INDEX ON "projects" ("profile_id");
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Projects are viewable by everyone." ON projects FOR
SELECT USING (TRUE);
CREATE POLICY "Users can insert their own projects." ON projects FOR
INSERT WITH CHECK (
        (
            SELECT auth.uid ()
        ) = profile_id
    );
CREATE POLICY "Users can update their own projects." ON projects FOR
UPDATE USING (
        (
            SELECT auth.uid ()
        ) = profile_id
    );
CREATE POLICY "Users can delete their own projects." ON projects FOR DELETE USING (
    (
        SELECT auth.uid ()
    ) = profile_id
);
CREATE TRIGGER project_updated BEFORE
UPDATE ON projects FOR EACH ROW EXECUTE PROCEDURE moddatetime (updated_at);
CREATE TABLE "projects_salutes" (
    "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
    "profile_id" uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    "project_id" uuid NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    "created_at" timestamp NOT NULL DEFAULT (now())
);
CREATE INDEX ON "projects_salutes" ("profile_id");
CREATE INDEX ON "projects_salutes" ("project_id");
ALTER TABLE projects_salutes ENABLE ROW LEVEL SECURITY;
ALTER PUBLICATION supabase_realtime
ADD TABLE projects_salutes;
CREATE POLICY "Project salutes are viewable by everyone." ON projects_salutes FOR
SELECT USING (TRUE);
CREATE POLICY "Users can insert their own projects_salutes." ON projects_salutes FOR
INSERT WITH CHECK (
        (
            SELECT auth.uid ()
        ) = profile_id
    );
CREATE POLICY "Users can update their own projects_salutes." ON projects_salutes FOR
UPDATE USING (
        (
            SELECT auth.uid ()
        ) = profile_id
    );
CREATE POLICY "Users can delete their own projects_salutes." ON projects_salutes FOR DELETE USING (
    (
        SELECT auth.uid ()
    ) = profile_id
);