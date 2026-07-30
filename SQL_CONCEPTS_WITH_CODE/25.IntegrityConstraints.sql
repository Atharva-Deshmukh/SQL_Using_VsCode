/* Constraints are used to limit the type of data that can go into a table. 
This ensures the accuracy and reliability of the data in the table. 
If there is any violation between the constraint and the data action, the action is aborted.

Constraints can be column level or table level. Column level constraints apply to a column, 
and table level constraints apply to the whole table.

constraints are not limited to creation — they can always be added, modified, or dropped later.

Column-level integrity constraints
------------------------------------

These are defined directly on a column (within the column definition).

NOT NULL → Ensures the column cannot store NULL values.
DEFAULT → Provides a default value if none is supplied.
CHECK → Restricts values based on a condition (e.g., salary > 0).
UNIQUE → Ensures values in the column are unique.
PRIMARY KEY (single-column) → Uniquely identifies rows + NOT NULL.odo
AUTO_INCREMENT (MySQL specific) → Auto-generates sequential numbers.

Table-level integrity constraints
----------------------------------

These are defined outside column definitions, usually at the end of the table declaration, 
and may involve multiple columns.

PRIMARY KEY (composite) → Defines a key over multiple columns.
UNIQUE (composite) → Ensures uniqueness across multiple columns.
CHECK (table-level) → Applies conditions involving one or more columns.
FOREIGN KEY → Enforces referential integrity with another table.

*/


---------------------------------------------------------------------------------------------
-- NOT NULL Constraint

/* By default, a column can hold NULL values.
   The NOT NULL constraint enforces a column to NOT accept NULL values. 
   
   NOT NULL is a column-level constraint only — it applies directly to a single column’s definition. */

---------------------------------------------------------------------------------------------

--While CREATE

CREATE TABLE Persons (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255) NOT NULL,
    Age int
);

--While ALTER

ALTER TABLE Persons MODIFY COLUMN Age int NOT NULL;

-- We can't directly drop the NOT NULL constraint. Instead, we modify the column to allow NULL values.
ALTER TABLE employees
MODIFY Salary DECIMAL(10,2) NULL;
-- The keyword NULL makes the column accept NULL values.

---------------------------------------------------------------------------------------------
-- DEFAULT Constraint

/* The DEFAULT constraint is used to set a default value for a column.

The default value will be added to all new records, if no other value is specified. */

---------------------------------------------------------------------------------------------

-- While CREATE

CREATE TABLE Persons (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    City varchar(255) DEFAULT 'Pune'
);

CREATE TABLE Orders (
    ID int NOT NULL,
    OrderNumber int NOT NULL,
    OrderDate date DEFAULT (GETDATE())
);

CREATE TABLE Orders (
    ID int NOT NULL,
    OrderNumber int NOT NULL,
    OrderDate date DEFAULT (CURRENT_DATE)
);

-- While ALTER

ALTER TABLE Persons
ALTER City SET DEFAULT 'Pune';

-- Dropping the default constraint
ALTER TABLE Persons
ALTER City DROP DEFAULT;

-- You can also use MODIFY but then you must redefine the full column definition with the default:
ALTER TABLE Persons 
MODIFY City VARCHAR(50) DEFAULT 'Pune';

/*
In MySQL, the only time you ever use ALTER TABLE ALTER COLUMN is to set or drop the DEFAULT constraint.

ALTER TABLE MODIFY COLUMN is used for following changes:
Used for most schema changes:

- Add/Drop/Modify columns
- Add/Drop/Modify constraints
- Rename columns or tables
- Add/Drop indexes

*/

---------------------------------------------------------------------------------------------
-- CHECK Constraint

/* The CHECK constraint is used to limit the value range that can be placed in a column.
   It can be applied to both column-level and table-level */

---------------------------------------------------------------------------------------------

-- While CREATE
CREATE TABLE ProgrammingLanguages (
    lang_id INT UNIQUE,
    language_name VARCHAR(50),
    designed_by VARCHAR(50),
    first_release_year INT CHECK(first_release_year > 1900) -- Column-level CHECK constraint
);

CREATE TABLE Persons (
    ID INT NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    FirstName VARCHAR(255),
    Age INT,
    CHECK (Age >= 18 AND lang_id > 0)                      -- Table-level CHECK constraint (applied on multiple columns)
);

-- DROPPING A CHECK CONSTRAINT:

-- Its not possible to drop a check constraint without name of that constraint

-- name the constraint: Naming means referencing a constraint, to get it later
-- If we don't name the constraint, the system will generate a name for it.
-- We then need to find that system generated constraint name to drop it.

-- If we have multiple CHECK constraint, they are internally named separately,
CREATE TABLE ProgrammingLanguages (
    lang_id INT UNIQUE CHECK(lang_id > 0),
    language_name VARCHAR(50),
    designed_by VARCHAR(50),
    first_release_year INT CHECK(first_release_year > 1900)
);
-- QUERY TO GET THE CONSTRAINT NAME(S)
SELECT CONSTRAINT_NAME
FROM information_schema.TABLE_CONSTRAINTS  -- this variable stores all the constraints
WHERE TABLE_NAME = 'ProgrammingLanguages'
  AND CONSTRAINT_TYPE = 'CHECK';

  /* # CONSTRAINT_NAME
       programminglanguages_chk_1
       programminglanguages_chk_2 */

-- If a table level constraint is added, we will get one only, 
CREATE TABLE ProgrammingLanguages (
    lang_id INT UNIQUE,
    language_name VARCHAR(50),
    designed_by VARCHAR(50),
    first_release_year INT,
    CHECK(first_release_year > 1900 AND lang_id > 0)
);

SELECT CONSTRAINT_NAME
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'TABLE_NAME_HERE'
  AND CONSTRAINT_TYPE = 'CHECK';

  /* # CONSTRAINT_NAME
       programminglanguages_chk_1  */


-- Use the name from above to drop the constraint
ALTER TABLE ProgrammingLanguages
DROP CHECK programminglanguages_chk_1; -- name is to be passed without quotes

 -- NAME A CHECK CONSTRAINT WHILE CREATING A TABLE
 CREATE TABLE ProgrammingLanguages (
    lang_id INT UNIQUE,
    language_name VARCHAR(50),
    designed_by VARCHAR(50),
    first_release_year INT,
    CONSTRAINT AD_CHECK CHECK(first_release_year > 1900 AND lang_id > 0) -- Naming the contraint with a user defined name
);

-- Drop using this name now, query the name first and then add this in drop command withuot quotes

-- while ALTER

-- Adding constraint without naming it

ALTER TABLE Persons
ADD CHECK (Age>=18);

-- Adding while naming the constraint
ALTER TABLE Persons
ADD CONSTRAINT CHK_PersonAge CHECK (Age>=18 AND City='Sandnes');

---------------------------------------------------------------------------------------------
-- UNIQUE Constraint

/*
The UNIQUE constraint ensures that all values in a column are different.
Both the UNIQUE and PRIMARY KEY constraints provide a guarantee for uniqueness for a column or set of columns.
A PRIMARY KEY constraint automatically has a UNIQUE constraint.

Primary key vs unique constraint:
=> We can have many UNIQUE constraints per table, but only one PRIMARY KEY constraint per table.

A unique constraint can accept null values, and multiple nulls are allowed.

CREATE TABLE UNIQUE_NULL (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(100) UNIQUE
);

INSERT INTO UNIQUE_NULL (Email) VALUES ('a@example.com'); -- ✅ OK
INSERT INTO UNIQUE_NULL (Email) VALUES ('b@example.com'); -- ✅ OK
INSERT INTO UNIQUE_NULL (Email) VALUES (NULL);            -- ✅ OK
INSERT INTO UNIQUE_NULL (Email) VALUES (NULL);            -- ✅ OK (allowed again)
-- INSERT INTO UNIQUE_NULL (Email) VALUES ('a@example.com'); -- ❌ Error (duplicate) 

SELECT * FROM UNIQUE_NULL;

Hence Primary key = UNIQUE + NOT NULL
Since, unique allows multiple nulls, it can't be a primary key.

*/
---------------------------------------------------------------------------------------------

-- While CREATE

-- column level
CREATE TABLE UserData (
    UserID INT UNIQUE,
    UserName VARCHAR(50) NOT NULL,
    Age INT,
    City VARCHAR(50)
);

-- Table level

CREATE TABLE UserData (
    UserID INT,
    UserName VARCHAR(50) NOT NULL,
    Age INT,
    City VARCHAR(50),
    UNIQUE(UserID, Age) -- This means: the combination of UserID and Age must be unique, not each column individually.
);

INSERT INTO UserData (UserID, UserName, Age, City) VALUES
(1, 'John', 25, 'Delhi'),
(2, 'Emma', 25, 'Mumbai');  -- combination (2, 25) is unique, not unique columns individually

-- again there are named and unnamed constraint for unique 
-- we need to get the name of the constraint and then drop it

-- named constraint with a custom, its at table level
-- at column level, name is automatically generated, the constraint is always a named one
CREATE TABLE UserData (
    UserID INT,
    UserName VARCHAR(50) NOT NULL,
    Age INT,
    City VARCHAR(50),
    CONSTRAINT uniq_cont UNIQUE(UserID, Age) -- named constraint
);

-- QUERY TO GET THE CONSTRAINT NAME(S)
SELECT CONSTRAINT_NAME
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'UserData'
  AND CONSTRAINT_TYPE = 'UNIQUE';

  -- altering columns by adding UN-NAMED unique constraint on them.
ALTER TABLE UserData
ADD UNIQUE(UserID, Age);

-- altering columns by adding NAMED unique constraint on them.
ALTER TABLE UserData
ADD CONSTRAINT AD_UN UNIQUE(UserID, Age);

-- Dropping a unique constraint
ALTER TABLE Persons
DROP INDEX UC_Person; -- for unnamed constraint, we need to get the name first
                      -- Syntax has 'INDEX' keyword for dropping unique constraint