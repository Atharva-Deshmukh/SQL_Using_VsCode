/*
CTE (Common Table Expression)
-----------------------------

✔ Temporary named result set (exists only for one query).
✔ Improves readability by replacing complex subqueries.
✔ Can be referenced multiple times within the same query.
✔ Think of it as an alias for a SELECT query RESULT as a whole (not just a table/column).

*/

Syntax:
    WITH cte_name AS (
        SELECT ...
    )
    SELECT * FROM cte_name;

-------------------- Basic Example --------------------

-- Employees earning above department average

WITH avg_salary AS (
    SELECT department, AVG(salary) AS avg_sal
    FROM Employees
    GROUP BY department
)
SELECT e.name, e.salary
FROM Employees e
JOIN avg_salary a
ON e.department = a.department
WHERE e.salary > a.avg_sal;

-------------------- Why use CTE? --------------------

✔ Better readability
✔ Avoids repeating subqueries
✔ Can chain multiple CTEs
✔ Supports recursion

-------------------- CTE vs Subquery --------------------

CTE
✔ Reusable within the same query
✔ Supports recursion

Subquery
✔ Used once
✔ Cannot be recursive

-------------------- Recursive CTE --------------------

Used for:
✔ Employee hierarchy
✔ Parent-child relationships
✔ Tree structures
✔ Number generation

Structure:
1. Anchor query
2. Recursive query (references itself)

Example:

WITH RECURSIVE numbers AS (
    SELECT 1 AS num
    UNION ALL
    SELECT num + 1
    FROM numbers
    WHERE num < 5
)
SELECT * FROM numbers;

Output:
1
2
3
4
5

-------------------- Interview Notes --------------------

✔ CTE exists only for the current query.
✔ Recursive CTE = Anchor + Recursive member.
✔ Recursive query must have a stopping condition.

-------------------- CTE vs Stored Procedure --------------------

CTE
✔ Temporary
✔ No parameters

Stored Procedure
✔ Permanent DB object
✔ Accepts parameters

-------------------- SDET-2 FAQs --------------------

Q. Why use CTE over subquery?
→ Better readability, reusable in same query, supports recursion.

Q. Can CTE be reused in another query?
→ No.

Q. Can CTE be used with UPDATE/DELETE?
→ Yes (DB dependent).

Remember:
CTE            → Named temporary query result
Recursive CTE  → Hierarchy/tree problems
*/