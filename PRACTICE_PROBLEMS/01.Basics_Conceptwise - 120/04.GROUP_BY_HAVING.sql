Employee

   | employee_id | name  | age | department_id | manager_id | salary | experience_years | status | hire_date  |
   |-------------|-------|-----|---------------|------------|--------|------------------|--------|------------|
   | 1           | John  | 35  | 10            | NULL       | 90000  | 8                | A      | 2018-03-15 |
   | 2           | Alice | 29  | 10            | 1          | 70000  | 4                | A      | 2021-06-10 |
   | 3           | Bob   | 31  | 20            | 5          | 60000  | 3                | I      | 2022-01-20 |
   | 4           | Carol | 24  | NULL          | 1          | 50000  | 1                | A      | 2025-02-05 |
   | 5           | David | 40  | 20            | NULL       | 80000  | 10               | A      | 2016-09-12 |

CREATE TABLE IF NOT EXISTS Employee (
    employee_id INT NOT NULL,
    name VARCHAR(100),                                   --> VARCHAR must have length
    age INT NOT NULL,
    department_id INT,
    manager_id INT,
    salary INT,
    experience_years INT NOT NULL,
    status ENUM('A', 'I'),                                --> ENUMS must be single quoted
    hire_date DATE
);

INSERT INTO Employee VALUES  
(1, 'John',  35, 10, null, 90000, 8, 'A', '2018-03-15'),      --> Dates must be single quoted
(2, 'Alice', 29, 10, 1,    70000, 4, 'A', '2021-06-10'),
(3, 'Bob',   31, 20, 5,    60000, 3, 'I', '2022-01-20'),      --> Single quotes are the standard SQL style
(4, 'Carol', 24, null,   1,    50000, 1, 'A', '2025-02-05'),
(5, 'David', 40, 20, null, 80000, 10, 'A', '2016-09-12');

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

PROBLEMS
--------

1. Count all employees.

   SELECT COUNT(*) AS EMP_COUNT 
   FROM Employee;

   Output:
   +-----------+
   | EMP_COUNT |
   +-----------+
   |         5 |
   +-----------+

2. Count employees in each department.          -->    REVISE

   SELECT d.department_name, COUNT(*) AS NoOfEmployees
   FROM Employee AS e 
   INNER JOIN Department as d 
      ON e.department_id = d.department_id
   GROUP BY d.department_name;

   Output:
   +-----------------+---------------+
   | department_name | NoOfEmployees |
   +-----------------+---------------+
   | Engineering     |             2 |
   | QA              |             2 |
   +-----------------+---------------+

   We need not use joins here in case department name is not asked in the question, we can straight away group by department_id

   SELECT department_id, COUNT(*) AS employee_count
   FROM Employee
   GROUP BY department_id;

3. Find average salary.

   SELECT AVG(Employee.salary) AS AVG_SALARY 
   FROM Employee;

4. Find average salary per department.

   SELECT d.department_name, AVG(e.salary)
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id
   GROUP BY d.department_name;

   Output:
   +-----------------+---------------+
   | department_name | AVG(e.salary) |
   +-----------------+---------------+
   | Engineering     |    80000.0000 |
   | QA              |    70000.0000 |
   +-----------------+---------------+

5. Find maximum salary per department.

   SELECT d.department_name, MAX(e.salary) AS Max_Salary
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id
   GROUP BY d.department_name;

   Output:
   +-----------------+------------+
   | department_name | Max_Salary |
   +-----------------+------------+
   | Engineering     |      90000 |
   | QA              |      80000 |
   +-----------------+------------+

6. Find minimum salary per department.

   SELECT d.department_name, MIN(e.salary) AS Min_Salary
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id
   GROUP BY d.department_name;

7. Find total salary per department.

   SELECT d.department_name, SUM(e.salary) AS Total_Salary
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id
   GROUP BY d.department_name;

8. Find departments having more than 1 employee.  --> REVISE

   SELECT d.department_name, COUNT(*) AS Emp_Count
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id
   GROUP BY d.department_name
   HAVING COUNT(*) > 1;

   Output:
   +-----------------+-----------+
   | department_name | Emp_Count |
   +-----------------+-----------+
   | Engineering     |         2 |
   | QA              |         2 |
   +-----------------+-----------+

9. Find departments whose average salary > 60000.

   SELECT d.department_name, AVG(e.salary) AS AverageSal
   FROM Employee AS e 
   INNER JOIN Department AS d
      ON e.department_id = d.department_id
   GROUP BY d.department_name
   HAVING AVG(e.salary) > 60000;

10. Find departments whose total salary > 100000.

   SELECT d.department_name, SUM(e.salary) AS TotalSal
   FROM Employee AS e 
   INNER JOIN Department AS d
      ON e.department_id = d.department_id
   GROUP BY d.department_name
   HAVING SUM(e.salary) > 100000;

11. Count employees in each department whose salary > 50000.      -->  REVISE

   Thought process: I have to also now filter rows - Hence I can use WHERE clause along with GROUP BY

   SELECT d.department_name, COUNT(*) AS EmployeeCount
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id
   WHERE e.salary > 50000
   GROUP BY d.department_name;

      Output:
      +-----------------+---------------+
      | department_name | EmployeeCount |
      +-----------------+---------------+
      | Engineering     |             2 |
      | QA              |             2 |
      +-----------------+---------------+

12. Find departments having at least 2 employees earning > 50000.  -->   REVISE


   Thought process: I have to also now filter rows - WHERE CLAUSE
                    I have to apply condition on the groups, hence HAVING clause
                    Get the count of employees per dept using GROUP BY clause and then apply > 2 condition

   SELECT d.department_name, COUNT(*) AS EmployeeCount
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id
   WHERE (e.salary > 50000)
   GROUP BY d.department_name
   HAVING COUNT(*) >= 2;

   Output:
   +-----------------+---------------+
   | department_name | EmployeeCount |
   +-----------------+---------------+
   | Engineering     |             2 |
   | QA              |             2 |
   +-----------------+---------------+
