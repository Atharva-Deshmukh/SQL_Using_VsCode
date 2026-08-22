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

1. Categorize salary:             --> REVISE
   >= 80000 → High
   >= 60000 → Medium
   otherwise → Low

   SELECT salary, 
      CASE
         WHEN salary >= 80000 THEN 'High'
         WHEN salary >= 60000 THEN 'Medium'
         ELSE 'Low'
      END AS Category
   FROM Employee;

   Dont use simple case here, it will be syntactically incorrect

      SELECT salary, 
         CASE salary
            WHEN >= 80000 THEN 'High'     --> When value is this.. THEN this..
            WHEN >= 60000 THEN 'Medium'       >= is not string hence error
            ELSE 'Low'                        We are evaluating a condition
         END AS Category
      FROM Employee;

2. Categorize employees as Adult / Minor using age 18.

   SELECT AGE, 
      CASE
         WHEN Age >= 18 THEN 'Adult'
         WHEN Age < 18 THEN 'Minor'
      END AS Category
   FROM Employee;

3. Convert status:
   A → Active
   I → Inactive   

   SELECT status, 
      CASE status
         WHEN 'A' THEN 'Active'         --> Simple case since we are now comparing values not expressions
         WHEN 'I' THEN 'Inactive'
      END AS Category
   FROM Employee;

4. Categorize experience:
   >= 8 → Senior
   >= 3 → Mid
   otherwise → Junior

   -- Searched case since we are now comparing expressions
   SELECT experience_years, 
      CASE 
         WHEN experience_years >= 8 THEN 'Senior'
         WHEN (experience_years >= 3 AND experience_years < 8) THEN 'Mid'
         ELSE 'Junior' 
      END AS Category
   FROM Employee;

5. Display name, salary and salary grade.

   SELECT name, salary, 
      CASE 
         WHEN salary >= 80000 THEN 'High'
         WHEN salary >= 60000 THEN 'Medium'
         ELSE 'Low'
      END AS salary_grade
   FROM Employee;
      

6. Count employees in each salary category.      --> REVISE

    Thought process: First create table as per salary category, then COUNT(*) on groups as per salary category

   SELECT
      CASE 
         WHEN salary >= 80000 THEN 'High'
         WHEN salary >= 60000 THEN 'Medium'
         ELSE 'Low'
      END AS SalaryCategory,
      COUNT(*)                -- Cannot use COUNT(SalaryCategory) here
   FROM Employee
   GROUP BY SalaryCategory;

   Output:
   +----------------+----------+
   | SalaryCategory | COUNT(*) |
   +----------------+----------+
   | High           |        2 |
   | Medium         |        2 |
   | Low            |        1 |
   +----------------+----------+

7. Count High-salary employees in each department.        -->         REVISE 

   Thought process: Join the Employee and Department to get department_name, SalaryCategory
                    We dont need CASE explicitly, just the case condition is sufficient here

   SELECT
      d.department_name,
      COUNT(*) AS HighSalaryEmployeeCount
   FROM Employee AS e
   INNER JOIN Department AS d 
      ON d.department_id = e.department_id
   WHERE e.salary >= 80000
   GROUP BY d.department_name;