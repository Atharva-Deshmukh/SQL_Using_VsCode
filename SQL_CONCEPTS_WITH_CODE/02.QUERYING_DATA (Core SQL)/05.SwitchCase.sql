/* Syntax

CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE result
END;
*/

----------------------------------------------------------------------
Example 1: Searched CASE
----------------------------------------------------------------------

-- Employees Table

+--------+--------+
| name   | salary |
+--------+--------+
| Alice  | 70000  |
| Bob    | 50000  |
| Charlie| 35000  |
+--------+--------+

-- Goal: Classify employees based on salary

SELECT
    name,
    salary,
    CASE                                                 -- No column-name specified here
        WHEN salary >= 60000 THEN 'High'                 -- individual row is compared -> when salary > .. then ..
        WHEN salary >= 40000 THEN 'Medium'               -- USE CASE: When we evaluate a condition
        ELSE 'Low'
    END AS salary_band
FROM employees;

Output

+---------+--------+-------------+
| name    | salary | salary_band |
+---------+--------+-------------+
| Alice   | 70000  | High        |
| Bob     | 50000  | Medium      |
| Charlie | 35000  | Low         |
+---------+--------+-------------+

----------------------------------------------------------------------
Example 2: Simple CASE (Switch-like)
----------------------------------------------------------------------

-- Employees Table

+---------+-------------+
| name    | department  |
+---------+-------------+
| Alice   | HR          |
| Bob     | Engineering |
| Charlie | Finance     |
+---------+-------------+

SELECT
    name,
    department,
    CASE department                                    -- Column-name specified here
        WHEN 'HR' THEN 'People Team'
        WHEN 'Engineering' THEN 'Tech Team'            -- Here value is already considered in case
        ELSE 'Other'                                   -- When dept is this.. then this..
    END AS team_label                                  -- USE CASE: When we evaluate a value
FROM employees;

Output

+---------+-------------+--------------+
| name    | department  | team_label   |
+---------+-------------+--------------+
| Alice   | HR          | People Team  |
| Bob     | Engineering | Tech Team    |
| Charlie | Finance     | Other        |
+---------+-------------+--------------+