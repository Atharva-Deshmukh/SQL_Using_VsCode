/*
===========================================================
SUBQUERIES
===========================================================

SUBQUERY
→ Query inside another query.
→ Inner query provides a value/result to the outer query.

Basic flow:

      Subquery result
          ↓
      Outer Query uses result

===========================================================
1. SUBQUERY WITH WHERE
===========================================================

Find customers whose salary > 4500:

  SELECT * FROM Customers
  WHERE ID IN (
      SELECT ID
      FROM Customers
      WHERE Salary > 4500
  );

OUTPUT:
  +----+----------+------+-----------+--------+
  | ID | NAME     | AGE  | ADDRESS   | SALARY |
  +----+----------+------+-----------+--------+
  | 4  | Chaitali | 25   | Mumbai    | 6500   |
  | 5  | Hardik   | 27   | Bhopal    | 8500   |
  | 7  | Muffy    | 24   | Indore    | 10000  |
  +----+----------+------+-----------+--------+

===========================================================
2. SUBQUERY WITH FROM
===========================================================

Subquery in FROM → derived table.

This fails:

  SELECT *
  FROM (
      SELECT NAME, SALARY
      FROM Customers
      WHERE Salary > 5000
  );

→ Derived table must have an alias.

Correct:

  SELECT sub.NAME, sub.SALARY
  FROM (
      SELECT NAME, SALARY
      FROM Customers
      WHERE Salary > 5000
  ) AS sub;

OUTPUT:
  +----------+--------+
  | NAME     | SALARY |
  +----------+--------+
  | Chaitali | 6500   |
  | Hardik   | 8500   |
  | Muffy    | 10000  |
  +----------+--------+

===========================================================
3. SUBQUERY WITH SELECT
===========================================================

Find each employee's salary + overall average salary:

  SELECT NAME, SALARY,
        (SELECT AVG(SALARY) FROM Customers) AS overall_avg
  FROM Customers;

OUTPUT:
  +----------+--------+-------------+
  | NAME     | SALARY | overall_avg |
  +----------+--------+-------------+
  | Ramesh   | 2000   | 5000        |
  | Khilan   | 1500   | 5000        |
  | Kaushik  | 2000   | 5000        |
  | Chaitali | 6500   | 5000        |
  | Hardik   | 8500   | 5000        |
  | Komal    | 4500   | 5000        |
  | Muffy    | 10000  | 5000        |
  +----------+--------+-------------+

===========================================================
4. SUBQUERY WITH HAVING
===========================================================

Find age groups whose average salary > overall average:

  SELECT AGE, AVG(SALARY) AS avg_salary 
  FROM Customers
  GROUP BY AGE
  HAVING AVG(SALARY) > (SELECT AVG(SALARY) FROM Customers);

OUTPUT:
  +-----+------------+
  | AGE | avg_salary |
  +-----+------------+
  | 27  | 8500       |
  | 24  | 10000      |
  +-----+------------+

===========================================================
5. SUBQUERY WITH UPDATE / DELETE
===========================================================

UPDATE:

  UPDATE Customers
  SET SALARY = SALARY + 500
  WHERE SALARY = (SELECT MIN(SALARY) FROM Customers );

  → Updates employee(s) having the minimum salary.

DELETE:

  DELETE FROM Customers
  WHERE SALARY < (SELECT AVG(SALARY) FROM Customers);

  → Deletes employee(s) below overall average salary.

===========================================================
6. SUBQUERY TYPES — INTERVIEW RELEVANT
===========================================================

SCALAR SUBQUERY
→ Returns ONE value.

SELECT NAME 
FROM Customers
WHERE SALARY = (SELECT MAX(SALARY)FROM Customers);

OUTPUT:

+------+
| NAME |
+------+
| Muffy |
+------+

COLUMN SUBQUERY
→ Returns ONE column, potentially multiple rows.

SELECT NAME
FROM Customers
WHERE SALARY > (
    SELECT AVG(SALARY)
    FROM Customers
);

→ Inner query returns one value here, so this is also scalar.

MEMORY:
→ Scalar = one value
→ Column = one column, possibly many values
→ Row/Table = multiple columns/rows

===========================================================
7. NON-CORRELATED SUBQUERY
===========================================================

Inner query does NOT reference the outer query.

SELECT first_name
FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

Flow:

  Outer row
    ↓
  Compare with ONE overall average
    ↓
  Return matching rows

KEY:
→ Inner query does NOT use outer query columns.

===========================================================
8. CORRELATED SUBQUERY
===========================================================

Inner query REFERENCES the outer query.

SELECT e1.first_name
FROM Employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM Employees e2
    WHERE e2.department_id = e1.department_id
);

Flow:

  Employee e1
      ↓
  Find average salary of e1's department
      ↓
  Compare e1.salary with that average
      ↓
  Repeat for each outer row

IMPORTANT:
→ Same table can be used in both queries.
→ What matters is whether the inner query references
  a column from the outer query.
