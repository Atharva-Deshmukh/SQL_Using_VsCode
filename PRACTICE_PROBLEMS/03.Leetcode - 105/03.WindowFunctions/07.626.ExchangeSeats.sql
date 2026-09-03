/* 626. Exchange Seats

Table: Seat

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| student     | varchar |
+-------------+---------+
id is the primary key (unique value) column for this table.
Each row of this table indicates the name and the ID of a student.
The ID sequence always starts from 1 and increments continuously.
 

Write a solution to swap the seat id of every two consecutive students. 
If the number of students is odd, the id of the last student is not swapped.

Return the result table ordered by id in ascending order.

The result format is in the following example.
 
Seat table:
+----+---------+
| id | student |
+----+---------+
| 1  | Abbot   |
| 2  | Doris   |
| 3  | Emerson |
| 4  | Green   |
| 5  | Jeames  |
+----+---------+

Output: 
+----+---------+
| id | student |
+----+---------+
| 1  | Doris   |
| 2  | Abbot   |
| 3  | Green   |
| 4  | Emerson |
| 5  | Jeames  |
+----+---------+

Explanation: 
Note that if the number of students is odd, there is no need to change the last one's seat.

I COULD NOT THINK OF THE LOGIC ITSELF!

My Thinking:    
    - How would I swap the values in SQL
    - How would I detect the even odd number of students

LOGIC:
    Observe pattern

    id = 1 = odd  --> 2 (id + 1)
    id = 2 = even --> 1 (id - 1)
    id = 3 = odd  --> 4 (id + 1)
    id = 4 = even --> 3 (id - 1)
    id = 5 = odd  AND its last id --> hence do nothing

    How to know if id is last?
    We know that: The ID sequence always starts from 1 and increments continuously.

    hence if currentId === ODD AND currentId === MAX(ids) --> its last and odd so should not be changed4

    To get MAX id of the row, use select query, not MAX(id) directly
*/

SELECT 
    CASE
        WHEN id = (SELECT MAX(id) FROM Seat) AND id % 2 = 1 THEN id
        WHEN id % 2 = 1 THEN id + 1
        WHEN id % 2 = 0 THEN id - 1
    END AS id,
    student AS student
FROM Seat
ORDER BY id;