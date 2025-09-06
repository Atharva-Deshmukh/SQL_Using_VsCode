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



