/**********************************************************************
                            SQL Aliases
**********************************************************************/

Alias:
- A temporary name for a column or table.
- Exists only for the current query.
- Created using AS (optional in Standard SQL and MySQL both, but preferred as it improves readability).

Why use aliases?
- Improve readability.
- Shorten table names in joins.
- Rename calculated columns.

----------------------------------------------------------------------
Column Alias
----------------------------------------------------------------------

    SELECT PersonId AS PID
    FROM Persons;

    SELECT PersonId PID      -- AS is optional in standard SQL as well as MySQL
    FROM Persons;

Multiple aliases:

    SELECT PersonId AS PID,
        FirstName AS FName
    FROM Persons;

----------------------------------------------------------------------
Table Alias
----------------------------------------------------------------------

    SELECT p.PersonId, p.FirstName
    FROM Persons AS p;

    Useful when working with multiple tables (JOINs).

----------------------------------------------------------------------
Aliases with Spaces
----------------------------------------------------------------------

    SELECT PersonId AS `Person ID`,
        FirstName AS `First Name`
    FROM Persons;

    (MySQL uses backticks ` ` for identifiers with spaces. In Standard SQL, we use double quotes "")

----------------------------------------------------------------------
Concatenation
----------------------------------------------------------------------

    SELECT CONCAT(FirstName, ', ', LastName) AS FullName
    FROM Persons;

    Output

        +----------------+
        | FullName       |
        +----------------+
        | Nitish, Kumar  |
        | Raj, Thakre    |
        | Rahul, Dravid  |
        +----------------+

    Note:
        CONCAT() returns NULL if any argument is NULL.

----------------------------------------------------------------------
Constant Column
----------------------------------------------------------------------

SELECT 'Employee' AS Designation,
       name
FROM emp;

Output

+-------------+-------+
| Designation | name  |
+-------------+-------+
| Employee    | Emma  |
| Employee    | Ethan |
| Employee    | Liam  |
+-------------+-------+

Here: 
- 'Employee' is a constant expression.
- The column exists only in the query output, not in the table.

-- Other examples of constant columns

SELECT 2025 AS Year, ProductName
FROM Products;

SELECT TRUE AS IsActive, username
FROM Users;

/**********************************************************************/