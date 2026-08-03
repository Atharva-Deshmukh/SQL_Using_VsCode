-------------------- Remember --------------------

LIMIT     → decides HOW MANY rows.
OFFSET    → decides FROM WHERE to start.

-------------------- SELECT --------------------

-- First 5 rows
SELECT * FROM Employees
LIMIT 5;

-- Skip first 5 rows, return next 5
SELECT * FROM Employees
LIMIT 5 OFFSET 5;

-- MySQL shorthand (same as above)
SELECT * FROM Employees
LIMIT 5, 5;

-------------------- UPDATE (MySQL) --------------------

-- Update only 3 rows
UPDATE Employees
SET Age = Age + 1
LIMIT 3;

-------------------- DELETE (MySQL) --------------------

-- Delete only 2 rows
DELETE FROM Employees
LIMIT 2;

-------------------- Common Interview Examples --------------------

-- Top 3 highest salaries
SELECT *
FROM Employees
ORDER BY Salary DESC
LIMIT 3;

-- Pagination (Page 2, 10 records/page)
SELECT *
FROM Employees
ORDER BY EmployeeID
LIMIT 10 OFFSET 10;

-- Highest paid employee
SELECT *
FROM Employees
ORDER BY Salary DESC
LIMIT 1;
*/