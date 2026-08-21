/**********************************************************************
                    Built-in Functions (MySQL)
**********************************************************************/

/*
Two Types

1. Scalar Functions
   - Work on one row at a time.
   - Return one value per row.

Examples:
UPPER(), LOWER(), LENGTH(), CONCAT(),
ABS(), ROUND(), GREATEST(),
CURRENT_DATE(), YEAR()

2. Aggregate Functions
   - Work on multiple rows.
   - Return one value per group/table.

Examples:
COUNT(), SUM(), AVG(), MIN(), MAX()

Remember:
Scalar    → One Row
Aggregate → Many Rows
*/

======================================================================
STRING FUNCTIONS
======================================================================

UPPER(str)      → Uppercase
LOWER(str)      → Lowercase
LENGTH(str)     → Length of string
TRIM(str)       → Remove leading/trailing spaces
SUBSTRING()     → Extract substring
CONCAT()        → Join strings

Examples

SELECT UPPER('atharva');         -- ATHARVA
SELECT LENGTH('Oracle');         -- 6
SELECT TRIM(' SQL ');            -- SQL
SELECT SUBSTRING('ORACLE',2,3);  -- RAC
SELECT CONCAT('Hello',' SQL');   -- Hello SQL

======================================================================
NUMERIC FUNCTIONS
======================================================================

ABS()       → Absolute value
ROUND()     → Round number
POWER()     → Exponent
MOD()       → Remainder
GREATEST()  → Largest value (same row)
LEAST()     → Smallest value (same row)

Examples

SELECT ABS(-15);              -- 15
SELECT ROUND(12.56);          -- 13
SELECT MOD(18,4);             -- 2
SELECT POWER(2,3);            -- 8
SELECT GREATEST(5,9,2);       -- 9

======================================================================
DATE FUNCTIONS
======================================================================

CURRENT_DATE()
CURRENT_TIME()
CURRENT_TIMESTAMP()
NOW()

YEAR()
MONTH()
DAY()

Examples

SELECT CURRENT_DATE();
SELECT NOW();
SELECT YEAR('2025-07-31');    -- 2025

======================================================================
AGGREGATE FUNCTIONS
======================================================================

COUNT()
SUM()
AVG()
MIN()
MAX()

Examples

SELECT COUNT(*) FROM emp;
SELECT SUM(salary) FROM emp;
SELECT AVG(salary) FROM emp;
SELECT MIN(salary) FROM emp;
SELECT MAX(salary) FROM emp;

======================================================================
Interview Questions
======================================================================

1. COUNT(*) vs COUNT(column)

COUNT(*)      → Counts all rows.
COUNT(column) → Ignores NULL values.

------------------------------------------------------------

2. GREATEST() vs MAX()

GREATEST()
- Scalar Function
- Compares values within ONE row

SELECT GREATEST(math, science, english)
FROM student;

MAX()
- Aggregate Function
- Finds maximum value across MANY rows

SELECT MAX(salary)
FROM emp;

Remember:
GREATEST → Row-wise
MAX      → Column-wise

/************************************* FUNCTION USED WHILE HANDLING NULL VALUES *********************************/


COALESCE() — SQL Function

- COALESCE() is a SQL function.
   It is available in MySQL also

Purpose:
   COALESCE() is mainly used to handle NULL values.

Basic syntax:
   COALESCE(value, replacement)

Example:
   SELECT COALESCE(salary, 0) AS salary FROM employees;

   - If salary is NOT NULL → return salary
   - If salary IS NULL → return 0

- COALESCE() can accept multiple values: COALESCE(salary, bonus, 0)
   It returns the FIRST value that is NOT NULL.

   Example:
   - salary = 50000 → returns 50000
   - salary = NULL, bonus = 5000 → returns 5000
   - salary = NULL, bonus = NULL → returns 0

- MySQL also has IFNULL():
   IFNULL(salary, 0)

   Both can handle this simple case.

   - COALESCE() → standard SQL, works across many databases
   - IFNULL() → MySQL-specific


/**********************************************************************/