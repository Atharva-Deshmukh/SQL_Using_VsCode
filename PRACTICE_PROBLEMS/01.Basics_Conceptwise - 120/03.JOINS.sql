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

PROBLEMS
--------

1. Display employee name and department name. --> REVISE

   Thought process: I need all employee names and the dept names as per dept id, hence left join

   SELECT e.name, d.department_name
   FROM Employee AS e 
   LEFT JOIN Department AS d 
      ON e.department_id = d.department_id;

   Output:
   +-------+-----------------+
   | name  | department_name |
   +-------+-----------------+
   | John  | Engineering     |
   | Alice | Engineering     |
   | Bob   | QA              |
   | Carol | NULL            |      --> NULL is also included in left join
   | David | QA              |
   +-------+-----------------+

   IF WE WANT ONLY THOSE EMPLOYEES WHOSE HAVE SOME DEPT, we can exclude null using inner join

   SELECT e.name, d.department_name
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id;

   Output:
   +-------+-----------------+
   | name  | department_name |
   +-------+-----------------+
   | John  | Engineering     |
   | Alice | Engineering     |
   | Bob   | QA              |
   | David | QA              |
   +-------+-----------------+

2. Display ALL employees with their department name,
   including employees without a department.

   SELECT e.name, d.department_name
   FROM Employee AS e 
   LEFT JOIN Department AS d 
      ON e.department_id = d.department_id;


3. Display ALL departments with their employees,        -->   REVISE
   including departments having no employees.

   SELECT d.department_name, e.name
   FROM Department AS d
   LEFT JOIN Employee AS e 
      ON d.department_id = e.department_id;

   Output:
   +-----------------+-------+
   | department_name | name  |
   +-----------------+-------+
   | Engineering     | Alice |           --> The order within each department is not guaranteed unless you use ORDER BY
   | Engineering     | John  |
   | QA              | David |
   | QA              | Bob   |
   | HR              | NULL  |
   | Finance         | NULL  |
   +-----------------+-------+

4. Find employees who have no matching department.      -->   REVISE

   Meaning of the question: Whose department_id is not in the dept table

   Carol is the ans since NULL is not there in the dept table

   SELECT e.name
   FROM Employee AS e 
   LEFT JOIN Department AS d
      ON e.department_id = d.department_id
   WHERE e.department_id IS NULL;           --> REVISE syntax IS NULL, NOT = NULL

   Output:
   +-------+
   | name  |
   +-------+
   | Carol |
   +-------+

5. Display employee name, department name and city.  --> REVISE

   SELECT e.name, d.department_name, l.city
   FROM Employee AS e 
   LEFT JOIN Department AS d 
      ON e.department_id = d.department_id
   LEFT JOIN Location AS l
      ON d.location_id = l.location_id;

   Output:
   +-------+-----------------+-----------+
   | name  | department_name | city      |
   +-------+-----------------+-----------+
   | John  | Engineering     | Bangalore |
   | Alice | Engineering     | Bangalore |
   | Bob   | QA              | Pune      |
   | Carol | NULL            | NULL      |
   | David | QA              | Pune      |
   +-------+-----------------+-----------+

   When u dont need nulls, use INNER JOINS

   SELECT e.name, d.department_name, l.city
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id
   INNER JOIN Location AS l
      ON d.location_id = l.location_id;

   Output:
   +-------+-----------------+-----------+
   | name  | department_name | city      |
   +-------+-----------------+-----------+
   | John  | Engineering     | Bangalore |
   | Alice | Engineering     | Bangalore |
   | Bob   | QA              | Pune      |
   | David | QA              | Pune      |
   +-------+-----------------+-----------+

6. Join Employee → Department → Location and display:
   employee, department and city.

      SELECT e.name, d.department_name, l.city
      FROM Employee AS e 
      INNER JOIN Department AS d 
         ON e.department_id = d.department_id
      INNER JOIN Location AS l
         ON d.location_id = l.location_id;

7. Display every employee and their managers name.  --> IMP REVISE

   SELECT e.name AS Employee_Name, m.name AS Manager_Name
   FROM Employee AS e 
   INNER JOIN Employee AS m 
      ON e.manager_Id = m.employee_id; /* Whose manager is the employee, hence manager_Id first*/

8. Find employees who earn more than their manager.

   SELECT e.name 
   FROM Employee AS e 
   INNER JOIN Employee AS m 
      ON e.manager_id = m.employee_id
   WHERE e.salary > m.salary;

   As per our data, no employee earns more than their manager

9. Find employees who do not have a manager.

   SELECT e.name 
   FROM Employee AS e 
   LEFT JOIN Employee AS m 
      ON e.manager_id = m.employee_id
   WHERE e.manager_id IS NULL;

   SELECT name FROM Employee WHERE Employee.manager_id IS NULL;

10. Find employees working in Engineering. --> REVISE

   SELECT e.name 
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id
   WHERE e.department_id = 10;

   SELECT name FROM Employee WHERE Employee.department_id = 10  --> We may not know another table value, hence don't use this

11. Find employees earning > 50000 in Engineering.

   SELECT e.name 
   FROM Employee AS e 
   INNER JOIN Department AS d 
      ON e.department_id = d.department_id
   WHERE (e.department_id = 10 AND e.salary > 50000);

12. Find employees hired after 2024 with their department name. --> Revise

   SELECT e.name, d.department_name
   FROM Employee AS e 
   LEFT JOIN Department AS d 
      ON e.department_id = d.department_id
   WHERE e.hire_date > '2024-01-01';         --> REVISE date format: YYYY-MM-DD

   Output:
   +-------+-----------------+
   | name  | department_name |
   +-------+-----------------+
   | Carol | NULL            |
   +-------+-----------------+
