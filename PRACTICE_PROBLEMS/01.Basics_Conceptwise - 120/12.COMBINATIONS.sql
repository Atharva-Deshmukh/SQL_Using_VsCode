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

1. Find number of employees in each department.  -- REVISE the group by rule

    SELECT e.department_id, d.department_name, COUNT(*) AS EmpCount
    FROM Employee AS e 
    INNER JOIN Department AS d                -- To exclude NULL
    ON e.department_id = d.department_id
    GROUP BY e.department_id, d.department_name;  -- RULE: Every selected column must be either in group by or inside an aggregate

    Output:
    +---------------+-----------------+----------+
    | department_id | department_name | EmpCount |
    +---------------+-----------------+----------+
    |            10 | Engineering     |        2 |
    |            20 | QA              |        2 |
    +---------------+-----------------+----------+

2. Find average salary of each department.

    SELECT d.department_name, AVG(salary) AS AvgSal
    FROM Employee AS e 
    INNER JOIN Department AS d 
    ON e.department_id = d.department_id
    GROUP BY d.department_name;       -- RULE: every selected column must be either included in group by or used inside aggregate function

    Output:
    +-----------------+------------+
    | department_name | AvgSal     |
    +-----------------+------------+
    | Engineering     | 80000.0000 |
    | QA              | 70000.0000 |
    +-----------------+------------+

3. Find department with highest average salary.

   SELECT d.department_name, AVG(salary) AS AvgSal
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id
   GROUP BY d.department_id, d.department_name       -- RULE: every selected column must be either included in group by or used inside aggregate function
   ORDER BY AVG(salary) DESC LIMIT 1;

4. Count High / Medium / Low salary employees per department.   ---   REVISE, NEW WAY TO CODE
  
   SELECT d.department_name, 
      SUM(CASE WHEN e.salary > 80000 THEN 1 ELSE 0 END) AS HighSalary,
      SUM(CASE WHEN e.salary >= 60000 AND e.salary < 80000 THEN 1 ELSE 0 END) AS MediumSalary,
      SUM(CASE WHEN e.salary < 60000 THEN 1 ELSE 0 END) AS LowSalary
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id
   GROUP BY d.department_name;

   Output:
   +-----------------+------------+--------------+-----------+
   | department_name | HighSalary | MediumSalary | LowSalary |
   +-----------------+------------+--------------+-----------+
   | Engineering     |          1 |            1 |         0 |
   | QA              |          0 |            1 |         0 |
   +-----------------+------------+--------------+-----------+

5. Find employees without a department.

   SELECT
      e.employee_id,
      e.name,
      e.last_name
   FROM Employee AS e
   WHERE e.department_id IS NULL;

6. Find departments without employees.

   SELECT d.department_name
   FROM Department AS d 
   WHERE NOT EXISTS (
      SELECT department_id
      FROM Employee AS e 
      WHERE d.department_id = e.department_id
   );

7. Find departments having more than 1 employee.

   SELECT d.department_name, COUNT(e.name) AS EmpCount
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id
   GROUP BY d.department_name
   HAVING COUNT(e.name) > 1;

8. Find departments whose average salary is greater than the companys overall average salary.

   SELECT d.department_name, AVG(e.salary) AS AvgSal
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id
   GROUP BY d.department_name
   HAVING AVG(e.salary) > (
      SELECT AVG(salary) AS CompanyAvgSal
      FROM Employee
   );

9. Find employees earning more than their department average.

   SELECT e.name
   FROM Employee AS e 
   WHERE e.salary > (
      SELECT AVG(salary) As DeptWiseAvg
      FROM Employee
      WHERE department_id = e.department_id
   );


10. Find the highest-paid employee in every department. -- REVISE

   SELECT e.name, d.department_name, e.salary
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id
   WHERE e.salary = (
      SELECT MAX(e2.salary) FROM 
      Employee AS e2 
      WHERE e2.department_id = e.department_id
   )

11. Find number of employees hired in each year.

   SELECT YEAR(hire_date) AS HireYear, COUNT(*) AS EmpCount
   FROM Employee
   GROUP BY YEAR(hire_date);

12. Count employees in each salary category. -- REVISE, in MySQL, we can use GROUP By on ALIAS also

   SELECT 
      CASE 
         WHEN salary >= 80000 THEN 'High'
         WHEN salary >= 60000 AND salary < 80000 THEN 'Medium'
         WHEN salary < 60000 THEN 'Low'
      END AS SalaryCat,
      COUNT(*) AS EmpCount
   FROM Employee
   GROUP BY SalaryCat;