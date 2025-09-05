/*
SQL aliases are used to give a table, or a column in a table, a temporary name.
Aliases are often used to make column names more readable.

An alias only exists for the duration of that query.

An alias is created with the AS keyword.
AS keyword is optional in some DBs including MySQL.
But I will give AS keyword for better readability.


USE OF ALIAS:
It might seem useless to use aliases on tables, but when you are using more than one 
table in your queries, it can make the SQL statements shorter.

SELECT o.OrderID, o.OrderDate, c.CustomerName
FROM Customers AS c, Orders AS o
WHERE c.CustomerName='Around the Horn' AND c.CustomerID=o.CustomerID;

- There are more than one table involved in a query
- Functions are used in the query
- Column names are big or not very readable
- Two or more columns are combined together */

use myDB;
SELECT PersonId AS PID FROM Persons;          -- USING AS KEYWORD
SELECT PersonId PID_NO_AS FROM Persons;       -- WITHOUT USING AS KEYWORD

-- MULTIPLE ALIASES
SELECT PersonId AS PID, FirstName AS FName FROM Persons;

/* Using Aliases With a Space Character
If you want your alias to contain one or more spaces, like "My Great Products", 
surround your alias with [], '', "", OR `` 

Note: Some database systems allows both [] and "", and some only allows one of them.

[] is not allowed in MySQL */

SELECT PersonId AS "P I D", FirstName AS `F Name`, LastName AS 'L Name' FROM Persons;

-- ----------------------------------------------------------------------------------------------
-- CONCATENATION

SELECT PersonId, CONCAT(FirstName, ', ', LastName) AS ConcatenatedCols FROM Persons;

/* Output

PersonId | ConcatenatedCols
---------------------------
1        | Nitish, Kumar
2        | Raj, Thakre
3        | Rahul, Dravid  */

-- RULE: If any argument is NULL, then the entire result is NULL.
SELECT PersonId, CONCAT(FirstName, ', ', LastName, ', ' , Address, ', ', City) AS ConcatenatedCols FROM Persons;

/* Output

PersonId | ConcatenatedCols
---------------------------
1        | Nitish, Kumar, B-Lane, Pune
2        | NULL
3        | NULL  */

