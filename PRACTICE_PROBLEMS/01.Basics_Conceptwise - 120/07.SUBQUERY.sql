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

   Thought process: select only the rows with above average salary
                    avg salary to be calculated via subquery

   SELECT name, salary 
   FROM Employee
   WHERE salary > (SELECT AVG(salary) FROM Employee);

2. Find employee(s) with the maximum salary.

   Thought process: select only the rows with max salary
                    max salary to be calculated via subquery

   SELECT name, salary 
   FROM Employee
   WHERE salary = (SELECT MAX(salary) FROM Employee);

3. Find employees earning above the minimum salary.

   Thought process: select only the rows with > min salary
                    min salary to be calculated via subquery

      SELECT name, salary
      FROM Employee
      WHERE salary > (SELECT MIN(salary) FROM Employee);

4. Find employees working in departments located in Bangalore.    --> REVISE

   Thought process: Way-1: Using joins
                    Join the tables to get name, department_name, location_name using INNER joins to 
                    avoid null
                    where city =  Bangalore

                    Way-2: Using subquery
                           Work backwards: Location -> Department -> Employee

                           Return location_ids with city = 'Bangalore'
                           Return department_ids with the above location_ids
                           Return names with the above department_ids

         SELECT name 
         FROM Employee 
         WHERE department_id IN (        -- Filter first tables department_ids based on inner tables values
            SELECT department_id 
            FROM Department 
            WHERE location_id IN (     -- Filter those department_ids based on location_ids returned from inner query
               SELECT location_id
               FROM Location 
               WHERE city = 'Bangalore'
            )
         );

5. Find employees whose department has more than 1 employee.

   Thought process: Find names based on department_ids from subquery
                    subquery returns department_ids with count > 1

      SELECT name 
      FROM Employee
      WHERE department_id IN (
         SELECT department_id
         FROM Employee 
         GROUP BY department_id
         HAVING COUNT(*) > 1
      );

6. Find employees earning above their own department average.         -->   REVISE

   Thought process: filter employees in outer query based on inner query
                    inner query returns avg salary of the current employee department only

                    Since we need to determine which department the current employee belongs to

                    This creates dependency of inner query on the outer query, hence we used
                    correlated subquery

      SELECT name, salary
      FROM Employee AS outer_e
      WHERE salary > (
         SELECT AVG(salary) FROM Employee AS inner_e
         WHERE inner_e.department_id = outer_e.department_id   -- CALCULATE THE avg salary of current employee's dept only
      );

7. Find employees having the highest salary in their department.

   Thought process: filter employees in outer query based on inner query
                    inner query returns hightest salary of the current employee department only

                    This creates dependency of inner query on the outer query, hence we used
                    correlated subquery

      SELECT name, salary
      FROM Employee AS outer_e
      WHERE salary = (
         SELECT MAX(salary) 
         FROM Employee AS inner_e
         WHERE inner_e.department_id = outer_e.department_id
      );

8. Find employees whose salary is greater than their department average. -- Done already!
