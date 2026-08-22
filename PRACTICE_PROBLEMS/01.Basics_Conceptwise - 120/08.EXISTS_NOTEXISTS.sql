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

PROBLEMS
--------

1. Find employees whose department exists.


   Thought process: Dont just check if department_id != null
                    Also check if that department_id exists in the department table

    SELECT name 
    FROM Employee AS e
    WHERE EXISTS (
    SELECT * FROM Department AS d
    WHERE d.department_id = e.department_id
    );

2. Find departments having at least one employee.  -- REVISE

    SELECT department_name 
    FROM Department AS d
    WHERE EXISTS (
    SELECT * FROM Employee AS e
    WHERE e.department_id = d.department_id
    );

3. Find departments having no employees.          -- REVISE

    SELECT department_name 
    FROM Department AS d
    WHERE NOT EXISTS (
    SELECT * FROM Employee AS e
    WHERE e.department_id = d.department_id
    );

4. Find customers who have placed at least one order.

    SELECT name 
    FROM Customer AS c
    WHERE EXISTS (
    SELECT order_id
    FROM Orders AS o
    WHERE o.customer_id = c.customer_id
    );

5. Find customers who have never placed an order.

    SELECT name 
    FROM Customer AS c
    WHERE NOT EXISTS (
    SELECT order_id
    FROM Orders AS o
    WHERE o.customer_id = c.customer_id
    );
