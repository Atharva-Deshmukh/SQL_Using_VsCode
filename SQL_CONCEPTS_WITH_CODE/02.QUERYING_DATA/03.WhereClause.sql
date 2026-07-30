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

NULL is not a value — it means "unknown" or "missing".
Because of that, SQL cannot determine whether two unknowns are equal.

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

IN -- a shorthand for multiple OR conditions.

    SELECT * FROM Persons
    WHERE PersonID IN (1,4);

    -- Equivalent to 

    SELECT *
    FROM Persons
    WHERE PersonID = 1
    OR PersonID = 4;

LIKE (Wildcards)  -- Wildcard = simple pattern matching  WHEREAS Regular Expressions = Advanced Pattern matching

    %  → Zero or more characters
    _  → Exactly one character

    SELECT * FROM Persons
    WHERE FirstName LIKE 'R%';

    -- Some more examples
    LIKE 'R%'     → Starts with R
    LIKE '%i'     → Ends with i
    LIKE '%ah%'   → Contains "ah"
    LIKE 'R__'    → R followed by exactly 2 characters

Regular Expressions (REGEXP)

    ^     → Start of string
    $     → End of string
    .     → Any single character
    *     → Zero or more of previous character
    +     → One or more of previous character
    []    → Character set
    |     → OR

    SELECT * FROM Persons
    WHERE FirstName REGEXP '^R.*j$';

    -- Some more examples
    REGEXP '^R'        → Starts with R
    REGEXP 'i$'        → Ends with i
    REGEXP 'ah'        → Contains "ah"
    REGEXP '^R...$'    → Exactly 4 characters starting with R
    REGEXP '^R.*j$'    → Starts with R and ends with j

----------------------------------------------------------------------
DISTINCT
----------------------------------------------------------------------

Returns unique values.

    Example Table

    +----------+-----------+---------+
    | PersonID | FirstName | City    |
    +----------+-----------+---------+
    | 1        | Raj       | Pune    |
    | 2        | Amit      | Mumbai  |
    | 2        | Amit      | Mumbai  |
    | 2        | Amit      | Delhi   |
    | 3        | Neha      | Pune    |
    +----------+-----------+---------+

----------------------------------------------------------------------
1. DISTINCT on Single Column
----------------------------------------------------------------------

    SELECT DISTINCT PersonID
    FROM Persons;

    Output

    +----------+
    | PersonID |
    +----------+
    | 1        |
    | 2        |
    | 3        |
    +----------+

    Only unique PersonID values are returned.

----------------------------------------------------------------------
2. DISTINCT on Multiple Columns
----------------------------------------------------------------------

    SELECT DISTINCT PersonID, FirstName
    FROM Persons;

    Output

    +----------+-----------+
    | PersonID | FirstName |
    +----------+-----------+
    | 1        | Raj       |
    | 2        | Amit      |
    | 3        | Neha      |
    +----------+-----------+

    Duplicate (PersonID, FirstName) pairs are removed.

----------------------------------------------------------------------
3. DISTINCT *
----------------------------------------------------------------------

    SELECT DISTINCT *
    FROM Persons;

    Output

    +----------+-----------+---------+
    | PersonID | FirstName | City    |
    +----------+-----------+---------+
    | 1        | Raj       | Pune    |
    | 2        | Amit      | Mumbai  |
    | 2        | Amit      | Delhi   |
    | 3        | Neha      | Pune    |
    +----------+-----------+---------+

    Only the completely identical row
    (2, Amit, Mumbai) is removed.

Remember:
- DISTINCT compares all selected columns.
- Two rows are duplicates only if every selected column matches.

/**********************************************************************/