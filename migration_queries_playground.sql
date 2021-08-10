
UPDATE tbl_name 
SELECT * FROM test_migration_members_no_web_with_email WHERE paid_thru REGEXP ('^[0-9]{4}$');
SET paid_thru = REGEXP_REPLACE(paid_thru,'^\d{4}$', '/%Y-%m-%d'); 




CREATE table migration_user_member_join_no_dups AS
SELECT
	251_user.*,
    251_paid_members.member_id, 251_paid_members.member_status, 251_paid_members.email, 251_paid_members.level, 251_paid_members.secondary_member, 251_paid_members.addr_1, 251_paid_members.city, 251_paid_members.state, 251_paid_members.zip, 251_paid_members.home_nbr, 251_paid_members.email1,
	251_paid_members.last_update_dt, 251_paid_members.paid_thru, 251_paid_members.join_date

FROM
	251_user
    JOIN 251_paid_map on 251_paid_map.251_user_id = 251_user.251_user_id
	JOIN 251_paid_members on 251_paid_members.member_id = 251_paid_map.member_id
	GROUP BY 251_paid_map.member_id
	HAVING COUNT(251_paid_map.member_id)=1
    ORDER BY 251_user_id DESC;

CREATE table duplicate_users AS
SELECT 251_paid_members.member_id, 251_paid_members.first_name, 251_paid_members.last_name, 251_paid_members.level, 251_paid_members.member_status, 251_paid_members.paid_thru, COUNT(251_paid_map.member_id) AS 'num of web users'
FROM 251_paid_map
JOIN 251_paid_members on 251_paid_members.member_id = 251_paid_map.member_id
GROUP BY 251_paid_map.member_id
HAVING COUNT(251_paid_map.member_id)>1

CREATE table migration_user_no_dups AS
SELECT 251_user.*,
    251_paid_members.member_id, 251_paid_members.member_status, 251_paid_members.email, 251_paid_members.level, 251_paid_members.secondary_member, 251_paid_members.addr_1, 251_paid_members.city, 251_paid_members.state, 251_paid_members.zip, 251_paid_members.home_nbr, 251_paid_members.email1,
	251_paid_members.last_update_dt, 251_paid_members.paid_thru, 251_paid_members.join_date
FROM 251_user
JOIN 251_paid_map on 251_paid_map.251_user_id = 251_user.251_user_id
JOIN 251_paid_members on 251_paid_members.member_id = 251_paid_map.member_id
GROUP BY 251_paid_map.member_id
HAVING COUNT(251_paid_map.member_id)=1

SELECT
	towns_visted.user_id,
    towns.town_name,
    251_paid_map.251_user_name
FROM
	towns_visted
	LEFT JOIN towns on towns_visted.town_id = towns.town_id;
    JOIN 251_paid_map on towns_visted.town_id = 251_paid_map.251_user_id;


DELETE FROM db_rcp_memberships WHERE user_id != 1;
DELETE FROM db_rcp_customers WHERE user_id != 1;


SELECT member_id, 251_user_id, COUNT(251_user_id)
FROM 251_paid_map
GROUP BY 251_user_id
HAVING COUNT(251_user_id)>1
ORDER BY member_id;

SELECT member_id, 251_user_id, COUNT(member_id)
FROM 251_paid_map
GROUP BY member_id
HAVING COUNT(member_id)>1
ORDER BY member_id;

SELECT member_id, 251_user_id, COUNT(251_user_id)
FROM migration_user_member_join
GROUP BY 251_user_id
HAVING COUNT(251_user_id)>1
ORDER BY member_id;

SELECT member_id, 251_user_id, COUNT(member_id)
FROM migration_user_member_join
GROUP BY member_id
HAVING COUNT(member_id)>1
ORDER BY member_id;

SELECT *
FROM 251_user
LEFT JOIN 251_contact ON 251_user.251_user_id = 251_contact.251_user_id
WHERE 251_contact.251_user_id IS NULL
ORDER BY 251_user.`251_user_name`;

SELECT COUNT(251_user.`251_user_name`), 251_user.`251_user_id`, 251_user.`251_user_name`
FROM 251_user
LEFT JOIN 251_contact ON 251_user.251_user_id = 251_contact.251_user_id
GROUP BY 251_user.`251_user_name`
WHERE 251_contact.251_user_id IS NULL
HAVING COUNT(251_user.`251_user_name`)>1
ORDER BY 251_user.`251_user_name`;

-- from legacy code --
-- paid map??
"select `251_paid_map`.member_id, `251_paid_members`.member_status from 251_paid_map, 251_paid_members where 251_user_id = '$user11' AND member_status = 'ACTIVE'";

-- paid website
"SELECT \"Total Current Website Members\" as dname ,count(member_id) as uids FROM vt251_251.251_paid_members WHERE member_id IN (SELECT member_id from vt251_251.251_paid_map)";

-- total original website members
"SELECT \"Total Original Website Members\" as dname,count(251_user_id) as uids FROM vt251_251.251_contact";


-- reports:
-- total members
"SELECT \"$name\" as dname, count(member_id) as uids FROM vt251_251.251_paid_members";

-- members by status
SELECT \"$name\" as dname, count(member_id) as uids 
FROM vt251_251.251_paid_members WHERE member_status ='$stat'

-- members by status & level
SELECT \"$name\" as dname, count(member_id) as uids 
FROM vt251_251.251_paid_members 
WHERE member_status ='$stat' and level = '$level'

-- members by status & last updated
SELECT \"$name\" as dname, count(member_id) as uids 
FROM vt251_251.251_paid_members 
WHERE member_status ='$stat' and last_update_dt > DATE_SUB(CURDATE(), INTERVAL $days DAY);

-- total website users members
SELECT \"Total Current Website Members\" as dname ,count(member_id) as uids 
FROM vt251_251.251_paid_members
WHERE member_id 
IN (SELECT member_id from vt251_251.251_paid_map)

-- total original users?
SELECT \"Total Original Website Members\" as dname,count(251_user_id) as uids 
FROM vt251_251.251_contact

-- total website users
SELECT u.251_user_id,u.251_user_name, u.first_name, u.last_name, c.city, c.state, c.signup_date
FROM 251_contact c, 251_user u
where c.251_user_id = u.251_user_id
order by c.signup_date desc

-- Members with extra users associated with them (dups)
SELECT 251_paid_members.*, COUNT(251_paid_map.member_id) AS 'num of web users'
FROM 251_paid_map
JOIN 251_paid_members on 251_paid_members.member_id = 251_paid_map.member_id
GROUP BY 251_paid_map.member_id
HAVING COUNT(251_paid_map.member_id)>1;

-- Total members with/without emails and with web users, including dups:
SELECT
	251_user.*,
    251_paid_members.member_id, 251_paid_members.member_status, 251_paid_members.email, 251_paid_members.level, 251_paid_members.secondary_member, 251_paid_members.addr_1, 251_paid_members.city, 251_paid_members.state, 251_paid_members.zip, 251_paid_members.home_nbr, 251_paid_members.email1,
	251_paid_members.last_update_dt, 251_paid_members.paid_thru, 251_paid_members.join_date

FROM
	251_user
    JOIN 251_paid_map on 251_paid_map.251_user_id = 251_user.251_user_id
	JOIN 251_paid_members on 251_paid_members.member_id = 251_paid_map.member_id;

-- Total members with/without emails and with web users, minus dups
SELECT
	251_user.*,
    251_paid_members.member_id, 251_paid_members.member_status, 251_paid_members.email, 251_paid_members.level, 251_paid_members.secondary_member, 251_paid_members.addr_1, 251_paid_members.city, 251_paid_members.state, 251_paid_members.zip, 251_paid_members.home_nbr, 251_paid_members.email1,
	251_paid_members.last_update_dt, 251_paid_members.paid_thru, 251_paid_members.join_date

FROM
	251_user
    JOIN 251_paid_map on 251_paid_map.251_user_id = 251_user.251_user_id
	JOIN 251_paid_members on 251_paid_members.member_id = 251_paid_map.member_id
    GROUP BY 251_paid_map.member_id
    HAVING COUNT(251_paid_map.member_id)=1;
-- Total members without emails and with web users, including dups
SELECT
	251_user.*,
    251_paid_members.member_id, 251_paid_members.member_status, 251_paid_members.email, 251_paid_members.level, 251_paid_members.secondary_member, 251_paid_members.addr_1, 251_paid_members.city, 251_paid_members.state, 251_paid_members.zip, 251_paid_members.home_nbr, 251_paid_members.email1,
	251_paid_members.last_update_dt, 251_paid_members.paid_thru, 251_paid_members.join_date

FROM
	251_user
    JOIN 251_paid_map on 251_paid_map.251_user_id = 251_user.251_user_id
	JOIN 251_paid_members on 251_paid_members.member_id = 251_paid_map.member_id
    WHERE email IS NULL;

-- get all members without web users
SELECT  *
FROM    251_paid_members
WHERE   member_id NOT IN
        (
        SELECT  member_id
        FROM    251_paid_map
        );

-- get all members without web users and without emails
SELECT  *
FROM    251_paid_members
WHERE   member_id NOT IN
        (
        SELECT  member_id
        FROM    251_paid_map
        )
AND email IS NULL;


select str_to_date(LoginDate,'%d.%m.%Y') as DateFormat from ConvertIntoDateFormat;
