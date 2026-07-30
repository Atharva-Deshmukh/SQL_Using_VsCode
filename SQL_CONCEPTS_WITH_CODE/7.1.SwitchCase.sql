/*  Syntax:

CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END;  */

-- Goal: Classify employees based on salary
SELECT
  name,
  salary,
  CASE
    WHEN salary >= 60000 THEN 'High'
    WHEN salary >= 40000 THEN 'Medium'
    ELSE 'Low'
  END AS salary_band
FROM employees;

-- Example 2: Use with column comparison (like a switch)
SELECT
  name,
  department,
  CASE department
    WHEN 'HR' THEN 'People Team'
    WHEN 'Engineering' THEN 'Tech Team'
    ELSE 'Other'
  END AS team_label
FROM employees;