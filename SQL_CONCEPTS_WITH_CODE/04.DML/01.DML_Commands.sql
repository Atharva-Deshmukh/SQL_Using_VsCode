/*
===========================================================
UPDATE → Modifies existing rows.
===========================================================

Syntax:
  UPDATE studenttable SET Address = 'Himalaya' WHERE Student_Id = 1;

Output:

  +------------+----------+
  | Student_Id | Address  |
  +------------+----------+
  | 1          | Himalaya |
  +------------+----------+

IMPORTANT:

  WHERE → selects which rows to update.
  Without WHERE → ALL rows are updated.

===========================================================
UPDATE MULTIPLE ROWS WITH DIFFERENT VALUES
===========================================================

Option 1 → Multiple UPDATE statements:

  UPDATE studenttable
  SET Address = 'Himalaya'
  WHERE Student_Id = 1;

  UPDATE studenttable
  SET Address = 'Hastinapur'
  WHERE Student_Id = 2;


Option 2 → CASE:

  UPDATE studenttable
  SET Address = CASE Student_Id
      WHEN 1 THEN 'Himalaya'
      WHEN 2 THEN 'Hastinapur'
      WHEN 3 THEN 'Mahendragiri'
  END
  WHERE Student_Id IN (1, 2, 3);


Result:

+------------+---------------+
| Student_Id | Address       |
+------------+---------------+
| 1          | Himalaya      |
| 2          | Hastinapur    |
| 3          | Mahendragiri  |
+------------+---------------+


===========================================================
UPDATE MULTIPLE COLUMNS
===========================================================

UPDATE studenttable
SET Address = 'Himalaya',
    Age = 200
WHERE Student_Id = 1;


→ Multiple columns can be updated in one statement.

===========================================================
SQL_SAFE_UPDATES
===========================================================

MySQL Workbench may reject:

UPDATE studenttable SET Address = 'Himalaya';

Error:
→ Error Code: 1175
→ Safe update mode is enabled.

Disable for the session: SET SQL_SAFE_UPDATES = 0;
Re-enable when needed: SET SQL_SAFE_UPDATES = 1;

===========================================================
DELETE
===========================================================

DELETE → Removes existing rows from a table.

Delete specific rows: 
  DELETE FROM wtable WHERE W_Name = 'K';

Delete ALL rows:
  DELETE FROM wtable;
  → All rows deleted.
  → Table itself remains.


DROP TABLE wtable;
  → Table + data are removed.

===========================================================
DELETE + TRANSACTION
===========================================================

DELETE can be rolled back only if the transaction has not been committed.

With MySQL default:

autocommit = 1
→ DELETE is committed automatically.
→ ROLLBACK cannot undo it.

With an explicit transaction:

START TRANSACTION;

DELETE FROM wtable WHERE W_Name = 'K';

ROLLBACK;
→ Deleted row is restored.

COMMIT;
→ Changes become permanent for the transaction.
