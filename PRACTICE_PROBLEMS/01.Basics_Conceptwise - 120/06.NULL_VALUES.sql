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

1. Find employees whose manager_id IS NULL.

   SELECT name FROM Employee WHERE manager_id IS NULL;

   Output:
   +-------+
   | name  |
   +-------+
   | John  |
   | David |
   +-------+

2. Find employees whose department_id IS NULL.

   SELECT name FROM Employee WHERE department_id IS NULL; 

3. Replace NULL salary with 0 using COALESCE.

   SELECT name, COALESCE(salary, 0) FROM Employee;

4. Replace NULL department_id with 'Unknown'.   -->   REVISE

   SELECT name, COALESCE(department_id, 'Unknown') FROM Employee;

   Output:
   +-------+------------------------------------+
   | name  | COALESCE(department_id, 'Unknown') |
   +-------+------------------------------------+
   | John  | 10                                 |
   | Alice | 10                                 |
   | Bob   | 20                                 |
   | Carol | Unknown                            |
   | David | 20                                 |
   +-------+------------------------------------+

5. Count employees whose manager_id IS NULL.

   SELECT COUNT(*) FROM Employee WHERE manager_id IS NULL;

   Output:
   +----------+
   | COUNT(*) |
   +----------+
   |        2 |
   +----------+

6. Find employees whose manager_id IS NOT NULL.

   SELECT name FROM Employee WHERE manager_id IS NOT NULL;

7. Find employees with missing department information.   -->  REVISE, language of the question

   SELECT name FROM Employee WHERE department_id IS NULL;

8. Explain why:
   WHERE manager_id = NULL                              --> REVISE concept
   does not correctly find NULL values.

   NULL represents a missing/unknown value in SQL.
   It is not a normal value that can be compared using =.

   NULL = NULL results in UNKNOWN, not TRUE.
   WHERE only returns rows where the condition is TRUE.

   Therefore:

   WRONG:
      WHERE manager_id = NULL

   CORRECT:
      WHERE manager_id IS NULL

9. Compare COUNT(*) and COUNT(salary).                --> REVISE

   COUNT(*)      → Counts all rows.
   COUNT(column) → Ignores NULL values.

10. Use COALESCE to display a fallback value for NULLs. --> Done already

