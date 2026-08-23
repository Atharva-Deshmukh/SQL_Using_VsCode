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

PROBLEMS
--------

1. Find employees hired after 2020-01-01.

    SELECT name, employee_id
    FROM Employee
    WHERE hire_date > '2020-01-01';

2. Find employees hired between 2020-01-01 and 2024-12-31.

    SELECT name, employee_id
    FROM Employee
    WHERE hire_date BETWEEN '2020-01-01' AND '2024-12-31';

3. Find employees hired in 2022.   --- REVISE

    SELECT name, employee_id
    FROM Employee
    WHERE hire_date >= '2022-01-01' AND hire_date < '2023-01-01';

4. Extract year, month and day from hire_date.   ---   REVISE

    SELECT name, employee_id, 
    YEAR(hire_date) AS year,
    MONTH(hire_date) AS month,
    DAY(hire_date) AS day
    FROM Employee;

    Output:
    +-------+-------------+------+-------+------+
    | name  | employee_id | year | month | day  |
    +-------+-------------+------+-------+------+
    | John  |           1 | 2018 |     3 |   15 |
    | Alice |           2 | 2021 |     6 |   10 |
    | Bob   |           3 | 2022 |     1 |   20 |
    | Carol |           4 | 2025 |     2 |    5 |
    | David |           5 | 2016 |     9 |   12 |
    +-------+-------------+------+-------+------+

5. Find employees who joined in the current month.   -- REVISE

    SELECT *
    FROM Employee
    WHERE MONTH(hire_date) = MONTH(CURDATE())
        AND YEAR(hire_date) = YEAR(CURDATE());

6. Calculate employee tenure.     --   REVISE

   Way-1: Raw year difference
   Way-2: Built in MySQL specific function
            TIMESTAMPDIFF(unit, start_date, end_date)
            unit = YEAR, DAY, MONTH, HOUR, MINUTE, SECOND

    SELECT name, employee_id, hire_date, 
    TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS tenure
    FROM Employee;

7. Find orders placed in the last 7 days.

    SELECT * FROM Orders
    WHERE TIMESTAMPDIFF(DAY, order_date, CURDATE()) BETWEEN 0 AND 7;

8. Find total sales for each month.   --     REVISE

    SELECT YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        SUM(amount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(sale_date), MONTH(sale_date);

9. Find number of orders per day. -- REVISE

    SELECT order_date, COUNT(*) AS NO_OF_ORDERS
    FROM Orders 
    GROUP BY order_date;

10. Find the month with highest total sales.  -- REVISE

    SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(amount) AS total_sales
    FROM Orders
    GROUP BY YEAR(order_date), MONTH(order_date)
    ORDER BY total_sales DESC
    LIMIT 1;