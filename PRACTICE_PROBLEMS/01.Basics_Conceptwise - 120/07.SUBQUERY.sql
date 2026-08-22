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

1. Find employees earning above the overall average salary.

2. Find employee(s) with the maximum salary.

3. Find employees earning above the minimum salary.

4. Find employees working in departments located in Bangalore.

5. Find employees whose department has more than 1 employee.

6. Find employees earning above their own department average.

7. Find employees having the highest salary in their department.

8. Find employees whose salary is greater than their department average.
