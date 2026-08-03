/**********************************************************************
                        GROUP BY & HAVING
**********************************************************************/

/*
GROUP BY:
- Groups rows having the same value(s).
- Usually used with aggregate functions.

Aggregate Functions:
    COUNT(), SUM(), AVG(), MIN(), MAX()

Remember:
    GROUP BY → Creates groups (buckets)
    Aggregate → Calculates value for each bucket

Execution Order:
    FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY

SQL does not execute the clauses in the order you write them. It executes them in a logical order.
*/

----------------------------------------------------------------------
Example Table

+---------+------+-------------+
| Name    | Year | Subject     |
+---------+------+-------------+
| Avery   | 1    | Math        |
| James   | 1    | Math        |
| Elijah  | 2    | English     |
| Charlotte|2    | English     |
| Harper  | 3    | Science     |
| Benjamin| 3    | Science     |
+---------+------+-------------+

----------------------------------------------------------------------
GROUP BY
----------------------------------------------------------------------

SELECT Subject, COUNT(*)
FROM Student
GROUP BY Subject;

Output

+-----------+----------+
| Subject   | COUNT(*) |
+-----------+----------+
| Math      | 2        |
| English   | 2        |
| Science   | 2        |
+-----------+----------+

----------------------------------------------------------------------
Multiple Columns
----------------------------------------------------------------------

SELECT Subject, Year, COUNT(*)
FROM Student
GROUP BY Subject, Year;

Output

+-----------+------+----------+
| Subject   | Year | COUNT(*) |
+-----------+------+----------+
| Math      | 1    | 2        |
| English   | 2    | 2        |
| Science   | 3    | 2        |
+-----------+------+----------+

----------------------------------------------------------------------
GROUP BY Rules
----------------------------------------------------------------------

❌ Incorrect

SELECT Subject, Year, COUNT(*)
FROM Student
GROUP BY Subject;

Reason:
    Every selected column must be:
    • In GROUP BY, OR
    • Inside an aggregate function.

----------------------------------------------------------------------
HAVING
----------------------------------------------------------------------

-- WHERE filters rows.
-- HAVING filters groups.

Example Table (Emp)

+--------+------+---------+
| EmpNo  | Age  | Sal     |
+--------+------+---------+
| 1      | 25   | 50000   |
| 2      | 25   | 70000   |
| 3      | 30   | 80000   |
| 4      | 30   | 60000   |
| 5      | 35   | 40000   |
| 6      | 35   | 50000   |
+--------+------+---------+

SELECT Age,
       AVG(Sal) AS AvgSalary
FROM Emp
GROUP BY Age
HAVING AVG(Sal) > 60000;

    Step 1: GROUP BY Age

    Age 25 → [50000, 70000]
    Average = 60000

    Age 30 → [80000, 60000]
    Average = 70000

    Age 35 → [40000, 50000]
    Average = 45000

Step 2: HAVING AVG(Sal) > 60000

    Age 25 → 60000 ❌
    Age 30 → 70000 ✅
    Age 35 → 45000 ❌

Output

    +------+-----------+
    | Age  | AvgSalary |
    +------+-----------+
    | 30   | 70000     |
    +------+-----------+

----------------------------------------------------------------------
WHERE vs HAVING
----------------------------------------------------------------------

WHERE
- Filters rows
- Before GROUP BY
- Cannot use aggregate functions

HAVING
- Filters groups
- After GROUP BY
- Can use aggregate functions

Example

SELECT Department,
       COUNT(*) AS EmpCount
FROM Emp
WHERE Salary > 30000
GROUP BY Department
HAVING COUNT(*) > 5;

Meaning:
1. Ignore employees with Salary ≤ 30000.
2. Group remaining employees by Department.
3. Return only departments having more than 5 employees.

----------------------------------------------------------------------
Common Interview Questions
----------------------------------------------------------------------

-- Count employees per age

SELECT Age, COUNT(*)
FROM Emp
GROUP BY Age;

------------------------------------------------------------

-- Average salary per department

SELECT Department,
       AVG(Salary)
FROM Emp
GROUP BY Department;

------------------------------------------------------------

-- Departments having more than 10 employees

SELECT Department,
       COUNT(*)
FROM Emp
GROUP BY Department
HAVING COUNT(*) > 10;

------------------------------------------------------------

-- Total salary per department

SELECT Department,
       SUM(Salary)
FROM Emp
GROUP BY Department;

/**********************************************************************/