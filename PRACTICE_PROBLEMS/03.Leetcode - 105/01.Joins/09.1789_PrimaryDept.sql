/*  1789. Primary Department for Each Employee

Table: Employee

+---------------+---------+
| Column Name   |  Type   |
+---------------+---------+
| employee_id   | int     |
| department_id | int     |
| primary_flag  | varchar |
+---------------+---------+


Employees can belong to multiple departments. When the employee joins other departments, 
they need to decide which department is their primary department. Note that when an employee 
belongs to only one department, their primary column is 'N'.

Write a solution to report all the employees with their primary department. For employees who 
belong to one department, report their only department.

Return the result table in any order.

The result format is in the following example.

: 
Employee table:
+-------------+---------------+--------------+
| employee_id | department_id | primary_flag |
+-------------+---------------+--------------+
| 1           | 1             | N            |
| 2           | 1             | Y            |
| 2           | 2             | N            |
| 3           | 3             | N            |
| 4           | 2             | N            |
| 4           | 3             | Y            |
| 4           | 4             | N            |
+-------------+---------------+--------------+

Output: 
+-------------+---------------+
| employee_id | department_id |
+-------------+---------------+
| 1           | 1             |
| 2           | 1             |
| 3           | 3             |
| 4           | 3             |
+-------------+---------------+

Explanation: 
- The Primary department for employee 1 is 1.
- The Primary department for employee 2 is 1.
- The Primary department for employee 3 is 3.
- The Primary department for employee 4 is 3.

When u need to join two different cases -> Use UNION || OR
*/


-- We can directly see from the output itself
-- If there is a single dept, return it
-- else return all those where we have Y
-- No joins needed here

-- WAY-1: Union --> We have to handle two separate cases here
SELECT employee_id AS employee_id, department_id AS department_id
FROM Employee
WHERE primary_flag = "Y"

UNION 

SELECT employee_id AS employee_id, department_id AS department_id
FROM Employee
GROUP BY employee_id
HAVING COUNT(*) = 1
ORDER BY employee_id;

-- WAY-2: We can use correlated subquery as well
-- Give me the row if its flag is Y, OR if this employee belongs to exactly one department.
SELECT e1.employee_id AS employee_id, e1.department_id AS department_id
FROM Employee AS e1
WHERE e1.primary_flag = "Y"
OR (
    SELECT COUNT(*)
    FROM Employee AS e2
    WHERE e1.employee_id = e2.employee_id
) = 1;