-- Total members with emails and with web users, minus dups
create table migration_members_web_users_minus_dups_email as
SELECT
	251_user.`251_user_id`, 251_user.`251_user_pw`, 251_user.`251_user_name`,
    251_paid_members.*
FROM
	251_user
    JOIN 251_paid_map on 251_paid_map.251_user_id = 251_user.251_user_id
	JOIN 251_paid_members on 251_paid_members.member_id = 251_paid_map.member_id
	WHERE 251_paid_members.email IS NOT NULL AND email <> ''
    GROUP BY 251_paid_map.member_id
    HAVING COUNT(251_paid_map.member_id)=1;

ALTER TABLE migration_members_web_users_minus_dups_email 
CHANGE COLUMN 
member_id rcp_legacy_member_id int(50);
ALTER TABLE migration_members_web_users_minus_dups_email 
CHANGE COLUMN 
secondary_member rcp_secondary_member varchar(150);
ALTER TABLE migration_members_web_users_minus_dups_email 
CHANGE COLUMN
251_user_id rcp_251_legacy_user_id int(5);
ALTER TABLE migration_members_no_web_email
CHANGE COLUMN
addr_1 rcp_street_line_1 varchar(50);
ALTER TABLE migration_members_web_users_minus_dups_email
CHANGE COLUMN
state rcp_state varchar(50);
ALTER TABLE migration_members_web_users_minus_dups_email
CHANGE COLUMN
zip rcp_zipcode varchar(50);
ALTER TABLE migration_members_web_users_minus_dups_email
CHANGE COLUMN
home_nbr rcp_phone_number varchar(50);
ALTER TABLE migration_members_web_users_minus_dups_email
CHANGE COLUMN
email1 rcp_secondary_email varchar(100);
ALTER TABLE migration_members_web_users_minus_dups_email
CHANGE COLUMN
join_date rcp_join_date varchar(20);


-- Total members with emails and without web users:
create table migration_members_no_web_email as
SELECT  *
FROM    251_paid_members
WHERE   member_id NOT IN
        (
        SELECT  member_id
        FROM    251_paid_map
        )
AND email IS NOT NULL AND email <> '';

ALTER TABLE migration_members_no_web_email 
CHANGE COLUMN 
secondary_member rcp_secondary_member varchar(150);
ALTER TABLE migration_members_no_web_email 
CHANGE COLUMN 
member_id rcp_legacy_member_id int(50);
ALTER TABLE migration_members_no_web_email
CHANGE COLUMN
addr_1 rcp_street_line_1 varchar(50);
ALTER TABLE migration_members_no_web_email
CHANGE COLUMN
state rcp_state varchar(50);
ALTER TABLE migration_members_no_web_email
CHANGE COLUMN
zip rcp_zipcode varchar(50);
ALTER TABLE migration_members_no_web_email
CHANGE COLUMN
home_nbr rcp_phone_number varchar(50);
ALTER TABLE migration_members_no_web_email
CHANGE COLUMN
email1 rcp_secondary_email varchar(100);
ALTER TABLE migration_members_no_web_email
CHANGE COLUMN
join_date rcp_join_date varchar(20);

-- map user names with towns visited
create table migration_map_users_w_towns_visited as
SELECT
	migration_members_web_users_minus_dups_email.`251_user_name`,
    towns.town_name
FROM
	towns_visted
	LEFT JOIN towns on towns_visted.town_id = towns.town_id
    JOIN migration_members_web_users_minus_dups_email 
    ON migration_members_web_users_minus_dups_email.251_user_id = towns_visted.user_id;

-- map user names with town notes
create table migration_map_users_w_town_notes as
SELECT
	251_user_town.pk_id, migration_members_web_users_minus_dups_email.251_user_name, 251_user_town.note, 251_user_town.date_first, 251_user_town.interest,
    towns.town_name
FROM
	251_user_town
	LEFT JOIN towns on 251_user_town.town_id = towns.town_id
    JOIN migration_members_web_users_minus_dups_email 
    ON migration_members_web_users_minus_dups_email.rcp_251_legacy_user_id = 251_user_town.user_id;

-- map user names with towns visited
create table migration_map_users_w_images as
SELECT
	migration_members_web_users_minus_dups_email.`251_user_name`,
    towns.town_name
FROM
	towns_visted
	LEFT JOIN towns on towns_visted.town_id = towns.town_id
    JOIN migration_members_web_users_minus_dups_email 
    ON migration_members_web_users_minus_dups_email.251_user_id = towns_visted.user_id;

-------------------------------------------------------------------------------------------------------------------------------------------------


-- Total member without emails
SELECT * FROM `251_paid_members` WHERE email IS NULL OR email = '';

-- Members with extra users associated with them (dups)
SELECT 251_paid_members.*, COUNT(251_paid_map.member_id) AS 'num of web users'
FROM 251_paid_map
JOIN 251_paid_members on 251_paid_members.member_id = 251_paid_map.member_id
GROUP BY 251_paid_map.member_id
HAVING COUNT(251_paid_map.member_id)>1;

-- Total member with emails
SELECT * FROM `251_paid_members` WHERE email IS NOT NULL AND email <> '';


-- find year only date fields
SELECT * FROM `test_migration_members_no_web_with_email` WHERE paid_thru REGEXP '^[0-9]{4}$'
-- update year: run update-paid_thru-field.php script on server
