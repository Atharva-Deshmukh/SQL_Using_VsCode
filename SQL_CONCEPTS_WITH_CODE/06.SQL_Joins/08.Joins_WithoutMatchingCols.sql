/*
===========================================================
EQUI JOIN → JOIN condition uses = between columns.
===========================================================

Example:

SELECT e.EmpName, d.DeptName
FROM employees e
JOIN departments d
    ON e.DeptId = d.DeptId;

→ This is an INNER JOIN using =.

Most common joins using matching/foreign keys/columns are EQUI JOINS.

===========================================================
NON-EQUI JOIN
===========================================================

NON-EQUI JOIN → JOIN condition uses operators other than =.

Examples:
    <
    >
    <=
    >=
    BETWEEN
    etc.

Example: TABLE WITHOUT ANY MATCHING COLUMN

employees
    +-------+------+--------+
    | EmpId | Name | Salary |
    +-------+------+--------+
    | 1     | John | 2500   |
    | 2     | Emma | 4000   |
    | 3     | Ravi | 7000   |
    +-------+------+--------+

salary_grades
    +-------+-----------+-----------+
    | Grade | MinSalary | MaxSalary |
    +-------+-----------+-----------+
    | A     | 0         | 3000      |
    | B     | 3001      | 5000      |
    | C     | 5001      | 8000      |
    +-------+-----------+-----------+

SELECT e.Name, e.Salary, s.Grade
FROM employees e
JOIN salary_grades s                                                 -->   THIS IS ACTUALLY INNER JOIN, with a condition
    ON e.Salary BETWEEN s.MinSalary AND s.MaxSalary;

OUTPUT:

    +------+--------+-------+
    | Name | Salary | Grade |
    +------+--------+-------+
    | John | 2500   | A     |
    | Emma | 4000   | B     |
    | Ravi | 7000   | C     |
    +------+--------+-------+

Salary is matched against the range in salary_grades.

===========================================================
IMPORTANT
===========================================================

EQUI / NON-EQUI are NOT separate JOIN types.

They describe the JOIN CONDITION:

    =                  → EQUI JOIN
    <, >, <=, >=,
    BETWEEN, etc.      → NON-EQUI JOIN

They can be used with INNER/OUTER joins.
