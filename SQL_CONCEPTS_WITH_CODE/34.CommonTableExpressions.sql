/* 
                                                What is a CTE?
                                                --------------

A CTE is like a temporary named result set that exists just for the duration of a single query.

Syntax:
WITH cte_name AS (
  SELECT ...
)
SELECT * FROM cte_name;


You can think of it as giving a name to a subquery for clarity and reuse.

Basic Example – Non-recursive CTE

Imagine you have an employees table:

+----+----------+------------+--------+
| id | name     | department | salary |
+----+----------+------------+--------+
| 1  | Alice    | HR         | 50000  |
| 2  | Bob      | Engineering| 70000  |
| 3  | Charlie  | HR         | 60000  |
+----+----------+------------+--------+

🔍 Use Case: Get average salary by department, and list employees earning more than their department average
WITH avg_salary AS (
  SELECT department, AVG(salary) AS avg_sal
  FROM employees
  GROUP BY department
)
SELECT e.name, e.salary, e.department, a.avg_sal
FROM employees e
JOIN avg_salary a ON e.department = a.department
WHERE e.salary > a.avg_sal;


✔️ avg_salary is a CTE here. It calculates department-wise averages, and we use that in the final query.


| Feature           | CTE                                      | Stored Procedure                         |
|-------------------|------------------------------------------|------------------------------------------|
| Purpose           | Used for simplifying queries or recursion | Used to encapsulate logic for reuse       |
| Lifespan          | Temporary – only for the duration of the query | Persistent – saved in the database    |
| Reusability       | ❌ No                                    | ✅ Yes                                   |
| Can accept params | ❌ No                                    | ✅ Yes                                   |
| Control Flow      | ❌ Not supported                         | ✅ IF, WHILE, LOOP supported              |
| Use Case          | Readability, recursion                   | Complex logic, multi-step transactions    |


                                        What is a Recursive CTE?
                                        ------------------------

A recursive CTE is used when you need to repeat a query multiple times with changing input, 
especially for hierarchical or sequential data (like counting, trees, graphs, etc.).

It works in two parts:

- Anchor part – the starting row(s)
- Recursive part – refers to the CTE itself to generate more rows

Ex: Lets generate numbers from 1 to 5

WITH RECURSIVE numbers_cte AS (
    -- 1️⃣ Anchor member: start with 1
    SELECT 1 AS num

    UNION ALL

    -- 2️⃣ Recursive member: keep adding 1
    SELECT num + 1
    FROM numbers_cte
    WHERE num < 5
)

-- Final SELECT
SELECT * FROM numbers_cte;

For an example on recursive CTE -> We need a table with some hierarchy

+----+---------+-------------+--------+------------+
| id | name    | department  | salary | manager_id |
+----+---------+-------------+--------+------------+
| 1  | Alice   | HR          | 50000  | NULL       |
| 2  | Bob     | Engineering | 70000  | 1          |
| 3  | Charlie | HR          | 60000  | 2          |
| 4  | David   | Engineering | 40000  | 2          |
| 5  | Eve     | HR          | 30000  | 3          |
+----+---------+-------------+--------+------------+

List all employees under Alice, including levels (how far they are from Alice).

✅ Recursive CTE Example:
WITH RECURSIVE emp_hierarchy AS (
    -- 1️⃣ Anchor: Start with Alice (top-level)
    SELECT id, name, manager_id, 0 AS level
    FROM employees
    WHERE name = 'Alice'

    UNION ALL

    -- 2️⃣ Recursive part: find subordinates
    SELECT e.id, e.name, e.manager_id, eh.level + 1
    FROM employees e
    JOIN emp_hierarchy eh ON e.manager_id = eh.id
)

SELECT * FROM emp_hierarchy;

How it works:

The anchor query picks Alice.
The recursive query finds employees who report to someone already in the result.
It repeats until there are no more subordinates.




*/