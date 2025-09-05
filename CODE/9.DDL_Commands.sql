/* CREATE:

- Used to create various DB objects like DB, Table, Index, View, Stored Procedure etc.

*/

-- CREATE DB
CREATE DATABASE IF NOT EXISTS mydb;

-- Using this created DB, create a table and add records to it
USE mydb;
CREATE TABLE IF NOT EXISTS student(
Student_Id INT(12),
Name VARCHAR(400)
);

INSERT INTO student 
VALUES
(1, 'Agastya'),
(2, 'Devrath'),
(3, 'Parshuram');

/* ALTER:

- Its used to modify the structure of an existing DB object like DB, Table etc.
- Most commonly used on tables to add, delete or modify columns
- We can use ADD or ADD COLUMN to adda new column to an existing table
- Its safe to use ADD COLUMN since it is used in most DBs */

----------------------------------------ADD COLUMNS----------------------------------

-- Add a new column 'Email' to the existing 'student' table
ALTER TABLE student 
ADD COLUMN Email varchar(50);

-- Adding multiple columns at a time
ALTER TABLE student 
ADD COLUMN SurName VARCHAR(20),
ADD COLUMN Email VARCHAR(50);

----------------------------------------DROP COLUMNS----------------------------------

-- We use this to delete a column in a table (Some DBs don't allow deleting a column):

-- Dropping a single column
ALTER TABLE student 
DROP COLUMN Email;

-- Droping multiple columns at a time
ALTER TABLE student 
DROP COLUMN Email,
DROP COLUMN SurName;

----------------------------------------Modifying Data types----------------------------------


DESCRIBE student; -- This will display data types of all columns

ALTER TABLE student 
MODIFY SurName VARCHAR(50);

-- Modifying data types of multiple columns
ALTER TABLE student
MODIFY COLUMN age BIGINT,
MODIFY COLUMN name VARCHAR(200),
MODIFY COLUMN email VARCHAR(150) NOT NULL;


----------------------------------------Rename column ----------------------------------


ALTER TABLE student 
RENAME COLUMN Name TO StudentName;

-- Modifying Names of multiple columns
ALTER TABLE student 
RENAME COLUMN StudentName TO FirstName,
RENAME COLUMN SurName TO LasName,
RENAME COLUMN Email TO email_id;


/* DROP DATABASE:

- The DROP DATABASE statement is used to drop an existing SQL database.
- Be careful before dropping a database. Deleting a database will result in 
  loss of complete information stored in the database!

  Similarly, DROP TABLE is used to delete a table and all the data inside it.

*/

/* TRUNCATE TABLE:
- The TRUNCATE TABLE statement is used to delete the data inside a table, 
  but not the table itself.

  TRUNCATE is not applicable on DB, its applied only on tables.

*/

USE mydb;
TRUNCATE TABLE stud;

SELECT * FROM stud;

/* DELETE:

- Deletes specific rows from a table based on a condition.
- Can be rolledback

In MySQL, there is a little catch regarding rollback of delete command.

By default, in mySQL, autocommit = 1, means each line automatically commits permanently in the DB.

But when we set autocommit = 0, then we can rollback the delete command.
To commit changes permamently, we need to use COMMIT command in this case

                                    With autocommit=1 (default):
                                    ---------------------------

    - DELETE, DROP, TRUNCATE all succeed.
    - Nothing can be rolled back.

                            With autocommit=0 (or explicit START TRANSACTION):
                            -------------------------------------------------

    - DELETE → rollback possible.
    - DROP & TRUNCATE → auto-commit, rollback not possible.

                                    ONE more mode is there
                                    ---------------------


When SQL_SAFE_UPDATES = 1 (safe updates mode ON):

You cannot run UPDATE or DELETE statements unless they have:
A WHERE clause using an indexed column (key column), or
A LIMIT clause.

Example (will fail):
DELETE FROM customers;

❌ Error: "You are using safe update mode..."

*/

SET autocommit = 0;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM stud where Student_Id = 4;

ROLLBACK;

SELECT * FROM stud;

/*
In above code, If I run rollback and then select *, the deleted record will be restored.
Since autocommit = 0, so delete command can be rolled back.
We need to add commit explicity to make the delete permanent.

BUT the mySQL is automatically handling the transaction, So I don't need to change the modes,
The below code is also restoring deleted record.
*/

-- SET autocommit = 0;
-- SET SQL_SAFE_UPDATES = 0;
DELETE FROM stud where Student_Id = 4;

ROLLBACK;

SELECT * FROM stud;

-- Now Commit cannot be rolled back

-- SET autocommit = 0;
-- SET SQL_SAFE_UPDATES = 0;
DELETE FROM stud where Student_Id = 4;
COMMIT;

ROLLBACK;

SELECT * FROM stud;


/*    DROP VS DELETE VS TRUNCATE
--------------------------------------- 


| Parameter        | DELETE                                    | DROP                            | TRUNCATE                                     |
| ---------------- | ----------------------------------------- | ------------------------------- | -------------------------------------------- |
| **Type**         | DML                                       | DDL                             | DDL                                          |
| **Purpose**      | Deletes specific rows based on condition  | Deletes the entire table or DB  | Deletes all rows but retains table structure |
| **Syntax**       | `DELETE FROM table_name WHERE condition;` | `DROP TABLE table_name;`        | `TRUNCATE TABLE table_name;`                 |
| **Rollback**     | Can be rolled back                        | Cannot be rolled back           | Cannot be rolled back                        |
| **Data Removal** | Removes selected rows                     | Removes table & data completely | Removes all rows                             |
| **Efficiency**   | Slower (row by row)                       | Instant (affects schema)        | Faster than DELETE but slower than DROP      |
| **Triggers**     | Fires triggers                            | Does not fire triggers          | Does not fire triggers                       |

*/

/* RENAME:
- WORKS only for tables

*/

RENAME TABLE stud TO studentTable;
SELECT * FROM studentTable;