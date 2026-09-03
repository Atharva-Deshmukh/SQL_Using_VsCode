/* 602. Friend Requests II: Who Has the Most Friends

Table: RequestAccepted

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| requester_id   | int     |
| accepter_id    | int     |
| accept_date    | date    |
+----------------+---------+
(requester_id, accepter_id) is the primary key (combination of columns with unique values) for this table.
This table contains the ID of the user who sent the request, the ID of the user who received the request, 
and the date when the request was accepted.
 

Write a solution to find the people who have the most friends and the most friends number.
The test cases are generated so that only one person has the most friends.
The result format is in the following example.

RequestAccepted table:
+--------------+-------------+-------------+
| requester_id | accepter_id | accept_date |
+--------------+-------------+-------------+
| 1            | 2           | 2016/06/03  |
| 1            | 3           | 2016/06/08  |
| 2            | 3           | 2016/06/08  |
| 3            | 4           | 2016/06/09  |
+--------------+-------------+-------------+

Output: 
+----+-----+
| id | num |
+----+-----+
| 3  | 3   |
+----+-----+

Explanation: 
The person with id 3 is a friend of people 1, 2, and 4, so he has three friends in total, which is the most number than any others.

Follow up: In the real world, multiple people could have the same most number of friends. 
Could you find all these people in this case?

I was stuck at the logic itself!

Logic:

Friendship = two way relationship

Ex: 

1 -> 2
1 -> 3
2 -> 3
3 -> 4

1 -> 2, 3
2 -> 1, 3
3 -> 1, 2, 4
4 -> 3

So, we need to count both cols, requester_id and accepter_id

My Earlier thought: How can I self join table so that I can count both cols of relations

Actual solution: Bring both columns one below another and then group by --> count

*/

-- Combine tables
WITH combinedRelationshipTable AS (
    SELECT requester_id AS id
    FROM RequestAccepted

    UNION ALL -- Keep duplicates because each row represents a friendship

    SELECT accepter_id AS id
    FROM RequestAccepted
),

-- Count friendships for each person and rank them
tableWithFriendshipCounts AS (
    SELECT
        id,
        COUNT(*) AS num,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk -- I was stuck here as I thought how could count be used inside window function
    FROM combinedRelationshipTable
    GROUP BY id
)

-- Get all people with the most friends
SELECT
    id,
    num
FROM tableWithFriendshipCounts
WHERE rnk = 1;