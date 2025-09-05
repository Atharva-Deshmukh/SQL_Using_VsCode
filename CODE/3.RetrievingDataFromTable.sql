/* Select Command can be used in multiple ways*/ 

-- Way-1: Select all columns from the table
use myDB;
SELECT * FROM Persons;

-- WAY -2: Select specific columns from the table
SELECT FirstName, Address FROM Persons;

-- ----------------------------------------------------------------------------------------
-- If you want to increase values of a column by some number we can do that in select only

use myDB;
SELECT PersonID + 100 FROM Persons;
-- This will add 100 to all values in PersonID column and show the result

-- -------------------------SELECT Vs DESCRIBE--------------------------------------------  

                                    DESCRIBE student;

Shows the structure (schema) of the table.

Its not a DDL, DQL, DCL, TCL or a DML.

It’s a metadata query command (in MySQL and some other DBs), often 
considered part of DQL, but not officially classified in standard SQL.

Output includes:
- Column names
- Data types
- Whether NULL is allowed
- Keys (PRI, UNI, MUL)
- Default values
- Extra info (like AUTO_INCREMENT)

        Example output:

        +----------+-------------+------+-----+---------+----------------+
        | Field    | Type        | Null | Key | Default | Extra          |
        +----------+-------------+------+-----+---------+----------------+
        | id       | int(11)     | NO   | PRI | NULL    | auto_increment |
        | name     | varchar(50) | YES  |     | NULL    |                |
        | age      | int(11)     | YES  |     | NULL    |                |
        +----------+-------------+------+-----+---------+----------------+


👉 Schema metadata, not actual data.

SELECT * FROM student;

Returns actual row data from the table.
* means “all columns”.
Output will be the stored records:

+----+-------+-----+
| id | name  | age |
+----+-------+-----+
| 1  | Alice | 21  |
| 2  | Bob   | 22  |
+----+-------+-----+
