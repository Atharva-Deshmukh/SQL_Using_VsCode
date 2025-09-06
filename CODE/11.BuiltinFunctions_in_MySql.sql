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
