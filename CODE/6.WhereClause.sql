/* The WHERE clause is used to filter records.

It is used to extract only those records that fulfill a specified condition.

Note: The WHERE clause is not only used in SELECT statements, it is also used in UPDATE, DELETE

ALWAYS use single quotes ( ' ) around string values in the WHERE clause.
"" and `` are used as column or table identifiers.  */

SELECT * FROM Persons WHERE City <> 'Bihar'; -- its !==
SELECT * FROM Persons WHERE City = 'Bihar';
SELECT * FROM Persons WHERE PersonID < 3;
SELECT * FROM Persons WHERE PersonID <= 3;
SELECT * FROM Persons WHERE PersonID > 3;
SELECT * FROM Persons WHERE PersonID >= 3;
SELECT * FROM Persons WHERE FirstName = 'Raj';

-- This query doesn’t output anything because Address = NULL is always unknown, never true.
-- Because in SQL, NULL means unknown.
-- Any comparison with NULL (= NULL, <> NULL, etc.) is also unknown, not true.
SELECT * FROM Persons WHERE Address = NULL;

-- Correct way
SELECT * FROM Persons WHERE Address is null;
SELECT * FROM Persons WHERE Address is not null;

SELECT * FROM Persons WHERE PersonID BETWEEN 3 and 6;

 -- Chooses any value from the options
SELECT * FROM Persons WHERE PersonID IN (1, 4); 
SELECT * FROM Persons WHERE Address IN ('Kothrud', 'B-Lane'); 

-- LIKE uses wildcard, not regex
-- Wildcards
-- % → any sequence of characters (0 or more)
-- _ → exactly one character
SELECT * FROM Persons WHERE FirstName LIKE 'R%';  -- All firstnames starting with 'R'
SELECT * FROM Persons WHERE FirstName LIKE 'R_';  -- NO MATCH since we needed something only of two letters, no entry is of 2 letters

-- Matches using regexp, any word that starts with R and ends with J
SELECT * FROM Persons WHERE FirstName REGEXP '^r.*j$'; 

