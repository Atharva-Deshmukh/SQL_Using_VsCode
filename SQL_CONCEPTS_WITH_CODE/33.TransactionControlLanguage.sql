/* Includes: COMMIT and ROLLBACK

In MySQL DB, every operation is auto-committed by default.

TCL only works on DML commands -> INSERT, UPDATE and DELETE. */

===========================================================
IMPORTANT CORRECTION ABOUT ROLLBACK
===========================================================

Do NOT memorize this as an absolute rule:

DELETE     → rollback
TRUNCATE   → cannot rollback
DROP       → cannot rollback


That is too DB-specific.

Rollback behavior for DDL differs between database systems.

For MySQL specifically, DDL such as DROP/TRUNCATE has
important implicit-commit behavior, so you should NOT treat
TRUNCATE/DROP like normal transactional DELETE operations.


For SDET interviews, the safest answer is:

DELETE:
→ Transactional and rollback-capable when executed inside
  a transaction on a transactional engine and before COMMIT.

TRUNCATE:
→ DDL; rollback behavior is database-specific.
  In MySQL, do not rely on ROLLBACK to undo TRUNCATE.

DROP:
→ DDL; rollback behavior is database-specific.
  In MySQL, do not rely on ROLLBACK to undo DROP.

===========================================================
7. DELETE + TRANSACTION + ROLLBACK
===========================================================

This is an IMPORTANT SDET interview topic.

Whether DELETE can be rolled back depends on:

→ Transaction state
→ Autocommit
→ Database engine
→ Database system
→ Whether COMMIT has occurred


For MySQL, with a transactional engine such as InnoDB:

START TRANSACTION;

DELETE FROM student
WHERE Student_Id = 2;

ROLLBACK;


The DELETE is undone.


After ROLLBACK:

+------------+-----------+
| Student_Id | Name      |
+------------+-----------+
| 1          | Agastya   |
| 2          | Devrath   |
| 3          | Parshuram |
+------------+-----------+


-----------------------------------------------------------
COMMIT
-----------------------------------------------------------

START TRANSACTION;

DELETE FROM student
WHERE Student_Id = 2;

COMMIT;


COMMIT makes the transaction permanent.

A later:

ROLLBACK;


will NOT undo the already committed DELETE.


After COMMIT:

+------------+-----------+
| Student_Id | Name      |
+------------+-----------+
| 1          | Agastya   |
| 3          | Parshuram |
+------------+-----------+


===========================================================
8. AUTOCOMMIT
===========================================================

In MySQL, autocommit is enabled by default for normal
transactions.

Conceptually:

AUTOCOMMIT = ON

means each statement is committed automatically when it
successfully completes.

Example:

DELETE FROM student
WHERE Student_Id = 2;


The DELETE is automatically committed.

A later:

ROLLBACK;


cannot undo that already committed DELETE.


-----------------------------------------------------------
Explicit transaction
-----------------------------------------------------------

Instead of manually changing autocommit, a clearer approach
for interview examples is:

START TRANSACTION;

DELETE FROM student
WHERE Student_Id = 2;

ROLLBACK;


Result:

DELETE is undone.


Or:

START TRANSACTION;

DELETE FROM student
WHERE Student_Id = 2;

COMMIT;


Result:

DELETE becomes permanent.


IMPORTANT:

For interview answers, prefer explaining transactions using:

START TRANSACTION
→ perform changes
→ COMMIT / ROLLBACK


rather than relying only on SET autocommit.


SET autocommit = 0; -- DISABLING AUTOCOMMIT, to demonstrate TCL

USE mydb;

CREATE TABLE tcl_demo(
id INT,
name VARCHAR(100)
);

INSERT INTO tcl_demo (id, name)
VALUES 
(1, 'AD'),
(2, 'NM');

COMMIT;

SELECT * FROM tcl_demo;

-- Allow DELETE without a key restriction if needed (MySQL safe update mode)
SET SQL_SAFE_UPDATES = 0;

DELETE FROM tcl_demo WHERE id=2;

ROLLBACK;

-- we can also create a savepoint and ROLLBACK to SAVE_POINT