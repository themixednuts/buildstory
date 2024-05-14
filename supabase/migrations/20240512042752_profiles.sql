CREATE TABLE "profiles" (
    "id" uuid PRIMARY KEY NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    "username" varchar(15) NOT NULL,
    "name" varchar(35),
    "email" text NOT NULL,
    "bio" text,
    "twitter" TEXT UNIQUE,
    "github" TEXT UNIQUE,
    "twitch" TEXT UNIQUE,
    "discord" TEXT UNIQUE,
    "avatar" text NOT NULL,
    "location" text,
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
CREATE OR REPLACE FUNCTION public.handle_new_user() RETURNS TRIGGER AS $$ BEGIN
INSERT INTO public.profiles(id, email, avatar, username, github)
VALUES(
        NEW.id,
        NEW.email,
        NEW.raw_user_meta_data->>'avatar_url',
        NEW.raw_user_meta_data->>'user_name',
        NEW.raw_user_meta_data->>'user_name'
    );
RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
CREATE TRIGGER on_auth_user_created
AFTER
INSERT ON auth.users FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
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