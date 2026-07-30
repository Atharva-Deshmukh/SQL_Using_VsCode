/**********************************************************************
                            WHERE Clause
**********************************************************************/

Purpose:
- Filters rows based on a condition.
- Used with SELECT, UPDATE and DELETE.

Use single quotes (' ') for string values.

----------------------------------------------------------------------
Comparison Operators
----------------------------------------------------------------------

=    Equal
<>   Not Equal
<    Less Than
<=   Less Than or Equal
>    Greater Than
>=   Greater Than or Equal

Examples:

SELECT * FROM Persons WHERE City = 'Bihar';
SELECT * FROM Persons WHERE City <> 'Bihar';
SELECT * FROM Persons WHERE PersonID >= 3;

----------------------------------------------------------------------
NULL
----------------------------------------------------------------------

NULL = Unknown

❌ Incorrect

SELECT * FROM Persons WHERE Address = NULL;

✅ Correct

SELECT * FROM Persons WHERE Address IS NULL;
SELECT * FROM Persons WHERE Address IS NOT NULL;

----------------------------------------------------------------------
Common Conditions
----------------------------------------------------------------------

BETWEEN

SELECT * FROM Persons
WHERE PersonID BETWEEN 3 AND 6;

IN

SELECT * FROM Persons
WHERE PersonID IN (1,4);

LIKE (Wildcards)

%  → Zero or more characters
_  → Exactly one character

SELECT * FROM Persons
WHERE FirstName LIKE 'R%';

REGEXP

SELECT * FROM Persons
WHERE FirstName REGEXP '^R.*j$';

----------------------------------------------------------------------
DISTINCT
----------------------------------------------------------------------

Returns unique values.

SELECT DISTINCT PersonID
FROM Persons;

DISTINCT applies to all selected columns.

SELECT DISTINCT *
FROM Persons;

Remember:
DISTINCT removes duplicate rows from the selected columns only.

/**********************************************************************/