/* 180. Consecutive Numbers

Table: Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
In SQL, id is the primary key for this table.
id is an autoincrement column starting from 1.
 

Find all numbers that appear at least three times consecutively.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Output: 
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
Explanation: 1 is the only number that appears consecutively for at least three times.


Although I had Idea of LEAD() and LAG(), I could not form logic

Logic, a number to be atleast 3 times consqutive, n = (n - 1)th row AND n = (n - 2)th row
*/

SELECT DISTINCT num AS ConsecutiveNums
FROM(
    SELECT id, num,
           LAG(num, 1) OVER() AS prev1,
           LAG(num, 2) OVER() AS prev2
    FROM Logs
) AS UNUSED_ALIAS
WHERE num = prev1 AND num = prev2;