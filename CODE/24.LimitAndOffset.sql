/*   The LIMIT clause is used to specify the number of records to return.

LIMIT is used only with SELECT queries (and sometimes with DELETE/UPDATE to restrict rows). */

                                            -- With SELECT
-- First 5 rows
SELECT * FROM Employees LIMIT 5;

-- 5 rows starting from 6th row (offset)
SELECT * FROM Employees LIMIT 5 OFFSET 5;
-- If offset is greater than the number of rows, an empty result set is returned.
-- If offset is such that there are not enough rows, only the remaining rows are returned.


                                            -- With DELETE
-- Delete only 2 rows
DELETE FROM Employees LIMIT 2;


                                            -- With UPDATE
-- Update only 3 rows
UPDATE Employees SET Age = Age + 1 LIMIT 3;