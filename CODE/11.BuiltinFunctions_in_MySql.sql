-- There are two types of built-in functions in MySQL:
/*
Feature      | Scalar Functions                  | Aggregate Functions
-------------|----------------------------------|---------------------------------------------
Input        | Single value (per row)            | Set of values (multiple rows)
Output       | One result per row                | One result per group or table
Usage        | In SELECT, WHERE, ORDER BY        | In SELECT (with or without GROUP BY)
Examples     | UPPER(), ROUND(), CURDATE()       | COUNT(), SUM(), AVG(), MAX(), MIN()

🔹 Scalar vs Aggregate Reminder

Scalar functions: Work on values in a single row and return a result for that row.
Aggregate functions: Work on values across multiple rows (a set) and return one result per set/group.

🔹 GREATEST() and LEAST()

They take multiple arguments, but all arguments come from the same row.
The function then compares those arguments and returns a single value (max/min of those arguments).
They do not look at other rows in the table.

So even though GREATEST()/LEAST() accept multiple arguments, they are still scalar because 
all comparisons happen within one row.

Other scalar functions:

String: CONCAT(), LOWER(), SUBSTRING()
Numeric: ABS(), ROUND(), POWER()
Date/Time: CURDATE(), NOW(), DAYNAME()
*/
                            
                            
                            /* STRING FUNCTIONS */

----------------------------------- CASE RELATED ------------------------------------------------------

/* OUTPUT: in the result grid
     
     UPPER('Atharva')
---|-----------------
   | ATHARVA

*/
SELECT UPPER('Atharva');  -- Converts text to uppercase | ANSI SQL standard | Prefer this for future
SELECT UCASE('Atharva');  -- MySQL specific

-- Similarly, in table, we can use these commands

SELECT UPPER(Name) FROM studenttable;
/* OUTPUT: in the result grid
     
     UPPER('Name')
---|-----------------
   | AGASTYA
   | DEVRATH
   | PARSHURAM

*/

-- LOWER CASE
SELECT LOWER(Address) FROM studenttable;

----------------------------------------------------------------------------------------------------

SELECT LENGTH('Atharva'); 
/* OUTPUT: in the result grid
     
     LENGTH('Atharva')
---|-----------------
   | 7

*/

SELECT LENGTH(Name) FROM studenttable; 
/* OUTPUT: in the result grid
     
     LENGTH('Name')
---|-----------------
   | 7
   | 7
   | 9

*/

-- QUESTION: Select all the rows whose names have length >= 6

SELECT * FROM studenttable WHERE LENGTH(Name) >= 6; -- All required rows are fetched

----------------------------------------------------------------------------------------------------

-- TRIM(): removes spaces from the start and end of a string
SELECT TRIM('        Atharva Deshmukh         ');

-- TRIM/REMOVE a specific character from start and end of a string
SELECT TRIM('A' FROM 'AAAAAtharva AAA DeshmukhAAAAA'); -- This is case sensitive, 'A' and 'a' are different
-- O/P => 'tharva AAA Deshmukh'

----------------------------------------------------------------------------------------------------
-- INSTR(): Returns the position of character/substring in a string

SELECT INSTR('ADOBE', 'O'); -- O/P => 3

SELECT INSTR('ATHARVA DESHMUKH', 'UKH'); -- O/P => 14
SELECT INSTR('ATHARVA DESHMUKH', 'k'); -- O/P => 15 CASE INSENSTITIVE

----------------------------------------------------------------------------------------------------

-- SUBSTR(): Extracts a substring from a string

-- Syntax -->  SUBSTR(string, start, length)
SELECT SUBSTR('ORACLE', 2, 3); -- RAC
SELECT SUBSTR('ORACLE', 3, 3); -- ACL
SELECT SUBSTR('ORACLE', 6, 3); -- E, since string ends
SELECT SUBSTR('ORACLE', 7, 3); -- EMPTY, since string ends at 6

-- SUBSTRING(): Extracts a substring from a string

-- Syntax -->  SUBSTRING(string, start, length)
SELECT SUBSTRING('ORACLE', 2, 3); -- RAC
SELECT SUBSTRING('ORACLE', 3, 3); -- ACL
SELECT SUBSTRING('ORACLE', 6, 3); -- E, since string ends
SELECT SUBSTRING('ORACLE', 7, 3); -- EMPTY, since string ends at 6

----------------------------------------------------------------------------------------------------

-- The CONCAT() function adds two or more expressions together.
-- Syntax -->  CONCAT(expression1, expression2, expression3,...)
SELECT CONCAT('A B C', '_PQR', 'S'); -- O/P: A B C_PQRS

----------------------------------------------------------------------------------------------------

-- The CONCAT_WS() function adds two or more expressions together with a separator.
-- Required. The separator to add between each of the expressions. 
-- If separator is NULL, this function returns NULL

SELECT CONCAT_WS('-', 'ABC', 'PQR', 'STU'); -- O/P: 'ABC-PQR-STU'

SELECT CONCAT_WS('-', Name, Address) FROM studenttable;
/* OUTPUT:

CONCAT_WS('-', Name, Address)
   'Agastya-Himalaya'
   'Devrath-Hastinapur'
   'Parshuram-Mahendragiri'
   'Drone-Hastinapur'

*/

                            /* NUMBER FUNCTIONS */

-----------------------------------------------------------------------------------------

-- ABS() - Return the absolute value of a number

SELECT ABS(-45.6); -- O/P: 45.6
-----------------------------------------------------------------------------------------

-- SQRT() - Return the square root of a number
--        - Returns NULL if the number is negative

SELECT SQRT(16); -- O/P: 4
SELECT SQRT(-25); -- O/P: NULL
-----------------------------------------------------------------------------------------

SELECT MOD(18, 4); -- O/P: 2
SELECT 18 % 4;  -- O/P: 2
SELECT 18 MOD 4;  -- O/P: 2
-----------------------------------------------------------------------------------------

SELECT POWER(4, 2);  -- O/P: 16
SELECT POW(4, 2);  -- O/P: 16
-----------------------------------------------------------------------------------------

-- The TRUNCATE() function truncates a number to the specified number of decimal places.

SELECT TRUNCATE(40.9234, 0);  -- O/P: 40
SELECT TRUNCATE(40.1234, 3);  -- O/P: 40.123
SELECT TRUNCATE(40.1234, 2);  -- O/P: 40.12
SELECT TRUNCATE(6876, -1);    -- O/P: 6870
SELECT TRUNCATE(6876, -2);  -- O/P: 6800
SELECT TRUNCATE(68763456, -5);  -- O/P: 68700000
-----------------------------------------------------------------------------------------

/*

| Feature       | GREATEST()                               | MAX()                                  |
|---------------|------------------------------------------|----------------------------------------|
| Scope         | Compares multiple values in one row      | Compares one column across many rows   |
| Type          | Scalar function (row-level)              | Aggregate function (set-level)         |
| NULL handling | Returns NULL if any argument is NULL     | Ignores NULLs by default               |
| Usage         | `SELECT GREATEST(col1, col2, col3)`      | `SELECT MAX(col1) FROM table`          |
| Standard      | SQL extension (not in all RDBMS)         | ANSI SQL standard (in all RDBMS)       |

*/

SELECT GREATEST(3, 12, -34, 8, 25); -- 25
SELECT GREATEST('AKOLA', 'MUMBAI', 'MAHIM'); -- MUMBAI - Picks lexicographically greatest value
SELECT GREATEST(W_Id, W_Address, W_Age) FROM wtable; -- 'Hastinapur'
SELECT GREATEST(W_Id, W_Address, W_Age, Gender) FROM wtable; -- Returns null if any value in the row is null, compares row by row


SELECT MAX(Gender) FROM wtable; -- 'M', It ignores null values
SELECT MAX(W_Id) FROM wtable; -- 6 - Pics Max Value in a column

-----------------------------------------------------------------------------------------

/*

| Feature           | LEAST()                                   | MIN()                                   |
|-------------------|-------------------------------------------|-----------------------------------------|
| **Scope**         | Compares multiple values in one row       | Compares one column across many rows    |
| **Type**          | Scalar function (row-level)               | Aggregate function (set-level)          |
| **NULL handling** | Returns NULL if any argument is NULL      | Ignores NULLs by default                |
| **Usage**         | `SELECT LEAST(col1, col2, col3)`          | `SELECT MIN(col1) FROM table`           |
| **Standard**      | SQL extension (not in all RDBMS)          | ANSI SQL standard (in all RDBMS)        |

*/

SELECT LEAST(3, 12, -34, 8, 25); -- -34
SELECT LEAST(W_Id, W_Address, W_Age) FROM wtable; -- 4


                            /* DATE and TIME RELATED FUNCTIONS */

-----------------------------------------------------------------------------------------

-- CURRDATE() and CURRENT_DATE(): Returns the current date
-- The date is returned as "YYYY-MM-DD" (string) or as YYYYMMDD (numeric).

/*
No difference in output.
CURRENT_DATE is the SQL standard form.
CURDATE() is MySQL’s shorter alias.
*/

SELECT CURRENT_DATE(); -- O/P: '2025-09-06'
SELECT CURRENT_DATE() + 1; -- O/P: 20250907 -- Output is numberic
SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 1 DAY);-- '2025-09-07' This will add and give date in proper format

-----------------------------------------------------------------------------------------

-- The time is returned as "HH-MM-SS" (string) or as HHMMSS.uuuuuu (numeric).
SELECT CURRENT_TIME(); -- O/P: '15:11:42'
SELECT DATE_ADD(CURRENT_TIME(), INTERVAL 1 HOUR); -- ADD 1 hour O/P: '16:13:45'
SELECT DATE_ADD(CURRENT_TIME(), INTERVAL 1 MINUTE); -- ADD 1 minute O/P: '15:14:30'
SELECT DATE_ADD(CURRENT_TIME(), INTERVAL 1 SECOND); -- ADD 1 second O/P: '15:13:56'

-----------------------------------------------------------------------------------------

-- Current timestamp: The date and time is returned as "YYYY-MM-DD HH-MM-SS" (string) or as YYYYMMDDHHMMSS.uuuuuu (numeric).

SELECT CURRENT_TIMESTAMP(); -- O/P: '2025-09-06 15:15:22'

-----------------------------------------------------------------------------------------

-- NOW(): 
-- The NOW() function returns the current date and time.
-- Note: The date and time is returned as "YYYY-MM-DD HH-MM-SS" (string) or as YYYYMMDDHHMMSS.uuuuuu (numeric).

SELECT NOW(); -- O/P: '2025-09-06 15:17:38'
-- The SYSDATE() function too returns the current date and time.

-----------------------------------------------------------------------------------------
-- The DAY() function returns the day of the month for a given date (a number from 1 to 31).
-- Parameter: The date to extract the day from

SELECT DAY("2017-06-15"); -- '15'

-----------------------------------------------------------------------------------------
-- The MONTH() function returns the month part for a given date (a number from 1 to 12).
-- Parameter: The date to extract the month from

SELECT MONTH("2017-06-15"); -- '6'
-----------------------------------------------------------------------------------------
-- The YEAR() function returns the year part for a given date (a number from 1000 to 9999).
-- Parameter: The date to extract the year from

SELECT YEAR("2017-06-15"); -- '2017'
-----------------------------------------------------------------------------------------

-- QUESTION

-- Display employees who are joined in 1987

SELECT * FROM employee_table WHERE YEAR(HIRE_DATE) = '1987';

-- Display employees who joined in June month

SELECT * FROM employee_table WHERE MONTH(HIRE_DATE) = 6;
SELECT * FROM employee_table WHERE MONTHNAME(HIRE_DATE) = 'JUNE';

---------------------------------AGGREGATE FUNCTIONS-------------------------------------------

-- MIN() and MAX() already done above with GREATEST() and LEAST()

-- The COUNT() function returns the number of records returned by a select query.
-- Note: NULL values are not counted.

SELECT COUNT(W_Address) FROM wtable; -- 5
SELECT COUNT(GENDER) FROM wtable; -- 1 -- DOES NOT COUNT NULL

SELECT COUNT(*) FROM wtable; -- 5
-- COUNT(*) counts all rows in the table.
-- It does not care if there are NULLs or what values are inside.
-----------------------------------------------------------------------------------------------

-- The SUM() function calculates the sum of a set of values.
-- Note: NULL values are ignored.
-- Parameter:  A field or a formula

SELECT SUM(W_Id) FROM wtable; -- 22 => Sum of all the Ids
SELECT SUM(W_Name) FROM wtable; -- 0 => if everything is a string
SELECT SUM(Gender) FROM wtable; -- 0 => if everything is a string or null

-----------------------------------------------------------------------------------------------

-- The AVG() function returns the average value of an expression.
-- Note: NULL values are ignored. 
-- Parameter: A numeric value (can be a field or a formula)

SELECT AVG(W_Id) FROM wtable; -- 5.5 => Average of all the Ids
SELECT AVG(W_Name) FROM wtable; -- 0 => if everything is a string
SELECT AVG(Gender) FROM wtable; -- 0 => if everything is a string or null

