/*
===========================================================
DDL (Data Definition Language) COMMANDS
===========================================================

Primarily define or modify DATABASE OBJECTS / their structure.

Most important DDL commands:
  CREATE
  ALTER
  DROP
  TRUNCATE
  RENAME


IMPORTANT:

  DDL changes the database structure/schema.
  DML changes the data inside the structure.

  DDL:
  → CREATE
  → ALTER
  → DROP
  → TRUNCATE
  → RENAME

  DML:
  → INSERT
  → UPDATE
  → DELETE



===========================================================
1. CREATE
===========================================================

CREATE is used to create database objects.

Common objects:
  → DATABASE
  → TABLE
  → INDEX
  → VIEW
  → STORED PROCEDURE


-----------------------------------------------------------
CREATE DATABASE
-----------------------------------------------------------

CREATE DATABASE IF NOT EXISTS mydb;

USE mydb;

-----------------------------------------------------------
CREATE TABLE
-----------------------------------------------------------

CREATE TABLE IF NOT EXISTS student(
    Student_Id INT,
    Name VARCHAR(400)
);

Insert sample data:

  INSERT INTO student
  VALUES
  (1, 'Agastya'),
  (2, 'Devrath'),
  (3, 'Parshuram');


===========================================================
2. ALTER
===========================================================

Used to MODIFY THE STRUCTURE of an existing database object.

Most commonly:
  → Add columns
  → Drop columns
  → Modify column datatype
  → Rename columns


===========================================================
ADD COLUMN
===========================================================

ALTER TABLE student
ADD COLUMN Email VARCHAR(50);

Output:

  +------------+-----------+-------+
  | Student_Id | Name      | Email |
  +------------+-----------+-------+
  | 1          | Agastya   | NULL  |
  | 2          | Devrath   | NULL  |
  | 3          | Parshuram | NULL  |
  +------------+-----------+-------+

Why NULL --> The existing rows did not have an Email value.


-----------------------------------------------------------
ADD MULTIPLE COLUMNS
-----------------------------------------------------------

ALTER TABLE student
ADD COLUMN SurName VARCHAR(20),
ADD COLUMN Email VARCHAR(50);

===========================================================
DROP COLUMN
===========================================================

Used to remove a column from an existing table.
The column itself and its data are removed.

Example:

  ALTER TABLE student
  DROP COLUMN Email;

DROP MULTIPLE COLUMNS:

  ALTER TABLE student
  DROP COLUMN Email,
  DROP COLUMN SurName;

===========================================================
MODIFY COLUMN DATATYPE
===========================================================

Used to change the datatype or definition of an existing column.

First inspect the table:
                    DESCRIBE student;


Example:
  ALTER TABLE student
  MODIFY COLUMN Name VARCHAR(200);


Example with multiple changes:
  ALTER TABLE student
  MODIFY COLUMN age BIGINT,
  MODIFY COLUMN name VARCHAR(200),
  MODIFY COLUMN email VARCHAR(150) NOT NULL;

===========================================================
RENAME COLUMN
===========================================================

Used to change a column name.

ALTER TABLE student
RENAME COLUMN Name TO StudentName;

DESCRIBE student;


Output:
  Student_Id
  StudentName


-----------------------------------------------------------
RENAME MULTIPLE COLUMNS
-----------------------------------------------------------

For maximum portability, rename columns one at a time unless the target DB explicitly supports your syntax.

Example:

  ALTER TABLE student
  RENAME COLUMN StudentName TO FirstName;

  ALTER TABLE student
  RENAME COLUMN SurName TO LastName;

  ALTER TABLE student
  RENAME COLUMN Email TO email_id;


===========================================================
3. DROP DATABASE
===========================================================

DROP DATABASE permanently removes the database.

Syntax: DROP DATABASE IF EXISTS mydb;

DROP DATABASE removes:
  → Database
  → Tables
  → Data
  → Database objects inside it


This is a destructive operation.

===========================================================
4. DROP TABLE
===========================================================

DROP TABLE removes the table itself AND all its data.

Syntax --> DROP TABLE student;


Difference:

DROP TABLE
→ Table structure is gone.
→ Data is gone.


TRUNCATE TABLE
→ Table structure remains.
→ Data is removed.


DELETE
→ Table structure remains.
→ Selected rows are removed.


===========================================================
5. TRUNCATE TABLE
===========================================================

Removes ALL rows from a table but keeps the table structure.

TRUNCATE TABLE student;

Before:
  +------------+-----------+
  | Student_Id | Name      |
  +------------+-----------+
  | 1          | Agastya   |
  | 2          | Devrath   |
  | 3          | Parshuram |
  +------------+-----------+


SELECT * FROM student;

Output:
  Empty result set.


But:

DESCRIBE student;

still shows:

Student_Id
Name

===========================================================
6. DELETE
===========================================================

DELETE is used to remove rows from a table.

DELETE FROM student WHERE Student_Id = 2;


Before:

  +------------+-----------+
  | Student_Id | Name      |
  +------------+-----------+
  | 1          | Agastya   |
  | 2          | Devrath   |
  | 3          | Parshuram |
  +------------+-----------+


After:

  +------------+-----------+
  | Student_Id | Name      |
  +------------+-----------+
  | 1          | Agastya   |
  | 3          | Parshuram |
  +------------+-----------+


IMPORTANT:
  DELETE without condition --> Deletes all rows but the table itself remains


===========================================================
SQL_SAFE_UPDATES
===========================================================

MySQL has a client setting called: SQL_SAFE_UPDATES

DELETE FROM student; --> may fail in safe-update mode.

A common way to disable it --> SET SQL_SAFE_UPDATES = 0;

It is a safety mechanism that helps prevent accidental mass UPDATE/DELETE operations.


===========================================================
DELETE vs TRUNCATE vs DROP
===========================================================

+----------------+----------------------+----------------------+----------------------+
| Feature        | DELETE               | TRUNCATE             | DROP                 |
+----------------+----------------------+----------------------+----------------------+
| Category       | DML                  | DDL                  | DDL                  |
| Removes        | Selected/all rows    | All rows             | Entire Table + data  |
| WHERE clause   | YES  supported       | Not supported        | Not supported        |
| Table remains  | YES                  | YES                  | NO                   |
| Speed          |Slower(logs row by row) Faster (Minimial logs) Fastest (frees memory directly)
| Structure      | Remains              | Remains              | Removed              |
| Rollback       | YES                  | NO (in some DBs, YES)| NO                   |
| Triggers       | YES                  | NO                   | NO                   |
+----------------+----------------------+----------------------+----------------------+

===========================================================
14. RENAME TABLE
===========================================================

Used to rename a table.

RENAME TABLE student
TO studentTable;

IMPORTANT:
  RENAME TABLE just changes the table name.
  It does NOT change the columns or data.

===========================================================
ALTER vs RENAME
===========================================================

+----------------------+-----------------------------------+----------------------------------+
| Feature              | ALTER TABLE                       | RENAME TABLE                     |
+----------------------+-----------------------------------+----------------------------------+
| Purpose              | Changes table structure           | Changes table name               |
| Add column           | YES                               | NO                               |
| Drop column          | YES                               | NO                               |
| Modify column        | YES                               | NO                               |
| Rename column        | YES                               | NO                               |
| Rename table         | NO                                | YES                              |
| Example              | ALTER TABLE student               | RENAME TABLE student             |
|                      | RENAME COLUMN Name                | TO studentTable;                 |
|                      | TO StudentName;                   |                                  |
+----------------------+-----------------------------------+----------------------------------+

===========================================================
GOLDEN INTERVIEW RULES
===========================================================


"Keep table, remove selected rows?" → DELETE
"Keep table, remove ALL rows?" → TRUNCATE
"Remove table completely?" → DROP
"Change table structure?" → ALTER
"Change table name?" → RENAME
"Create a new table/database?" → CREATE
"Undo a DELETE?" → ROLLBACK
  (only when the DELETE is still part of a rollback-capable
   transaction)

===========================================================
VERY COMMON SDET INTERVIEW QUESTIONS
===========================================================

Q: Delete one employee.

  DELETE FROM Employees WHERE Employee_Id = 10;


Q: Delete all employees but keep the table.

   TRUNCATE TABLE Employees;


Q: Delete the Employees table completely.

   DROP TABLE Employees;


Q: Add an Email column.

  ALTER TABLE Employees ADD COLUMN Email VARCHAR(100);


Q: Remove the Email column.

  ALTER TABLE Employees DROP COLUMN Email;


Q: Rename a column.

  ALTER TABLE Employees RENAME COLUMN Email TO Email_Id;


Q: Rename a table.

  RENAME TABLE Employees TO EmployeeDetails;


Q: Delete a row and then restore it.

  START TRANSACTION;

  DELETE FROM Employees WHERE Employee_Id = 10;

  ROLLBACK;


Q: Delete a row permanently within an explicit transaction.

  START TRANSACTION;

  DELETE FROM Employees
  WHERE Employee_Id = 10;

  COMMIT;

===========================================================
*/
