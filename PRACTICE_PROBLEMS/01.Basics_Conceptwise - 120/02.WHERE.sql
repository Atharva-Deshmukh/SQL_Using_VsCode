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

1. Find employees with salary > 50000.

   SELECT * FROM Employee WHERE salary > 50000;

2. Find employees with salary between 40000 and 80000.

   SELECT * FROM Employee WHERE (salary >= 40000 AND salary <=80000);
                              OR
   SELECT * FROM Employee WHERE salary BETWEEN 40000 AND 80000; --> REVISE

3. Find employees belonging to department 10.

   SELECT * FROM Employee WHERE department_id = 10;

4. Find employees not belonging to department 20.

   SELECT * FROM Employee WHERE department_id <> 20;  --> REVISE

5. Find employees with age > 30 AND salary > 50000.

   SELECT * FROM Employee WHERE (age > 30) AND (salary > 50000);

6. Find employees belonging to department 10 OR 20.

   SELECT * FROM Employee WHERE department_id IN(10, 20);
                           OR
   SELECT * FROM Employee WHERE (department_id = 10) OR (department_id = 20);

7. Find employees whose name starts with 'A'.

   SELECT * FROM Employee WHERE name REGEXP '^A.*$';  --> Revise

8. Find employees whose name ends with 'n'.

   SELECT * FROM Employee WHERE name REGEXP '.*n$';

9. Find employees whose name contains 'ar'.

   SELECT * FROM Employee WHERE name REGEXP 'ar';

10. Find employees whose salary is 40000, 50000 or 60000.

   SELECT * FROM Employee WHERE salary IN(40000, 50000, 60000);  --> Revise

11. Find employees whose salary is NOT 40000, 50000 or 60000.

   SELECT * FROM Employee WHERE salary NOT IN(40000, 50000, 60000);

12. Find employees hired after 2024-01-01.

   SELECT * FROM Employee WHERE hire_date > '2024-01-01.' --> Revise
