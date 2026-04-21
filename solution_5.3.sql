CREATE TABLE IF NOT EXISTS user_events (
    user_id UInt32,
    event_type String,
    points UInt32,
    event_time DateTime
) ENGINE = MergeTree()
ORDER BY event_time
TTL event_time + INTERVAL 30 DAY;

CREATE TABLE IF NOT EXISTS user_events_agg (
    event_date Date,
    event_type String,
    unique_users AggregateFunction(uniq, UInt32),
    total_points AggregateFunction(sum, UInt32),
    total_actions AggregateFunction(count, UInt32)
) ENGINE = AggregatingMergeTree()
ORDER BY (event_date, event_type)
TTL event_date + INTERVAL 180 DAY;

CREATE MATERIALIZED VIEW IF NOT EXISTS user_events_mv
TO user_events_agg
AS
SELECT
    toDate(event_time) AS event_date,
    event_type,
    uniqState(user_id) AS unique_users,
    sumState(points) AS total_points,
    countState(user_id) AS total_actions
FROM user_events
GROUP BY event_date, event_type;

INSERT INTO user_events VALUES
(1, 'login', 0, now() - INTERVAL 10 DAY),
(2, 'signup', 0, now() - INTERVAL 10 DAY),
(3, 'login', 0, now() - INTERVAL 10 DAY),
(1, 'login', 0, now() - INTERVAL 7 DAY),
(2, 'login', 0, now() - INTERVAL 7 DAY),
(3, 'purchase', 30, now() - INTERVAL 7 DAY),
(1, 'purchase', 50, now() - INTERVAL 5 DAY),
(2, 'logout', 0, now() - INTERVAL 5 DAY),
(4, 'login', 0, now() - INTERVAL 5 DAY),
(1, 'login', 0, now() - INTERVAL 3 DAY),
(3, 'purchase', 70, now() - INTERVAL 3 DAY),
(5, 'signup', 0, now() - INTERVAL 3 DAY),
(2, 'purchase', 20, now() - INTERVAL 1 DAY),
(4, 'logout', 0, now() - INTERVAL 1 DAY),
(5, 'login', 0, now() - INTERVAL 1 DAY),
(1, 'purchase', 25, now()),
(2, 'login', 0, now()),
(3, 'logout', 0, now()),
(6, 'signup', 0, now()),
(6, 'purchase', 100, now());

SELECT
    event_date,
    event_type,
    uniqMerge(unique_users) AS unique_users,
    sumMerge(total_points) AS total_spent,
    countMerge(total_actions) AS total_actions
FROM user_events_agg
GROUP BY event_date, event_type
ORDER BY event_date DESC, event_type;

WITH first_visits AS (
    SELECT DISTINCT
        user_id,
        toDate(event_time) AS visit_date
    FROM user_events
),
user_first_date AS (
    SELECT
        user_id,
        min(visit_date) AS first_date
    FROM first_visits
    GROUP BY user_id
),
retention_data AS (
    SELECT
        ufd.first_date,
        COUNT(DISTINCT ufd.user_id) AS total_users_day_0,
        COUNT(DISTINCT CASE
            WHEN fv.visit_date BETWEEN ufd.first_date + 1 AND ufd.first_date + 7
            THEN ufd.user_id
        END) AS returned_in_7_days
    FROM user_first_date ufd
    LEFT JOIN first_visits fv ON ufd.user_id = fv.user_id
    GROUP BY ufd.first_date
)
SELECT
    first_date,
    total_users_day_0,
    returned_in_7_days,
    round(returned_in_7_days * 100.0 / total_users_day_0, 2) AS retention_7d_percent
FROM retention_data
ORDER BY first_date DESC;