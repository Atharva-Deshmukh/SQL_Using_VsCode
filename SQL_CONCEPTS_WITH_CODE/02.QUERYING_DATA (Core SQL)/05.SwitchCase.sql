/*

Employee

   | employee_id | name  | age | department_id | manager_id | salary | experience_years | status | hire_date  |
   |-------------|-------|-----|---------------|------------|--------|------------------|--------|------------|
   | 1           | John  | 35  | 10            | NULL       | 90000  | 8                | A      | 2018-03-15 |
   | 2           | Alice | 29  | 10            | 1          | 70000  | 4                | A      | 2021-06-10 |
   | 3           | Bob   | 31  | 20            | 5          | 60000  | 3                | I      | 2022-01-20 |
   | 4           | Carol | 24  | NULL          | 1          | 50000  | 1                | A      | 2025-02-05 |
   | 5           | David | 40  | 20            | NULL       | 80000  | 10               | A      | 2016-09-12 |


----------------------------------------------------------------------
Type 1: Searched CASE
----------------------------------------------------------------------

CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE result
END;

USE CASE: When we have to evaluate some conditions
*/


/* Categorize experience:
   >= 8 → Senior
   >= 3 → Mid
   otherwise → Junior
*/

-- Searched case since we are now comparing expressions
SELECT experience_years, 
   CASE 
      WHEN experience_years >= 8 THEN 'Senior'
      WHEN (experience_years >= 3 AND experience_years < 8) THEN 'Mid'
      ELSE 'Junior' 
   END AS Category
FROM Employee;

Output:
+------------------+----------+
| experience_years | Category |
+------------------+----------+
|                8 | Senior   |
|                4 | Mid      |
|                3 | Mid      |
|                1 | Junior   |
|               10 | Senior   |
+------------------+----------+

----------------------------------------------------------------------
Type 2: Simple CASE
----------------------------------------------------------------------

CASE
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ELSE result
END;

USE CASE: When we have to compare values
*/

/* Convert status:
   A → Active
   I → Inactive   
*/

-- Simple case since we are now comparing values not expressions
SELECT status, 
CASE status
   WHEN 'A' THEN 'Active'    
   WHEN 'I' THEN 'Inactive'
END AS Category
FROM Employee;


Output:
+--------+----------+
| status | Category |
+--------+----------+
| A      | Active   |
| A      | Active   |
| I      | Inactive |
| A      | Active   |
| A      | Active   |
+--------+----------+