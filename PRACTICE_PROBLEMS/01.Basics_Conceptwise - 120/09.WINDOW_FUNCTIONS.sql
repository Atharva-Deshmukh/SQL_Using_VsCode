Employee

   | employee_id | name  | age | department_id | manager_id | salary | experience_years | status | hire_date  |
   |-------------|-------|-----|---------------|------------|--------|------------------|--------|------------|
   | 1           | John  | 35  | 10            | NULL       | 90000  | 8                | A      | 2018-03-15 |
   | 2           | Alice | 29  | 10            | 1          | 70000  | 4                | A      | 2021-06-10 |
   | 3           | Bob   | 31  | 20            | 5          | 60000  | 3                | I      | 2022-01-20 |
   | 4           | Carol | 24  | NULL          | 1          | 50000  | 1                | A      | 2025-02-05 |
   | 5           | David | 40  | 20            | NULL       | 80000  | 10               | A      | 2016-09-12 |

Department

   | department_id | department_name | location_id |
   |---------------|-----------------|-------------|
   | 10            | Engineering     | 100         |
   | 20            | QA              | 200         |
   | 30            | HR              | 300         |
   | 40            | Finance         | 400         |

Location

   | location_id | location_name | city    | country |
   |-------------|---------------|-------------------|
   | 100         | Tech Park     | Bangalore | India |
   | 200         | Tech Hub      | Pune      | India |
   | 300         | HQ            | Mumbai    | India |
   | 400         | Finance HQ    | Delhi     | India |

Customer

| customer_id | name  | city |
|-------------|-------|------|
| 101         | Amit  | Pune |
| 102         | Neha  | Delhi |
| 103         | Ravi  | Mumbai |
| 104         | Sara  | Pune |

Orders

| order_id | customer_id | order_date | amount |
|----------|-------------|------------|--------|
| 1        | 101         | 2026-08-01 | 500    |
| 2        | 101         | 2026-08-05 | 800    |
| 3        | 103         | 2026-08-07 | 300    |
| 4        | 104         | 2026-08-09 | 900    |


Sales

| sale_id | employee_id | sale_date  | amount |
|---------|-------------|------------|--------|
| 1       | 1           | 2026-08-01 | 500    |
| 2       | 1           | 2026-08-02 | 700    |
| 3       | 2           | 2026-08-03 | 400    |
| 4       | 2           | 2026-08-04 | 600    |
| 5       | 1           | 2026-08-05 | 900    |


PROBLEMS — RANKING
------------------

1. Rank all employees by salary.

       Thought process: I need unique ranks for different salaries and 
                    if salaries tie, then I need same ranks, 
                    No gaps should be there for subsequent salaries
                    Hence DENSE_RANK()

        SELECT name, salary,
        DENSE_RANK() OVER (
            ORDER BY salary DESC
        ) AS rnk
        FROM Employee;

2. Rank employees by salary within each department.

    SELECT name, department_id, salary,
    DENSE_RANK() OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS rnk
    FROM Employee
    WHERE department_id IS NOT NULL;   -- To Exclude Carol

3. Find the highest-paid employee in each department.   --  REVISE

    SELECT name, department_id, salary
    FROM (                                  -- Pass entire SELECT query inside FROM(), not just the window function
    SELECT name, department_id, salary,
    DENSE_RANK() OVER(
        PARTITION BY department_id
        ORDER BY salary DESC
    )  AS rnk
    FROM Employee                        -- We have FROM inside FROM
    ) AS ALIAS_NOT_USED_ANYWHERE
    WHERE rnk = 1 AND department_id IS NOT NULL;

4. Find the second-highest salary in each department.

    SELECT name, department_id, salary
    FROM (
    SELECT name, department_id, salary,
        DENSE_RANK() OVER (
            PARTITION BY department_id
            ORDER BY salary DESC
        ) AS rnk 
        FROM Employee
        WHERE department_id IS NOT NULL
    ) AS ALIAS_NOT_USED_ANYWHERE
    WHERE rnk = 2;

5. Find the top 3 employees in each department.

    SELECT name, department_id, salary, rnk  --> We now also added rnk
    FROM (
    SELECT name, department_id, salary,
        DENSE_RANK() OVER(
            PARTITION BY department_id
            ORDER BY salary DESC
        ) AS rnk 
    FROM Employee
    WHERE department_id IS NOT NULL
    ) AS ALIAS_USED_NOWHERE
    WHERE rnk <= 3;

    Output:
    +-------+---------------+--------+-----+
    | name  | department_id | salary | rnk |
    +-------+---------------+--------+-----+
    | John  |            10 |  90000 |   1 |
    | Alice |            10 |  70000 |   2 |
    | David |            20 |  80000 |   1 |
    | Bob   |            20 |  60000 |   2 |
    +-------+---------------+--------+-----+

6. Demonstrate ROW_NUMBER vs RANK vs DENSE_RANK.  -- Read theory, no need to solve


PROBLEMS — LAG / LEAD
---------------------

7. Display each employees sale and previous sale amount.

    SELECT employee_id, amount AS CurrentSale, 
    LAG(amount, 1, 0) OVER (
        PARTITION BY employee_id
        ORDER BY sale_date         -->  ORDER BY DATES NOW
    ) AS PreviousSale
    FROM Sales;

8. Compare each employees current sale with previous sale.  -- REVISE OPTIMISATION

    SELECT employee_id, amount AS CurrentSale, 
    LAG(amount, 1, 0) OVER (
        PARTITION BY employee_id
        ORDER BY sale_date
    ) AS PreviousSale,

    amount - 
    LAG(amount, 1, 0) OVER(
        PARTITION BY employee_id
        ORDER BY sale_date
    ) AS difference
    FROM Sales;

    -- Optimise using subquery

    SELECT employee_id, amount AS CurrentSale, PreviousSale, amount - PreviousSale AS difference
    FROM (
    SELECT employee_id, amount, 
        LAG(amount, 1, 0) OVER (
            PARTITION BY employee_id
            ORDER BY sale_date
        ) AS PreviousSale
    FROM Sales
    ) AS ALIAS_NOWHERE_USED;

    Output:
    +-------------+-------------+--------------+------------+
    | employee_id | CurrentSale | PreviousSale | difference |
    +-------------+-------------+--------------+------------+
    |           1 |         500 |            0 |        500 |
    |           1 |         700 |          500 |        200 |
    |           1 |         900 |          700 |        200 |
    |           2 |         400 |            0 |        400 |
    |           2 |         600 |          400 |        200 |
    +-------------+-------------+--------------+------------+

9. Find sales where current amount > previous amount.   --   REVISE

    SELECT sale_id, amount
    FROM (
    SELECT sale_id, amount,             --   WE NEED SUBQUERY to compare with another column alias
        LAG(amount, 1, 0) OVER (
            ORDER BY sale_date
        ) AS PreviousAmt
    FROM Sales
    ) AS NON_USED_ALIAS
    WHERE amount > PreviousAmt;


PROBLEMS — WINDOW AGGREGATES
----------------------------

10. Calculate running salary total ordered by employee_id.

    SELECT name, employee_id, salary, 
    SUM(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW -- Don't need it actually
    ) AS RunningTotal
    FROM Employee;

11. Display every employee with total salary of their department.

    SELECT name, department_id, 
    SUM(salary) OVER (
        PARTITION BY department_id
    ) AS DeptTotalSal
    FROM Employee;

12. Display every employee with average salary of their department.

    SELECT name, department_id, 
    AVG(salary) OVER (
        PARTITION BY department_id
    ) AS DeptAvg
    FROM Employee;
