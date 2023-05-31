--CREATE TABLES AND LOAD DATAS
CREATE TABLE read 
(
  read_date   DATE,
  read_time   TIME,
  event       TEXT,
  country     TEXT,
  user_id     BIGINT NOT NULL,
  source      TEXT,
  topic       TEXT
);

COPY read
FROM '/*****/read.csv' DELIMITER ';';

SELECT *
FROM read
LIMIT 200;

CREATE TABLE subscribe 
(
  subs_date   DATE,
  subs_time   TIME,
  event       TEXT,
  user_id     BIGINT NOT NULL
);

COPY subscribe
FROM '/*****/subscribe.csv' DELIMITER ';';

SELECT *
FROM subscribe
LIMIT 200;

CREATE TABLE buy 
(
  buy_date   DATE,
  buy_time   TIME,
  event      TEXT,
  user_id    BIGINT NOT NULL,
  price      INT
);

COPY buy
FROM '/*****/buy.csv' DELIMITER ';';

SELECT *
FROM buy
LIMIT 200;

--EXPLORE DATA, CHECK DATA LOAD
--READINGS
SELECT COUNT(*)
FROM read;

--FIRST READ USER - 210000user
SELECT COUNT(user_id) AS num_1st_read_user
FROM read
WHERE source != '';

--RETURNING USER - 66000user
SELECT COUNT(DISTINCT user_id) AS returning_user
FROM read
WHERE source = '';

--TOP COUNTRY - 5,7,2
SELECT country,
       COUNT(*) AS num_users
FROM read
GROUP BY country
ORDER BY num_users DESC;

--TOP SOURCE - Red, AW, SEO
SELECT source,
       COUNT(*) AS num_users
FROM read
WHERE source != ''
GROUP BY source
ORDER BY num_users DESC;

--TOP TOPIC - Asia, NAmerica, Europe
SELECT topic,
       COUNT(*) AS num_users
FROM read
GROUP BY topic
ORDER BY num_users DESC;

--SUBSRCIBED USER - 7600user
SELECT COUNT(user_id) AS subs_users
FROM subscribe;

SELECT subs_date,
       COUNT(*) AS subs_users
FROM subscribe
GROUP BY subs_date
ORDER BY subs_date;

--REVENUE EBOOK = $53120
SELECT SUM(price)
FROM buy
WHERE price = 8;

--REVENUE VIDEO_COURSE = $141360
SELECT SUM(price)
FROM buy
WHERE price = 80;

SELECT buy_date,
       COUNT(*) AS num_purch
FROM buy
WHERE price = 80
GROUP BY buy_date
ORDER BY buy_date;

--TREND CHARTS
--FIRST_READ
SELECT read_date,
       COUNT(user_id) AS num_1st_read_user
FROM read
WHERE source != ''
GROUP BY read_date
ORDER BY read_date;

--RETURNING
SELECT read_date,
       COUNT(user_id) AS num_retention_user
FROM read
WHERE source = ''
GROUP BY read_date
ORDER BY read_date;

--SUBSCRIPTION
SELECT subs_date,
       COUNT(user_id) AS num_subs_user
FROM subscribe
GROUP BY subs_date
ORDER BY subs_date;

--EBOOK PURCHASE
SELECT buy_date,
       COUNT(*) AS num_ebook_purch
FROM buy
WHERE price = 8
GROUP BY buy_date
ORDER BY buy_date;

--VIDEO COURSE PURCHASE
SELECT buy_date,
       COUNT(*) AS num_video_course_purch
FROM buy
WHERE price = 80
GROUP BY buy_date
ORDER BY buy_date;

--DISTRIBUTION FOR SUBSCRIBERS
SELECT subs_date,
       read.user_id,
       country,
       source,
       topic
FROM read
  JOIN subscribe ON read.user_id = subscribe.user_id
WHERE source != ''
ORDER BY read_date;

--DISTRIBUTION FOR EBOOK PURCHASES
SELECT buy_date,
       read.user_id,
       country,
       source,
       topic
FROM read
  JOIN buy ON read.user_id = buy.user_id
WHERE read.source != ''
AND   buy.price = 8
ORDER BY read_date;

--DISTRIBUTION FOR VIDEO COURSE PURCHASES
SELECT buy_date,
       read.user_id,
       country,
       source,
       topic
FROM read
  JOIN buy ON read.user_id = buy.user_id
WHERE read.source != ''
AND   buy.price = 80
ORDER BY read_date;

--ALL SEGMENTS - FIRST READ USERS
SELECT country,
       topic,
       source,
       COUNT(*) AS num_users
FROM read
WHERE source != ''
GROUP BY country,
         topic,
         source
ORDER BY num_users DESC;

--ALL SEGMENTS - RETURNING USERS
SELECT country,
       topic,
       source,
       COUNT(*) AS num_users
FROM read
WHERE source = ''
GROUP BY country,
         topic,
         source
ORDER BY num_users DESC;

--ALL SEGMENTS - SUBSCRIBERS
SELECT country,
       source,
       topic,
       COUNT(*) AS num_users
FROM read
  JOIN subscribe ON read.user_id = subscribe.user_id
WHERE source != ''
GROUP BY country,
         source,
         topic
ORDER BY num_users DESC;

--ALL SEGMENTS - EBOOK BUYERS
SELECT country,
       source,
       topic,
       COUNT(*) AS num_users
FROM read
  JOIN buy ON read.user_id = buy.user_id
WHERE source != ''
AND   buy.price = 8
GROUP BY country,
         source,
         topic
ORDER BY num_users DESC;

--ALL SEGMENTS - VIDEO COURSE BUYERS
SELECT country,
       source,
       topic,
       COUNT(*) AS num_users
FROM read
  JOIN buy ON read.user_id = buy.user_id
WHERE source != ''
AND   buy.price = 80
GROUP BY country,
         source,
         topic
ORDER BY num_users DESC;

--ALL SEGMENTS - PURCHASES
SELECT country,
       source,
       topic,
       SUM(price) AS total_revenue
FROM read
JOIN buy ON read.user_id = buy.user_id
WHERE source != ''
GROUP BY country,
         source,
         topic
ORDER BY total_revenue DESC;

SELECT country,
       SUM(price) AS rev_by_loc
FROM read
JOIN buy ON read.user_id = buy.user_id
WHERE source != ''
GROUP BY country
ORDER BY rev_by_loc DESC;


--REVENUE / BUYERS / LOCATION
SELECT q1.country, q1.total_rev, q2.num_cust,
       q1.total_rev / q2.num_cust as avg_rev_cust
FROM (SELECT country, SUM(price) AS total_rev
      FROM read
      JOIN buy ON read.user_id = buy.user_id
      WHERE source != ''
      GROUP BY country
      ORDER BY total_rev DESC) as q1
JOIN (SELECT country, COUNT(*) AS num_cust
      FROM read
      JOIN buy ON read.user_id = buy.user_id
      WHERE source != ''
      GROUP BY country
      ORDER BY num_cust DESC) as q2
ON q1.country = q2.country
ORDER BY avg_rev_cust DESC;

--REVENUE / READERS / LOCATION 
SELECT first_query.country, first_query.num_readers, first_query.total_rev,
       CAST(total_rev AS FLOAT) / num_readers as avg_rev_readers
FROM (SELECT read.country, COUNT(DISTINCT user_id) as num_readers, total_rev.total_rev
      FROM read
      JOIN (SELECT read.country, SUM(buy.price) as total_rev
            FROM buy
            JOIN read
            ON buy.user_id = read.user_id
            WHERE source != ''
            GROUP BY read.country) as total_rev
      ON read.country = total_rev.country
      GROUP BY read.country, total_rev.total_rev) as first_query
ORDER BY avg_rev_readers DESC;


--FUNNEL ANALYSIS
SELECT read_date,
       country,
       source,
       COUNT(user_id) AS new_readers,
       COUNT(CASE WHEN user_id IN (SELECT DISTINCT (user_id) FROM read WHERE source = '') THEN user_id END) AS returning_readers,
       COUNT(CASE WHEN user_id IN (SELECT DISTINCT (user_id) FROM subscribe) THEN user_id END) AS subscribers,
       COUNT(CASE WHEN user_id IN (SELECT DISTINCT (user_id) FROM buy) THEN user_id END) buyers
FROM read
WHERE source != ''
GROUP BY read_date,
         country,
         source
ORDER BY read_date,
         country,
         source 
LIMIT 100;
