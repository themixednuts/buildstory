CREATE TABLE "posts" (
    "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
    "profile_id" uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    "title" varchar(25) NOT NULL CHECK(title <> ''),
    "body" text,
    "updated_at" timestamp NOT NULL DEFAULT (now ()),
    "created_at" timestamp NOT NULL DEFAULT (now())
);
CREATE INDEX ON posts (profile_id);
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER PUBLICATION supabase_realtime
ADD TABLE posts;
CREATE POLICY "Posts are viewable by everyone." ON posts FOR
SELECT USING (TRUE);
CREATE POLICY "Users can insert their own posts." ON posts FOR
INSERT WITH CHECK (
        (
            SELECT auth.uid ()
        ) = profile_id
    );
CREATE POLICY "Users can update their own posts." ON posts FOR
UPDATE USING (
        (
            SELECT auth.uid ()
        ) = profile_id
    );
CREATE POLICY "Users can delete their own posts." ON posts FOR DELETE USING (
    (
        SELECT auth.uid ()
    ) = profile_id
);
CREATE OR REPLACE FUNCTION check_recent_post() RETURNS TRIGGER AS $$
DECLARE last_post_time TIMESTAMP;
time_difference INTERVAL;
BEGIN -- Get the timestamp of the most recent post by the same user
SELECT MAX(created_at) INTO last_post_time
FROM posts
WHERE profile_id = NEW.profile_id;
-- Calculate the time difference between the current timestamp and the timestamp of the most recent post
time_difference := NOW() - last_post_time;
-- Check if the time difference is less than 1 minute
IF time_difference < INTERVAL '1 minute' THEN -- Raise an exception with the time remaining until the user can insert another post
RAISE EXCEPTION 'Cannot insert another post within the next [%]',
(INTERVAL '1 minute' - time_difference)::TEXT;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER prevent_duplicate_post BEFORE
INSERT ON posts FOR EACH ROW EXECUTE FUNCTION check_recent_post();
CREATE TRIGGER posts_updated BEFORE
UPDATE ON posts FOR EACH ROW EXECUTE PROCEDURE moddatetime (updated_at);
CREATE TABLE "posts_upvotes" (
    "upvoted_by" uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    "post_id" uuid NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    "created_at" timestamp NOT NULL DEFAULT (now()),
    PRIMARY KEY ("upvoted_by", "post_id")
);
CREATE INDEX ON posts_upvotes (upvoted_by);
CREATE INDEX ON posts_upvotes (post_id);
ALTER TABLE posts_upvotes ENABLE ROW LEVEL SECURITY;
ALTER PUBLICATION supabase_realtime
ADD TABLE posts_upvotes;
CREATE POLICY "Post upvotes are viewable by everyone." ON posts_upvotes FOR
SELECT USING (TRUE);
CREATE POLICY "Users can insert their own posts_upvotes." ON posts_upvotes FOR
INSERT WITH CHECK (
        (
            SELECT auth.uid ()
        ) = upvoted_by
    );
CREATE POLICY "Users can delete their own posts_upvotes." ON posts_upvotes FOR DELETE USING (
    (
        SELECT auth.uid ()
    ) = upvoted_by
);