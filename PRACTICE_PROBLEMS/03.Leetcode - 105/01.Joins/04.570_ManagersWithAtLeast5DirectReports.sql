/* 570. Managers with at Least 5 Direct Reports

Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+

id is the primary key (column with unique values) for this table.
Each row of this table indicates the name of an employee, their department,
 and the id of their manager.
If managerId is null, then the employee does not have a manager.
No employee will be the manager of themself.
 

Write a solution to find managers with at least five direct reports.
Return the result table in any order.
The result format is in the following example.

Input: 

    Employee table:
    +-----+-------+------------+-----------+
    | id  | name  | department | managerId |
    +-----+-------+------------+-----------+
    | 101 | John  | A          | null      |
    | 102 | Dan   | A          | 101       |
    | 103 | James | A          | 101       |
    | 104 | Amy   | A          | 101       |
    | 105 | Anne  | A          | 101       |
    | 106 | Ron   | B          | 101       |
    +-----+-------+------------+-----------+

Output: 
    +------+
    | name |
    +------+
    | John |
    +------+


*/

SELECT m.name AS name
FROM Employee AS m
INNER JOIN Employee AS e
    ON e.managerId = m.id
GROUP BY m.id   --  Manager name can be duplicate, if grouped by name, we may get 10 at once, instead of 5 + 5
HAVING COUNT(*) >= 5;