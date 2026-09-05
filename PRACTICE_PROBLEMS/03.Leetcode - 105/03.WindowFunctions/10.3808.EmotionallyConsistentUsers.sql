/* 3808. Find Emotionally Consistent Users

Table: reactions

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| user_id      | int     |
| content_id   | int     |
| reaction     | varchar |
+--------------+---------+

(user_id, content_id) is the primary key (unique value) for this table.
Each row represents a reaction given by a user to a piece of content.

Write a solution to identify emotionally consistent users based on the following requirements:

For each user, count the total number of reactions they have given.
Only include users who have reacted to at least 5 different content items.
A user is considered emotionally consistent if at least 60% of their reactions are of the same type.
Return the result table ordered by reaction_ratio in descending order and then by user_id in ascending order.

Note:

reaction_ratio should be rounded to 2 decimal places
The result format is in the following example.

reactions table:

+---------+------------+----------+
| user_id | content_id | reaction |
+---------+------------+----------+
| 1       | 101        | like     |
| 1       | 102        | like     |
| 1       | 103        | like     |
| 1       | 104        | wow      |
| 1       | 105        | like     |
| 2       | 201        | like     |
| 2       | 202        | wow      |
| 2       | 203        | sad      |
| 2       | 204        | like     |
| 2       | 205        | wow      |
| 3       | 301        | love     |
| 3       | 302        | love     |
| 3       | 303        | love     |
| 3       | 304        | love     |
| 3       | 305        | love     |
+---------+------------+----------+

Output:

+---------+-------------------+----------------+
| user_id | dominant_reaction | reaction_ratio |
+---------+-------------------+----------------+
| 3       | love              | 1.00           |
| 1       | like              | 0.80           |
+---------+-------------------+----------------+

Explanation:

User 1:
Total reactions = 5
like appears 4 times
reaction_ratio = 4 / 5 = 0.80
Meets the 60% consistency requirement
User 2:
Total reactions = 5
Most frequent reaction appears only 2 times
reaction_ratio = 2 / 5 = 0.40
Does not meet the consistency requirement
User 3:
Total reactions = 5
'love' appears 5 times
reaction_ratio = 5 / 5 = 1.00
Meets the consistency requirement
The Results table is ordered by reaction_ratio in descending order, then by user_id in ascending order.

My first approach was hard-coded, hence wrong, and did not accounted for other possible reactions

Correct approach:

FIRST:
    GROUP BY user_id, reaction --> this way, for each user, we get user_id and reaction count

SECOND:
     Use ROW_NUMBER() to number the rows for each user as per count of reactions

*/

-- WRONG APPROACH
WITH calculationsTable AS (
    SELECT user_id,
           COUNT(*) AS noOfContentsReacted,
           SUM(CASE WHEN reaction='like' THEN 1 ELSE 0 END) AS likesCount,
           SUM(CASE WHEN reaction='wow' THEN 1 ELSE 0 END) AS wowsCount,
           SUM(CASE WHEN reaction='sad' THEN 1 ELSE 0 END) AS sadsCount,
           SUM(CASE WHEN reaction='love' THEN 1 ELSE 0 END) AS lovesCount
    FROM reactions
    GROUP BY user_id
),

emotionallyConsistentUsers AS (
    SELECT user_id, noOfContentsReacted, likesCount, wowsCount, sadsCount, lovesCount,
           CASE
               WHEN likesCount >= (0.6 * noOfContentsReacted) THEN 'like'
               WHEN wowsCount >= (0.6 * noOfContentsReacted) THEN 'wow'
               WHEN sadsCount >= (0.6 * noOfContentsReacted) THEN 'sad'
               WHEN lovesCount >= (0.6 * noOfContentsReacted) THEN 'love'
               ELSE ''  -- When no reaction crosses 60% mark
           END AS dominant_reaction,
           CASE
               WHEN likesCount >= (0.6 * noOfContentsReacted) THEN likesCount
               WHEN wowsCount >= (0.6 * noOfContentsReacted) THEN wowsCount
               WHEN sadsCount >= (0.6 * noOfContentsReacted) THEN sadsCount
               WHEN lovesCount >= (0.6 * noOfContentsReacted) THEN lovesCount
               ELSE 0 -- When no reaction crosses 60% mark
           END AS dominant_reaction_count
    FROM calculationsTable
    WHERE noOfContentsReacted >= 5
)

SELECT user_id, 
       dominant_reaction,
       ROUND(dominant_reaction_count / noOfContentsReacted, 2) AS reaction_ratio
FROM emotionallyConsistentUsers
WHERE dominant_reaction = 'like'
   OR dominant_reaction = 'wow'
   OR dominant_reaction = 'sad'
   OR dominant_reaction = 'love'
ORDER BY ROUND(dominant_reaction_count / noOfContentsReacted, 2) DESC, user_id;

-- CORRECT APPROACH
WITH reactionCountPerUser AS (
    SELECT user_id,
           reaction,
           COUNT(*) AS reactionCount
    FROM reactions
    GROUP BY user_id, reaction
),

rankedReactionWiseCount AS (
    SELECT user_id,
           reaction,
           reactionCount,
           ROW_NUMBER() OVER (
              PARTITION BY user_id
              ORDER BY reactionCount DESC
           ) AS rnk,
           SUM(reactionCount) OVER (
            PARTITION BY user_id
           ) AS noOfContentsReacted
    FROM reactionCountPerUser
)

SELECT user_id, 
       reaction AS dominant_reaction,
       ROUND(reactionCount / noOfContentsReacted, 2) AS reaction_ratio
FROM rankedReactionWiseCount
WHERE rnk = 1 
  AND noOfContentsReacted >= 5
  AND ROUND(reactionCount / noOfContentsReacted, 2) >= 0.6
ORDER BY ROUND(reactionCount / noOfContentsReacted, 2) DESC, user_id;

