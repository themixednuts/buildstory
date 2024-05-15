-- Seed data for the "roles" table
INSERT INTO "roles" ("name")
VALUES ('Admin'),
    ('Moderator'),
    ('User');
-- Seed data for the "badges" table
INSERT INTO "badges" ("name", "completed_projects")
VALUES ('Founder', NULL),
    ('Completed 1 Projects', 1),
    ('Completed 3 Projects', 3),
    ('Completed 5 Projects', 5),
    ('Completed 15 Projects', 15),
    ('Completed 25 Projects', 25),
    ('Participated in 10 Events', NULL),
    ('Top Contributor', NULL),
    ('Early Adopter', NULL);
-- Seed data for the "points" table
INSERT INTO "points" ("value", "action", "description")
VALUES (100, 'Login', 'Points earned for logging in'),
    (
        200,
        'Create Project',
        'Points earned for creating a project'
    ),
    (
        50,
        'Comment',
        'Points earned for commenting on a project'
    );
-- Seed data for the "levels" table
INSERT INTO "levels" ("value", "points")
VALUES (1, 100),
    (2, 200),
    (3, 300),
    (4, 400);
-- Seed data for the "states" table
INSERT INTO "states" ("name")
VALUES ('In Progress'),
    ('Completed'),
    ('On Hold');
-- from https://gist.github.com/khattaksd/4e8f4c89f4e928a2ecaad56d4a17ecd1
-- create test users
INSERT INTO auth.users (
        instance_id,
        id,
        aud,
        role,
        email,
        encrypted_password,
        email_confirmed_at,
        recovery_sent_at,
        last_sign_in_at,
        raw_app_meta_data,
        raw_user_meta_data,
        created_at,
        updated_at,
        confirmation_token,
        email_change,
        email_change_token_new,
        recovery_token
    ) (
        select '00000000-0000-0000-0000-000000000000',
            uuid_generate_v4 (),
            'authenticated',
            'authenticated',
            'user' || (ROW_NUMBER() OVER ()) || '@example.com',
            crypt ('password123', gen_salt ('bf')),
            current_timestamp,
            current_timestamp,
            current_timestamp,
            '{"provider":"email","providers":["email"]}',
            '{}',
            current_timestamp,
            current_timestamp,
            '',
            '',
            '',
            ''
        FROM generate_series(1, 10)
    );
-- test user email identities
INSERT INTO auth.identities (
        id,
        user_id,
        provider_id,
        identity_data,
        provider,
        last_sign_in_at,
        created_at,
        updated_at
    ) (
        select uuid_generate_v4 (),
            id,
            id,
            format('{"sub":"%s","email":"%s"}', id::text, email)::jsonb,
            'email',
            current_timestamp,
            current_timestamp,
            current_timestamp
        from auth.users
    );
-- Seed data for the "profiles" table
UPDATE "profiles" AS p
SET "name" = 'User ' || (subquery.seq),
    "avatar" = 'https://avatars.githubusercontent.com/u/' || (1 + FLOOR(RANDOM() * 999))
FROM (
        SELECT id,
            ROW_NUMBER() OVER () AS seq
        FROM auth.users
    ) AS subquery
WHERE p."id" = subquery."id";
-- Seed data for the "projects" table
INSERT INTO "projects" (
        "id",
        "profile_id",
        "title",
        "description",
        "logo",
        "url",
        "state_id",
        "updated_at",
        "created_at"
    )
SELECT gen_random_uuid() AS id,
    p.id AS profile_id,
    'Project ' || ROW_NUMBER() OVER () AS title,
    'Description for Project ' || ROW_NUMBER() OVER () AS description,
    '' AS logo,
    '' AS url,
    2 AS state,
    current_timestamp AS updated_at,
    current_timestamp AS created_at
FROM auth.users u
    JOIN "profiles" p ON u.id = p.id;
-- Generate random badges for each profile
INSERT INTO "profiles_badges" ("badge_id", "profile_id", "created_at")
SELECT b.id AS badge_id,
    p.id AS profile_id,
    current_timestamp AS created_at
FROM "profiles" p
    JOIN "badges" b ON random() < 0.5 ON CONFLICT DO NOTHING;
-- Generate random points for each profile
INSERT INTO "profiles_points" ("id", "profile_id", "point_id", "created_at")
SELECT gen_random_uuid() AS id,
    p.id AS profile_id,
    pt.id AS point_id,
    current_timestamp AS created_at
FROM "profiles" p
    JOIN "points" pt ON random() < 0.5 ON CONFLICT DO NOTHING;