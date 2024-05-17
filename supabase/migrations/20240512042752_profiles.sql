CREATE TABLE "profiles" (
    "id" UUID PRIMARY KEY NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    "username" varchar(15) NOT NULL UNIQUE CHECK(username <> ''),
    "name" varchar(35),
    "email" TEXT NOT NULL UNIQUE CHECK(email <> ''),
    "bio" TEXT,
    "dream" TEXT,
    "twitter" TEXT UNIQUE,
    "github" TEXT UNIQUE,
    "twitch" TEXT UNIQUE,
    "discord" TEXT UNIQUE,
    "avatar" TEXT,
    "location" TEXT,
    "muted" bool DEFAULT false,
    "updated_at" timestamp NOT NULL DEFAULT (now ()),
    "created_at" timestamp NOT NULL DEFAULT (now ())
);
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Profiles are viewable by everyone." ON profiles FOR
SELECT USING (TRUE);
CREATE POLICY "Users can insert into their own profile." ON profiles FOR
INSERT WITH CHECK (
        (
            SELECT auth.uid ()
        ) = id
    );
CREATE POLICY "Users can update their own profile." ON profiles FOR
UPDATE USING (
        (
            SELECT auth.uid ()
        ) = id
    );
CREATE POLICY "Users can delete own profile." ON profiles FOR DELETE USING (
    (
        SELECT auth.uid()
    ) = id
);
CREATE OR REPLACE FUNCTION public.handle_new_user() RETURNS TRIGGER AS $$ BEGIN WITH numbered_users AS (
        SELECT *,
            ROW_NUMBER() OVER () AS row_num
        FROM auth.users
    )
INSERT INTO public.profiles(id, email, avatar, username)
VALUES(
        NEW.id,
        NEW.email,
        NEW.raw_user_meta_data->>'avatar_url',
        (
            SELECT COALESCE(
                    NEW.raw_user_meta_data->>'user_name',
                    'user' || (
                        SELECT row_num
                        FROM numbered_users
                        WHERE id = NEW.id
                    )
                )
        )
    ) ON CONFLICT("username") DO
UPDATE
SET username = (
        'user' || (
            SELECT row_num
            FROM numbered_users
            WHERE id = NEW.id
        )
    );
RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
CREATE TRIGGER on_auth_user_created
AFTER
INSERT ON auth.users FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
CREATE OR REPLACE FUNCTION public.handle_new_identity() RETURNS TRIGGER AS $$ BEGIN
UPDATE public.profiles
SET github = CASE
        WHEN NEW.provider = 'github' THEN NEW.identity_data->>'user_name'
        ELSE github
    END,
    discord = CASE
        WHEN NEW.provider = 'discord' THEN NEW.identity_data->>'full_name'
        ELSE discord
    END,
    twitch = CASE
        WHEN NEW.provider = 'twitch' THEN NEW.identity_data->>'full_name'
        ELSE twitch
    END,
    twitter = CASE
        WHEN NEW.provider = 'twitter' THEN NEW.identity_data->>'user_name'
        ELSE twitter
    END
WHERE
    /* Add conditions to specify which rows you want to update */
    /* For example, you might want to update based on the user's ID */
    id = NEW.user_id;
RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
CREATE TRIGGER on_auth_indentity_created
AFTER
INSERT ON auth.identities FOR EACH ROW EXECUTE PROCEDURE public.handle_new_identity();
CREATE OR REPLACE FUNCTION public.handle_delete_identity() RETURNS TRIGGER AS $$ BEGIN
UPDATE public.profiles
SET github = CASE
        WHEN OLD.provider = 'github' THEN NULL
        ELSE github
    END,
    discord = CASE
        WHEN OLD.provider = 'discord' THEN NULL
        ELSE discord
    END,
    twitch = CASE
        WHEN OLD.provider = 'twitch' THEN NULL
        ELSE twitch
    END,
    twitter = CASE
        WHEN OLD.provider = 'twitter' THEN NULL
        ELSE twitter
    END
WHERE
    /* Add conditions to specify which rows you want to update */
    /* For example, you might want to update based on the user's ID */
    id = OLD.user_id;
RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
CREATE TRIGGER on_auth_indentity_deleted
AFTER DELETE ON auth.identities FOR EACH ROW EXECUTE PROCEDURE public.handle_delete_identity();
INSERT INTO storage.buckets (id, name, public)
VALUES ('profile_pictures', 'profile_pictures', TRUE) ON CONFLICT DO NOTHING;
-- Set the bucket to be publicly accessible
CREATE POLICY "Profile pictures are publicly accessible." ON storage.buckets FOR
SELECT USING (id = 'profile_pictures');
-- Set up access controls for storage.
CREATE POLICY "Profile pictures are publicly accessible." ON storage.objects FOR
SELECT USING (bucket_id = 'profile_pictures');
CREATE POLICY "Anyone can upload an a profile picture." ON storage.objects FOR
INSERT WITH CHECK (bucket_id = 'profile_pictures');
CREATE POLICY "Anyone can update their own profile picture." ON storage.objects FOR
UPDATE USING (
        (
            SELECT auth.uid ()
        ) = OWNER
    ) WITH CHECK (bucket_id = 'profile_pictures');
CREATE TRIGGER profile_updated BEFORE
UPDATE ON profiles FOR EACH ROW EXECUTE PROCEDURE moddatetime (updated_at);
CREATE TABLE "profiles_badges" (
    "badge_id" int NOT NULL REFERENCES badges(id) ON DELETE CASCADE,
    "profile_id" uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    "created_at" timestamp NOT NULL DEFAULT (now()),
    PRIMARY KEY ("badge_id", "profile_id")
);
CREATE INDEX ON profiles_badges(badge_id);
CREATE INDEX ON profiles_badges(profile_id);
ALTER TABLE profiles_badges ENABLE ROW LEVEL SECURITY;
ALTER PUBLICATION supabase_realtime
ADD TABLE profiles_badges;
CREATE POLICY "Profile badges are viewable by everyone." ON profiles_badges FOR
SELECT USING (TRUE);
CREATE TABLE "profiles_points" (
    "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
    "profile_id" uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    "point_id" integer NOT NULL REFERENCES points(id) ON DELETE CASCADE,
    "created_at" timestamp NOT NULL DEFAULT (now())
);
CREATE INDEX ON profiles_points(point_id);
CREATE INDEX ON profiles_points(profile_id);
ALTER TABLE profiles_points ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Profile points are viewable by everyone." ON profiles_points FOR
SELECT USING (TRUE);
CREATE TABLE "profiles_upvotes" (
    "upvoted_by" uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    "profile_id" uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    "created_at" timestamp NOT NULL DEFAULT (now()),
    PRIMARY KEY ("upvoted_by", "profile_id")
);
CREATE INDEX ON "profiles_upvotes" ("upvoted_by");
CREATE INDEX ON "profiles_upvotes" ("profile_id");
ALTER TABLE profiles_upvotes ENABLE ROW LEVEL SECURITY;
ALTER PUBLICATION supabase_realtime
ADD TABLE profiles_upvotes;
CREATE POLICY "Profile upvotes are viewable by everyone." ON profiles_upvotes FOR
SELECT USING (TRUE);
CREATE POLICY "Users can insert their own profiles_upvotes." ON profiles_upvotes FOR
INSERT WITH CHECK (
        (
            SELECT auth.uid ()
        ) = upvoted_by
    );
CREATE POLICY "Users can update their own profiles_upvotes." ON profiles_upvotes FOR
UPDATE USING (
        (
            SELECT auth.uid ()
        ) = upvoted_by
    );
CREATE POLICY "Users can delete their own profiles_upvotes." ON profiles_upvotes FOR DELETE USING (
    (
        SELECT auth.uid ()
    ) = upvoted_by
);