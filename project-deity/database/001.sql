-- Create schema
CREATE SCHEMA IF NOT EXISTS "project-deity";

-- Create versioning table
CREATE TABLE IF NOT EXISTS "project-deity".db_versioning
(
    version integer,
    PRIMARY KEY (version)
);

-- Increment version number
INSERT INTO "project-deity".db_versioning (version) VALUES (1);
COMMENT ON TABLE "project-deity".db_versioning
  IS 'This table keeps track of schema revisions.';

-- Create player inventory table
CREATE TABLE IF NOT EXISTS "project-deity".follower_inventories
(
    id bigserial,
    follower_id integer NOT NULL,
    slot_num smallint NOT NULL,
    item_id bigint NOT NULL,
    PRIMARY KEY (id)
);
COMMENT ON TABLE "project-deity".follower_inventories
  IS 'This table holds player inventories, with each row corresponding to an inventory slot that contains either a basic item or a player-crafted item.';

-- Create item master record table
CREATE TABLE IF NOT EXISTS "project-deity".items
(
    id bigserial,
    name text NOT NULL,
    class_type text NOT NULL,
    image text NOT NULL,
    value smallint NOT NULL,
    weight smallint NOT NULL,
    rarity smallint NOT NULL DEFAULT 0,
    modifier text,
    json_attributes text,
    PRIMARY KEY (id)
);
COMMENT ON TABLE "project-deity".items
  IS 'This table holds the "master" items, used as templates for other items.';

-- Create crafted item table
CREATE TABLE IF NOT EXISTS "project-deity".player_items
(
    id bigserial,
    name text NOT NULL,
    class_type text NOT NULL,
    image text NOT NULL,
    value smallint NOT NULL,
    weight smallint NOT NULL,
    rarity smallint NOT NULL DEFAULT 0,
    modifier text,
    json_attributes text,
    PRIMARY KEY (id)
);
COMMENT ON TABLE "project-deity".player_items
  IS 'This table holds instances of items.';

-- Create account table
CREATE TABLE IF NOT EXISTS "project-deity".deities
(
    id bigserial,
    name text NOT NULL,
    discord bigint,
    PRIMARY KEY (id)
);
COMMENT ON TABLE "project-deity".deities
  IS 'This table holds deity/account records.';

-- Create character table
CREATE TABLE IF NOT EXISTS "project-deity".followers
(
    id bigserial,
    name text NOT NULL,
    class_id smallint NOT NULL,
    gender text NOT NULL DEFAULT 'Neutral',
    deity_id bigint NOT NULL,
    level smallint NOT NULL DEFAULT 1,
    exp bigint NOT NULL DEFAULT 0,
    next_level_exp bigint NOT NULL DEFAULT 100,
    monies bigint NOT NULL DEFAULT 100,
    strength integer NOT NULL,
    endurance integer NOT NULL,
    intelligence integer NOT NULL,
    agility integer NOT NULL,
    willpower integer NOT NULL,
    luck integer NOT NULL DEFAULT 3,
    stat_points integer NOT NULL DEFAULT 0,
    reputation integer NOT NULL DEFAULT 0,
    devotion integer NOT NULL DEFAULT 0,
    hp integer NOT NULL DEFAULT 0,
    max_hp integer NOT NULL DEFAULT 0,
    mp integer NOT NULL DEFAULT 0,
    max_mp integer NOT NULL DEFAULT 0,
    inv_width smallint NOT NULL DEFAULT 5,
    inv_height smallint NOT NULL DEFAULT 5,
    PRIMARY KEY (id)
);
COMMENT ON TABLE "project-deity".followers
    IS 'This table contains followers, or characters, owned by deities.';

-- Create equipment table
CREATE TABLE IF NOT EXISTS "project-deity".follower_equipment
(
    follower_id bigint,
    accessory bigint,
    helmet bigint,
    ring bigint,
    weapon bigint,
    armor bigint,
    shield bigint,
    gloves bigint,
    legs bigint,
    boots bigint,
    PRIMARY KEY (follower_id)
);

COMMENT ON TABLE "project-deity".follower_equipment
    IS 'This table holds player/follower equipment.';

-- Create follower/character class table
CREATE TABLE "project-deity".follower_classes
(
    id smallserial,
    class_name text NOT NULL,
    strength smallint NOT NULL,
    endurance smallint NOT NULL,
    intelligence smallint NOT NULL,
    agility smallint NOT NULL,
    willpower smallint NOT NULL,
    hp_bonus smallint NOT NULL,
    mp_bonus smallint NOT NULL,
    inv_width smallint NOT NULL DEFAULT 5,
    inv_height smallint NOT NULL DEFAULT 5,
    PRIMARY KEY (id)
);
COMMENT ON TABLE "project-deity".follower_classes
    IS 'This table contains information relating to character/follower classes.';

-- Create daily login/activity table
CREATE TABLE "project-deity".daily_login
(
    follower_id bigint NOT NULL,
    streak smallint NOT NULL DEFAULT 0,
    last_login timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT daily_login_pkey PRIMARY KEY (follower_id)
);
COMMENT ON TABLE "project-deity".daily_login
    IS 'This table holds the last login time as well as the streak for items.';

-- Create table for holding login rewards
CREATE TABLE "project-deity".login_rewards
(
    day smallint,
    item_id bigint NOT NULL
);
COMMENT ON TABLE "project-deity".login_rewards
    IS 'This table holds the items that drop based off login streak.';