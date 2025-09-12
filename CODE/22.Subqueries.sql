/* A subquery in SQL is a query nested inside another SQL query. It allows complex filtering, 
aggregation and data manipulation by using the result of one query inside another. 

Inner/nested query is executed first, its results are then used in the outer query

While there is no universal syntax for subqueries, they are commonly used in SELECT statements as follows.

Syntax:
    SELECT column_name
    FROM table_name
    WHERE column_name expression operator 
    (SELECT column_name FROM table_name WHERE ...);

                                        Rules to write a subquery:
                                        --------------------------
- Subqueries must be enclosed within parentheses.
- Subqueries can be nested within another subquery.
- A subquery must contain the SELECT query and the FROM clause always.
- A subquery consists of all the clauses an ordinary SELECT clause can contain: 
  GROUP BY, WHERE, HAVING, DISTINCT, TOP/LIMIT, etc. 
- Subqueries cannot manipulate their results internally, therefore ORDER BY clause cannot be added into a 
  subquery. You can use an ORDER BY clause in the main SELECT statement (outer query) 
  which will be the last clause.
- If a subquery (inner query) returns a null value to the outer query, the outer query will not return 
  any rows when using certain comparison operators in a WHERE clause.


                                        Type of Subqueries
                                        ------------------

- Scalar Subquery: Returns a single value.
- Column Subquery: Returns a single column of values
- Multiple column subqueries : Returns one or more columns.
- Single row subquery : Returns a single row of values.
- Multiple row subquery : Returns one or more rows.
- Table Subquery: Returns a result set that can be treated as a table
- Correlated subqueries : Reference one or more columns in the outer SQL statement.
  The subquery is known as a correlated subquery because the subquery is related to the outer SQL statement.
- Nested subqueries : Subqueries are placed within another subquery.
*/


/*                                     Subquery with WHERE clause 
                                        --------------------------


                                                    TABLE USED:
                                    +----+----------+-----+-----------+----------+
                                    | ID | NAME     | AGE | ADDRESS   | SALARY   |
                                    +----+----------+-----+-----------+----------+
                                    |  1 | Ramesh   |  32 | Ahmedabad |  2000.00 |
                                    |  2 | Khilan   |  25 | Delhi     |  1500.00 |
                                    |  3 | Kaushik  |  23 | Kota      |  2000.00 |
                                    |  4 | Chaitali |  25 | Mumbai    |  6500.00 |
                                    |  5 | Hardik   |  27 | Bhopal    |  8500.00 |
                                    |  6 | Komal    |  22 | Hyderabad |  4500.00 |
                                    |  7 | Muffy    |  24 | Indore    | 10000.00 |
                                    +----+----------+-----+-----------+----------+  */

SELECT * FROM CUSTOMERS 
WHERE ID IN (SELECT ID FROM CUSTOMERS WHERE SALARY > 4500);

/* OUTPUT:
# ID	NAME	    AGE	    ADDRESS	    SALARY
----------------------------------------------
    4	Chaitali	25	    Mumbai	    6500.00
    5	Hardik	    27	    Bhopal	    8500.00
    7	Muffy	    24	    Indore	    10000.00  */


                                    /* Subquery with FROM clause */

SELECT *
FROM (SELECT NAME, SALARY FROM customers WHERE salary > 5000);
/*Output: Error: Every derived table must have its own alias
  The inner query returns a table, we should have some name to that table, hence we alias it
  Either don't quote the ALIAS or use `` */

SELECT subquery_table.NAME, subquery_table.SALARY
FROM (SELECT NAME, SALARY FROM customers WHERE salary > 5000) AS `subquery_table`;
/* OUTPUT:
#   NAME	    SALARY
-------------------------
    Chaitali	6500.00
    Hardik	    8500.00
    Muffy	    10000.00 */

                                 /* Subquery with SELECT clause */

-- Find customers whose salary is greater than the average salary of all customers.
SELECT NAME, SALARY, (SELECT AVG(SALARY) FROM customers) 
AS overall_avg_salary
FROM customers;

/* OUTPUT:

#   NAME	SALARY	    overall_avg_salary
-------------------------------------------
    Ramesh	2000.00	    5000.000000
    Khilan	1500.00	    5000.000000
    Kaushik	2000.00	    5000.000000
    Chaitali6500.00	    5000.000000
    Hardik	8500.00	    5000.000000
    Komal	4500.00	    5000.000000
    Muffy	10000.00	5000.000000 */

                                     /* Subquery with HAVING clause */

-- Group customers by AGE and keep only groups where the average salary of that age 
-- group is higher than the overall average salary.

SELECT AGE, AVG(SALARY) AS avg_salary
FROM customers
GROUP BY AGE
HAVING AVG(SALARY) > (SELECT AVG(SALARY) FROM customers);

/* OUTPUT:

#   AGE	avg_salary
---------------------
    27	8500.000000
    24	10000.000000 */

                                         /* Subquery with INSERT statement */

-- Suppose we want to insert a new row with the highest salary holder’s salary + 1000 as the new salary.

/* MySQL prevents a statement from modifying a table and also selecting from that same table in a nested subquery 
(the engine blocks it to avoid ambiguous evaluation). Hence this fails */
INSERT INTO customers (ID, NAME, AGE, ADDRESS, SALARY)
VALUES (8, 'NewGuy', 30, 'Pune', (SELECT MAX(SALARY) + 1000 FROM customers)
);

-- Fix: — easiest: use a user variable (two statements)
SET @maxsal = (SELECT MAX(SALARY) FROM customers);

/*
INSERT → subquery in VALUES or INSERT ... SELECT.
UPDATE → subquery can be used in both SET and WHERE.
DELETE → subquery is meaningful only in WHERE. */

                                         /* Subquery with UPDATE statement */

UPDATE customers
SET SALARY = SALARY + 500
WHERE SALARY = (SELECT MIN(SALARY) FROM customers);


                                         /* Subquery with DELETE statement */

DELETE FROM customers
WHERE SALARY < (SELECT AVG(SALARY) FROM customers);

---------------------------------------------------------------------------------------------------
                                         
/* Scalar subquery -> It returns a single value */

SELECT NAME
FROM customers
WHERE SALARY = (SELECT MAX(salary) FROM customers);

/* OUTPUT: NewGuy */

/* Column subquery -> Returns a single column of values */

SELECT NAME
FROM customers
WHERE SALARY > (SELECT AVG(salary) FROM customers);

/* OUTPUT: 
    # NAME
    Chaitali
    Hardik
    Muffy
    NewGuy */

/* Single Row Subquery: Returns a single row of values. */

SELECT *
FROM customers
WHERE SALARY = (SELECT MAX(salary) FROM customers);

/* OUTPUT: 

# ID	NAME	AGE	ADDRESS	SALARY
8	NewGuy	30	Pune	11000.00 */


--------------------------------------IMPORTANT FOR INTERVIEWS--------------------------------

/* Non-correlated subqueries
------------------------------

    The inner subquery do not depend on the outer query
    It does not refer to any column of the outer query
    The subquery is calculated just once, and reused for iterations for the outer query.
    Here in the ex: computes the average salary for the whole table, and compares each employee’s 
    salary to that value. */

SELECT first_name
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);


/* Correlated subqueries
-------------------------
  Depends on the outer query and is executed for each row processed by the outer query.

  Unlike a regular (non-correlated) subquery, it is evaluated once for every row in the outer query. 
  This makes correlated subqueries dynamic and highly useful for solving complex database problems 
  like row-by-row comparisons, filtering, and conditional updates.
*/

SELECT e1.first_name
FROM employees e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);

/*
Now the subquery refers to e1.department_id, which comes from the outer row.
That makes it a correlated subquery.
For each employee (e1), the inner query recomputes the average salary just for that employee’s department.

What matters: Does the inner query reference an outer row’s attribute?
Doesn't matter whether the table is same

If yes → correlated.
If no → non-correlated. */



