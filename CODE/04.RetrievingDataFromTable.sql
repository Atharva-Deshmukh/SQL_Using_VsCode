/**********************************************************************
                            SELECT Command
**********************************************************************/

-- 1. Select all columns
USE myDB;

SELECT * FROM Persons;

-- Output
+----------+-----------+----------+
| PersonID | FirstName | Address  |
+----------+-----------+----------+
| 1        | Alice     | Delhi    |
| 2        | Bob       | Mumbai   |
+----------+-----------+----------+

-----------------------------------------------------------------------

-- 2. Select specific columns

SELECT FirstName, Address
FROM Persons;

-- Output
+-----------+----------+
| FirstName | Address  |
+-----------+----------+
| Alice     | Delhi    |
| Bob       | Mumbai   |
+-----------+----------+

-----------------------------------------------------------------------

-- 3. Expressions in SELECT --> We can do some modifications in select query itself

SELECT PersonID + 100 AS NewID
FROM Persons;

-- Output
+-------+
| NewID |
+-------+
| 101   |
| 102   |
+-------+

/**********************************************************************
                    SELECT vs DESCRIBE
**********************************************************************/

DESCRIBE Persons;

-- Shows table structure (metadata):
-- Column names, data types, keys, NULL, default values, etc.

Example:

+----------+-------------+------+-----+
| Field    | Type        | Null | Key |
+----------+-------------+------+-----+
| PersonID | int         | NO   | PRI |
| FirstName| varchar(50) | YES  |     |
| Address  | varchar(50) | YES  |     |
+----------+-------------+------+-----+


DESCRIBE → Shows table structure (metadata)
           Its not any standard, its just MySQL specific shortcut
           Works on Table Schema

SELECT   → Retrieves data from a table
           Its a SQL standard
           Works on Table data

/**********************************************************************/