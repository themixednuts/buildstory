CREATE TABLE "projects" (
    "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
    "profile_id" uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    "title" varchar(25) NOT NULL CHECK(title <> ''),
    "description" text,
    "logo" text,
    "url" text,
    "state_id" integer NOT NULL REFERENCES states(id) ON DELETE CASCADE DEFAULT 1,
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
CREATE TABLE "projects_upvotes" (
    "upvoted_by" uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    "project_id" uuid NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    "created_at" timestamp NOT NULL DEFAULT (now()),
    PRIMARY KEY ("upvoted_by", "project_id")
);
CREATE INDEX ON "projects_upvotes" ("upvoted_by");
CREATE INDEX ON "projects_upvotes" ("project_id");
ALTER TABLE projects_upvotes ENABLE ROW LEVEL SECURITY;
ALTER PUBLICATION supabase_realtime
ADD TABLE projects_upvotes;
CREATE POLICY "Project upvotes are viewable by everyone." ON projects_upvotes FOR
SELECT USING (TRUE);
CREATE POLICY "Users can insert their own projects_upvotes." ON projects_upvotes FOR
INSERT WITH CHECK (
        (
            SELECT auth.uid ()
        ) = upvoted_by
    );
CREATE POLICY "Users can update their own projects_upvotes." ON projects_upvotes FOR
UPDATE USING (
        (
            SELECT auth.uid ()
        ) = upvoted_by
    );
CREATE POLICY "Users can delete their own projects_upvotes." ON projects_upvotes FOR DELETE USING (
    (
        SELECT auth.uid ()
    ) = upvoted_by
);
CREATE OR REPLACE FUNCTION award_badges_on_project_completion() RETURNS TRIGGER AS $$
DECLARE badge_row RECORD;
completed_projects_count INT;
BEGIN -- Count the number of completed projects for the user
SELECT COUNT(*) INTO completed_projects_count
FROM projects
WHERE profile_id = NEW.profile_id
    AND state_id = 2;
-- Assuming state_id for completed is 2
-- Iterate over each badge to check completion requirements
FOR badge_row IN
SELECT *
FROM badges
WHERE completed_projects IS NOT NULL LOOP -- Check if the user has met the completion requirement for this badge
    IF completed_projects_count >= badge_row.completed_projects THEN -- Check if the badge is already awarded to the user
    IF NOT EXISTS (
        SELECT 1
        FROM profiles_badges
        WHERE badge_id = badge_row.id
            AND profile_id = NEW.profile_id
    ) THEN -- Insert the badge into profiles_badges if it's not already awarded
INSERT INTO profiles_badges (badge_id, profile_id, created_at)
VALUES (badge_row.id, NEW.profile_id, NOW());
END IF;
ELSE -- Remove the badge from profiles_badges if it's awarded and no longer meets the requirement
DELETE FROM profiles_badges
WHERE badge_id = badge_row.id
    AND profile_id = NEW.profile_id;
END IF;
END LOOP;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- Create the trigger
CREATE TRIGGER award_badges_on_update_trigger
AFTER
UPDATE ON projects FOR EACH ROW EXECUTE FUNCTION award_badges_on_project_completion();
CREATE TRIGGER award_badges_on_insert_trigger
AFTER
INSERT ON projects FOR EACH ROW EXECUTE FUNCTION award_badges_on_project_completion();