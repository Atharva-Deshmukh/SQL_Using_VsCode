/* Includes: COMMIT and ROLLBACK

In MySQL DB, every operation is auto-committed by default.

TCL only works on DML commands -> INSERT, UPDATE and DELETE. */

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