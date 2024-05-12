CREATE TABLE "roles" (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT UNIQUE
);
ALTER TABLE roles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Roles are viewable by everyone." ON roles FOR
SELECT USING (TRUE);
CREATE TABLE "badges" (
    "id" serial PRIMARY KEY NOT NULL,
    "name" text NOT NULL
);
ALTER TABLE badges ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Badges are viewable by everyone." ON badges FOR
SELECT USING (TRUE);
CREATE TABLE "points" (
    "id" serial PRIMARY KEY NOT NULL,
    "value" integer NOT NULL,
    "action" text,
    "description" text
);
ALTER TABLE points ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Points are viewable by everyone." ON points FOR
SELECT USING (TRUE);
CREATE TABLE "levels" (
    "id" serial PRIMARY KEY NOT NULL,
    "value" integer NOT NULL,
    "points" integer NOT NULL
);
ALTER TABLE levels ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Levels are viewable by everyone." ON levels FOR
SELECT USING (TRUE);
CREATE TABLE states (
    "id" serial PRIMARY KEY NOT NULL,
    "name" text NOT NULL
);
ALTER TABLE states ENABLE ROW LEVEL SECURITY;
CREATE POLICY "States are viewable by everyone." ON states FOR
SELECT USING (TRUE);