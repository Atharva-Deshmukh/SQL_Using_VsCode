/*
===========================================================
DDL -> Defines / changes database structure.
===========================================================

CREATE → create object
ALTER  → change structure
DROP   → remove object
TRUNCATE → remove all rows, keep table
RENAME → change table name

DML:
  INSERT → add data
  UPDATE → change data
  DELETE → remove rows


===========================================================
QUICK SYNTAX
===========================================================

Keep table + remove selected rows → DELETE
Keep table + remove ALL rows     → TRUNCATE
Remove table completely          → DROP
Change table structure           → ALTER
Change table name                → RENAME
Create object                    → CREATE
Undo DELETE                      → ROLLBACK*
Make transaction permanent       → COMMIT


===========================================================
1. CREATE
===========================================================

CREATE DATABASE IF NOT EXISTS mydb;

USE mydb;

CREATE TABLE IF NOT EXISTS student(
    Student_Id INT,
    Name VARCHAR(400)
);

INSERT INTO student
VALUES
(1, 'Agastya'),
(2, 'Devrath'),
(3, 'Parshuram');


===========================================================
2. ALTER TABLE
===========================================================

ALTER → modify existing table structure.

ADD COLUMN:
  ALTER TABLE student ADD COLUMN Email VARCHAR(50);

Existing rows
  +------------+-----------+-------+
  | Student_Id | Name      | Email |
  +------------+-----------+-------+
  | 1          | Agastya   | NULL  |
  | 2          | Devrath   | NULL  |
  | 3          | Parshuram | NULL  |
  +------------+-----------+-------+

DROP COLUMN:
  ALTER TABLE student DROP COLUMN Email;

MODIFY COLUMN:
  ALTER TABLE student MODIFY COLUMN Name VARCHAR(200);

Multiple:
  ALTER TABLE student
  MODIFY COLUMN age BIGINT,
  MODIFY COLUMN name VARCHAR(200),
  MODIFY COLUMN email VARCHAR(150) NOT NULL;

RENAME COLUMN:
  ALTER TABLE student RENAME COLUMN Name TO StudentName;

===========================================================
3. DROP DATABASE / TABLE
===========================================================

DROP DATABASE IF EXISTS mydb;
→ Removes database + tables + data + objects.

DROP TABLE student;
→ Removes table + data.

===========================================================
4. TRUNCATE TABLE
===========================================================

TRUNCATE TABLE student;

→ Removes ALL rows.
→ Table structure remains.
→ WHERE is not supported.

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

DESCRIBE student;

→ Student_Id
→ Name

Table still exists.

===========================================================
5. DELETE
===========================================================

DELETE → removes rows.

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

DELETE without WHERE:
  DELETE FROM student;
  → Removes all rows, but table remains.

===========================================================
6. SQL_SAFE_UPDATES — MySQL
===========================================================

Safe-update mode helps prevent accidental mass UPDATE / DELETE.

DELETE FROM student;
  → May fail when SQL_SAFE_UPDATES = 1.

Disable:
  SET SQL_SAFE_UPDATES = 0;

===========================================================
7. DELETE vs TRUNCATE vs DROP
===========================================================

+----------------+----------------------+----------------------+----------------------+
| Feature        | DELETE               | TRUNCATE             | DROP                 |
+----------------+----------------------+----------------------+----------------------+
| Category       | DML                  | DDL                  | DDL                  |
| Removes        | Selected/all rows    | All rows             | Table + data         |
| WHERE          | YES                  | NO                   | NO                   |
| Table remains  | YES                  | YES                  | NO                   |
| Structure      | Remains              | Remains              | Removed              |
| Rollback       | Transaction-dependent| DB-dependent         | DB-dependent         |
| Triggers       | DELETE triggers      | DB-specific          | DB-specific          |
+----------------+----------------------+----------------------+----------------------+

===========================================================
8. RENAME TABLE
===========================================================

RENAME TABLE student TO studentTable;

→ Changes table name only.
→ Columns and data remain unchanged.

===========================================================
9. ALTER vs RENAME
===========================================================

+----------------------+--------------------------------+--------------------------------+
| Feature              | ALTER TABLE                    | RENAME TABLE                   |
+----------------------+--------------------------------+--------------------------------+
| Purpose              | Change table structure         | Change table name              |
| Add column           | YES                            | NO                             |
| Drop column          | YES                            | NO                             |
| Modify column        | YES                            | NO                             |
| Rename column        | YES                            | NO                             |
| Rename table         | NO                             | YES                            |
+----------------------+--------------------------------+--------------------------------+

Examples:

ALTER TABLE student RENAME COLUMN Name TO StudentName;

RENAME TABLE student TO studentTable;

===========================================================
10. TRANSACTION / DELETE
===========================================================

START TRANSACTION;
DELETE FROM Employees WHERE Employee_Id = 10;
ROLLBACK;

→ Restores DELETE if the transaction is rollback-capable.

Permanent:

  START TRANSACTION;
  DELETE FROM Employees WHERE Employee_Id = 10;
  COMMIT;

→ Change is committed.