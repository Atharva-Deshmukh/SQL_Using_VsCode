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

2. Rank employees by salary within each department.

3. Find the highest-paid employee in each department.

4. Find the second-highest salary in each department.

5. Find the top 3 employees in each department.

6. Demonstrate ROW_NUMBER vs RANK vs DENSE_RANK.


PROBLEMS — LAG / LEAD
---------------------

7. Display each employee's sale and previous sale amount.

8. Compare each employee's current sale with previous sale.

9. Find sales where current amount > previous amount.


PROBLEMS — WINDOW AGGREGATES
----------------------------

10. Calculate running salary total ordered by employee_id.

11. Display every employee with total salary of their department.

12. Display every employee with average salary of their department.
