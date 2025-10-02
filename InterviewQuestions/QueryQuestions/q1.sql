-- Table: Salary
-- +-------+---------+--------+----------+
-- | Empld | Project | Salary | Variable |
-- +-------+---------+--------+----------+
-- | 121   | P1      | 20000  | 0        |
-- | 321   | P2      | 35000  | 1000     |
-- | 421   | P1      | 50000  | 3000     |
-- +-------+---------+--------+----------+

/*
Problem Statement:
Write an SQL query to fetch the different projects available from the Salary table.
*/

SELECT DISTINCT Project FROM Salary;


/*
Problem Statement:
Write an SQL query to fetch the count of employees working in project 'P1'.
*/

SELECT COUNT(*) AS Employee_Count FROM Salary WHERE Project = 'P1';

/*
Problem Statement:
Write an SQL query to find the maximum, minimum, and average salary of the employees.
*/

SELECT MAX(Salary), MIN(Salary), AVG(Salary) from Salary;