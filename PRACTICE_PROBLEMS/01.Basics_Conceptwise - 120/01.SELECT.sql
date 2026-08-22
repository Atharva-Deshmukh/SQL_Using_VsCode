
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

1. Display all employees.

   SELECT name FROM Employee;
   
   Output:
   +-------+
   | name  |
   +-------+
   | John  |
   | Alice |
   | Bob   |
   | Carol |
   | David |
   +-------+

2. Display only name, salary and department_id.

   SELECT name, salary, department_id FROM Employee;

3. Display distinct department_id values.

   SELECT DISTINCT department_id FROM Employee;

   Output:
   +---------------+
   | department_id |
   +---------------+
   |            10 |
   |            20 |
   |          NULL |
   +---------------+

4. Display employee name and salary increased by 10%.  --> Revise

    SELECT name, (salary + (0.1 * salary)) FROM Employee;

    Output:
   +-------+---------------------------+
   | name  | (salary + (0.1 * salary)) |
   +-------+---------------------------+
   | John  |                   99000.0 |
   | Alice |                   77000.0 |
   | Bob   |                   66000.0 |
   | Carol |                   55000.0 |
   | David |                   88000.0 |
   +-------+---------------------------+

5. Display employee name with alias Employee_Name.

   SELECT name AS Employee_Name FROM Employee;

   Output:
   +---------------+
   | Employee_Name |
   +---------------+
   | John          |
   | Alice         |
   | Bob           |
   | Carol         |
   | David         |
   +---------------+

6. Display employee name and a constant column 'Employee'.  --> Revise

   SELECT name, 'Employee' FROM Employee;

   Output:
   +-------+----------+
   | name  | Employee |
   +-------+----------+
   | John  | Employee |
   | Alice | Employee |
   | Bob   | Employee |
   | Carol | Employee |
   | David | Employee |
   +-------+----------+

7. Display employees ordered by salary ascending.

   SELECT * FROM Employee ORDER BY salary ASC;

   Output:
   +-------------+-------+-----+---------------+------------+--------+------------------+--------+------------+
   | employee_id | name  | age | department_id | manager_id | salary | experience_years | status | hire_date  |
   +-------------+-------+-----+---------------+------------+--------+------------------+--------+------------+
   |           4 | Carol |  24 |          NULL |          1 |  50000 |                1 | A      | 2025-02-05 |
   |           3 | Bob   |  31 |            20 |          5 |  60000 |                3 | I      | 2022-01-20 |
   |           2 | Alice |  29 |            10 |          1 |  70000 |                4 | A      | 2021-06-10 |
   |           5 | David |  40 |            20 |       NULL |  80000 |               10 | A      | 2016-09-12 |
   |           1 | John  |  35 |            10 |       NULL |  90000 |                8 | A      | 2018-03-15 |
   +-------------+-------+-----+---------------+------------+--------+------------------+--------+------------+

8. Display employees ordered by salary descending.

   SELECT * FROM Employee ORDER BY salary DESC;

9. Display the top 5 highest-paid employees.

   SELECT * FROM Employee ORDER BY salary DESC LIMIT 5;

   Output:
   +-------------+-------+-----+---------------+------------+--------+------------------+--------+------------+
   | employee_id | name  | age | department_id | manager_id | salary | experience_years | status | hire_date  |
   +-------------+-------+-----+---------------+------------+--------+------------------+--------+------------+
   |           1 | John  |  35 |            10 |       NULL |  90000 |                8 | A      | 2018-03-15 |
   |           5 | David |  40 |            20 |       NULL |  80000 |               10 | A      | 2016-09-12 |
   |           2 | Alice |  29 |            10 |          1 |  70000 |                4 | A      | 2021-06-10 |
   |           3 | Bob   |  31 |            20 |          5 |  60000 |                3 | I      | 2022-01-20 |
   |           4 | Carol |  24 |          NULL |          1 |  50000 |                1 | A      | 2025-02-05 |
   +-------------+-------+-----+---------------+------------+--------+------------------+--------+------------+

10. Display employees ordered by department_id and salary descending.  --> Revise

   SELECT * FROM Employee ORDER BY department_id ASC, salary DESC;

