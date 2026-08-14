/*
===========================================================
TRANSACTION CONTROL LANGUAGE (TCL)
===========================================================

TCL → Controls transactions.

Main commands:
→ COMMIT
→ ROLLBACK
→ SAVEPOINT


IMPORTANT:
→ Transaction control mainly applies to DML:
  INSERT, UPDATE, DELETE.

→ MySQL autocommit is ON by default for normal transactions.

===========================================================
1. TRANSACTION
===========================================================

A transaction groups changes so they can be either:

COMMIT
→ Make changes permanent.

ROLLBACK
→ Undo uncommitted changes.

===========================================================
2. DELETE + ROLLBACK
===========================================================

For MySQL with a transactional engine such as InnoDB:

START TRANSACTION;

DELETE FROM student
WHERE Student_Id = 2;

ROLLBACK;

Result:
→ DELETE is undone.
→ Student_Id = 2 exists again.


===========================================================
3. DELETE + COMMIT
===========================================================

START TRANSACTION;

DELETE FROM student
WHERE Student_Id = 2;

COMMIT;

Result:
→ DELETE becomes permanent.

A later:

ROLLBACK;

→ Cannot undo an already committed change.

===========================================================
4. AUTOCOMMIT
===========================================================

MySQL autocommit is ON by default.

AUTOCOMMIT = ON
→ Successful DML statement is automatically committed.

Example:

DELETE FROM student
WHERE Student_Id = 2;


The DELETE is automatically committed.

Therefore:

ROLLBACK;

→ Cannot undo it.


For interview examples, prefer:

START TRANSACTION
→ DML
→ COMMIT / ROLLBACK


===========================================================
5. SAVEPOINT
===========================================================

SAVEPOINT
→ Creates a point inside a transaction to which you can
  partially roll back.

Example:

START TRANSACTION;

UPDATE student
SET Name = 'A'
WHERE Student_Id = 1;

SAVEPOINT sp1;

UPDATE student
SET Name = 'B'
WHERE Student_Id = 2;

ROLLBACK TO sp1;


Result:
→ First UPDATE remains.
→ Second UPDATE is undone.


Flow:

START TRANSACTION
      ↓
 UPDATE #1
      ↓
 SAVEPOINT sp1
      ↓
 UPDATE #2
      ↓
ROLLBACK TO sp1
      ↓
 UPDATE #1 remains
 UPDATE #2 undone


===========================================================
6. DELETE vs TRUNCATE vs DROP
===========================================================

Do NOT memorize:

DELETE     → rollback
TRUNCATE   → no rollback
DROP       → no rollback

This is database-specific.

For MySQL:

DELETE
→ Transactional and rollback-capable with a transactional
  engine such as InnoDB, before COMMIT.

TRUNCATE
→ DDL.
→ Do not rely on ROLLBACK to undo it.

DROP
→ DDL.
→ Do not rely on ROLLBACK to undo it.


MEMORY:

DELETE
→ DML → transaction can control it

TRUNCATE / DROP
→ DDL → MySQL implicit-commit behavior matters
*/

