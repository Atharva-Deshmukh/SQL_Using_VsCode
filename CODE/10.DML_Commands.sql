/* UPDATE
- Updates specific records

Note: Be careful when updating records in a table! Notice the WHERE clause in the UPDATE statement. 
The WHERE clause specifies which record(s) that should be updated. If you omit the WHERE clause, 
all records in the table will be updated!

ERROR you may get while using UPDATE command:
Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that
uses a KEY column. 

To disable safe mode, toggle the option in Preferences OR execute SET SQL_SAFE_UPDATES = 0; in the script.

*/

-- Updating a single column based on condition
SET SQL_SAFE_UPDATES = 0;
UPDATE studenttable 
SET Address = 'Himalaya'
WHERE Student_Id = 1;

-- Without Where clause, all records will be updated
SET SQL_SAFE_UPDATES = 0;
UPDATE studenttable 
SET Address = 'Himalaya'; -- All column values will be 'Himalaya'


-- Updating multiple Records based on condition
-- WAY-1: Use multiple update statements
SET SQL_SAFE_UPDATES = 0;

UPDATE studenttable 
SET Address = 'Himalaya'
WHERE Student_Id = 1;

UPDATE studenttable 
SET Address = 'Hastinapur'
WHERE Student_Id = 2;

UPDATE studenttable 
SET Address = 'Mahendragiri'
WHERE Student_Id = 3;

--WAY-2: Use Switch Cases

SET SQL_SAFE_UPDATES = 0;
UPDATE studenttable 
SET Address = CASE Student_Id
	WHEN 1 THEN 'Himalaya'
    WHEN 2 THEN 'Hastinapur'
    WHEN 3 THEN 'Mahendragiri'
    ELSE 'MOUNTAIN'
END
WHERE Student_Id IN (1, 2, 3);

-- UPDATING MULTIPLE COULUMNS

SET SQL_SAFE_UPDATES = 0;

UPDATE studenttable 
SET Address = 'Himalaya', Age = 200
WHERE Student_Id = 1;

UPDATE studenttable 
SET Address = 'Hastinapur', Age = 150
WHERE Student_Id = 2;

UPDATE studenttable 
SET Address = 'Mahendragiri', Age = 500
WHERE Student_Id = 3;


/* DELETE
- The DELETE statement is used to delete existing records in a table.
- Note: Be careful when deleting records in a table! Notice the WHERE clause in the DELETE statement. 
  The WHERE clause specifies which record(s) should be deleted. If you omit the WHERE clause, all records 
  in the table will be deleted!

  - Rollback won't be possible with DELETE if autocommit = 1 (default)

*/

-- Delete a single Record/Row based on condition
DELETE FROM wtable 
WHERE W_Name = 'Krishna';

SELECT * FROM wtable;

-- Delete full table without a condition, the table is preserved, just the records are deleted
DELETE FROM wtable;

-- Drop the table to fully delete it 
-- DROP TABLE wtable;