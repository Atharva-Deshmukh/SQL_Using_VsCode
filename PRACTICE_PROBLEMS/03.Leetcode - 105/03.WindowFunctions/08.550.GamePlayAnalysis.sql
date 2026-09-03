/* 550. Game Play Analysis IV

Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key (combination of columns with unique values) of this table.
This table shows the activity of players of some games.

Each row is a record of a player who logged in and played a number of games (possibly 0) 
before logging out on someday using some device.

Write a solution to report the fraction of players that logged in again on the day 
after the day they first logged in, rounded to 2 decimal places. In other words, 
you need to determine the number of players who logged in on the day immediately 
following their initial login, and divide it by the number of total players.

The result format is in the following example.

Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

Output: 
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+

Explanation: 
Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33

My Logic was correct, code was wrong, I was trying to use alias and window functions at same SELECT level, 
We need another subquery for this

LOGIC I THOUGHT:

id event_date   first_date   SUM(event_date = first_date + 1 DAY) OVER(ORDER BY event_date)
-------------------------------------------------------------------------------------------
1  2016-03-01   2016-03-01      1
   2016-03-02

2  2017-06-25   2017-06-25      0

3  2016-03-02   2016-03-02      0
   2018-07-03


   Fraction = SUM() / total players

*/


-- MY FIRST LOGIC
SELECT
    ROUND(
        CNT_PLAYERS / COUNT(DISTINCT player_id),
        2
    ) AS fraction
FROM (
    SELECT
        player_id,
        event_date,
        MAX(
            event_date = FIRST_VALUE(event_date) OVER (
                PARTITION BY player_id
                ORDER BY event_date
            ) + INTERVAL 1 DAY
        ) AS CNT_PLAYERS
    FROM Activity
) AS ALIAS_UNUSED;

-- CORRECT CODE

-- Alias cannot be referenced directly in the same level SELECT, hence created CTE separately

WITH first_dates AS (
    SELECT
        player_id,
        event_date,
        FIRST_VALUE(event_date) OVER (
            PARTITION BY player_id
            ORDER BY event_date
        ) AS first_date
    FROM Activity
),

next_day_table AS (  -- another CTE
    SELECT
        player_id,
        MAX(event_date = first_date + INTERVAL 1 DAY) AS returned_next_day
    FROM first_dates
    GROUP BY player_id
)

SELECT
    ROUND(
        SUM(returned_next_day) / COUNT(*),
        2
    ) AS fraction
FROM next_day_table;