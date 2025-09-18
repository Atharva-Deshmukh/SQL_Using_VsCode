/* Keys are also intergrity constraints in sql, writing here seprately for better understanding.

---------------------------------------------------------------------------------------------
-- PRIMARY KEY Constraint

/* Properties
---------------
- No duplicate values are allowed, i.e. The column assigned as the primary key should have UNIQUE values only.

- NO NULL values are present in the Primary key column. Hence there is a Mandatory value in the column 
  having the Primary key.

- Only one primary key per table exists although the Primary key may have multiple columns 
  (composite primary key).

- No new row can be inserted with the already existing primary key.

- Primary keys can be classified into two categories:
  Simple primary key that consists of one column and composite primary key that consists of Multiple column.

- Defined in CREATE TABLE or ALTER TABLE statement.

--------------------------------------------------------------------------------------------- */

-- Column-level primary key constraint
CREATE TABLE UserData (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(50) NOT NULL,
    Age INT,
    City VARCHAR(50)
);

-- To get the name of the primary key constraint
SELECT CONSTRAINT_NAME
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'UserData'
  AND CONSTRAINT_TYPE = 'PRIMARY KEY';

  /* OUTPUT:
     PRIMARY */

-- Table-level primary key constraint
CREATE TABLE UserData (
    UserID INT,
    UserName VARCHAR(50) NOT NULL,
    Age INT,
    City VARCHAR(50),
    PRIMARY KEY(UserID, UserName) -- unnamed primary key constraint
);

CREATE TABLE UserData (
    UserID INT,
    UserName VARCHAR(50) NOT NULL,
    Age INT,
    City VARCHAR(50),
    CONSTRAINT AD_PK PRIMARY KEY(UserID, UserName) -- named Primary key constraint
);

/*
In MySQL, each table can only have one primary key.
Since there’s only one, MySQL doesn’t actually keep different names — it just always calls it PRIMARY.
*/

-- UN-NAMED addition on PRIMARY KEY constraint to table
ALTER TABLE UserData
ADD PRIMARY KEY(UserID);

-- NAMED addition on PRIMARY KEY constraint to table
ALTER TABLE UserData
ADD CONSTRAINT AD_PK PRIMARY KEY(UserID);

-- Dropping a PRIMARY KEY constraint
ALTER TABLE UserData
DROP PRIMARY KEY;

/* No name is required while dropping bcoz:
- A table can only have one primary key,
- Its name is always PRIMARY, no matter what you wrote when creating it,
- So MySQL doesn’t require (or allow) you to specify a name. */
--------------------------------------------------------------------------------------------------------

/*
---------------------------------------------------------------------------------------------
-- FOREIGN KEY Constraint

The FOREIGN KEY constraint is used to prevent actions that would destroy links between tables.

The table with the foreign key is called the child table, and the table with the primary key is 
called the referenced or parent table.

The FOREIGN KEY constraint prevents invalid data from being inserted into the foreign key column, 
because it has to be one of the values contained in the parent table.
Since, it restricts the value allowed in the foreign key column, data integrity and referantial integrity
are maintained.

/* Important Points About SQL FOREIGN KEY Constraint
-------------------------------------------------------

- A FOREIGN KEY is a field (or collection of fields) in one table, 
  that refers to the PRIMARY KEY in another table.

- The table containing the foreign key is called the Child table / Foreign table
- The table containing the candidate key / Primary Key is called the Referenced / Parent table.

- A table can have multiple FOREIGN KEY constraints.

- When defining a FOREIGN KEY constraint, you can specify what happens when a referenced row 
  in the parent table is deleted or updated. This is done using the ON DELETE and ON UPDATE clauses 
  followed by the CASCADE, SET NULL, or NO ACTION option.

                                         THING TO NOTE:
                                         --------------

A parent table can have only one primary key (though it can be composite, i.e. multiple columns together).

A child table can have many foreign keys, each referencing either:
- the same parent table, or
- different parent tables.

--------------------------------------------------------------------------------------------- 

TABLES BEING USED:

                                    FK_Persons Table
                                    ----------------

                        | PersonID | LastName  | FirstName | Age |     -- PesonID is the primary key here
                        | -------- | --------- | --------- | --- |
                        | 1        | Hansen    | Ola       | 30  |
                        | 2        | Svendson  | Tove      | 23  |
                        | 3        | Pettersen | Kari      | 20  |

                                    FK_Orders Table
                                    ---------------

                        | OrderID | OrderNumber | PersonID |           -- PersonID is the foreign key here
                        | ------- | ----------- | -------- |              Note the duplicates in the records
                        | 1       | 77895       | 3        |
                        | 2       | 44678       | 3        |
                        | 3       | 22456       | 2        |
                        | 4       | 24562       | 1        |
*/

-- Create PARENT TABLE
CREATE TABLE FK_Persons (
    PersonID INT PRIMARY KEY,
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    Age INT
);

-- Insert data into Persons
INSERT INTO FK_Persons (PersonID, LastName, FirstName, Age) VALUES
(1, 'Hansen', 'Ola', 30),
(2, 'Svendson', 'Tove', 23),
(3, 'Pettersen', 'Kari', 20);


-- CREATE CHILD TABLE with foreign key constraint at column-level
CREATE TABLE FK_Orders (
    OrderID INT PRIMARY KEY,
    OrderNumber INT NOT NULL,
    PersonID INT REFERENCES FK_Persons(PersonID) -- Column-level foreign key constraint
);

-- Insertion fails since, 9 is being inserted in foreign key column, violates referential integrity
-- only 1, 2, and 3 are allowed as per the parent table
INSERT INTO FK_Orders (OrderID, OrderNumber, PersonID) VALUES
(1, 77895, 2),
(2, 44678, 9);


-- Queries to know which column of which table under a DB has which constraints

-- This don't give columnn name
SELECT 
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'FK_Orders'
  AND TABLE_SCHEMA = 'mydb';

/*
#   CONSTRAINT_NAME	    CONSTRAINT_TYPE
-----------------------------------------
    fk_orders_ibfk_1	FOREIGN KEY
    PRIMARY	            PRIMARY KEY */

-- This gives column name too
SELECT 
    tc.CONSTRAINT_NAME,
    tc.CONSTRAINT_TYPE,
    kcu.COLUMN_NAME
FROM information_schema.TABLE_CONSTRAINTS AS tc
JOIN information_schema.KEY_COLUMN_USAGE AS kcu
  ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
  AND tc.TABLE_NAME = kcu.TABLE_NAME
WHERE tc.TABLE_NAME = 'FK_Orders'
  AND tc.TABLE_SCHEMA = 'mydb';

/* OUTPUT:

#   CONSTRAINT_NAME 	CONSTRAINT_TYPE	    COLUMN_NAME
-------------------------------------------------------
    PRIMARY	            PRIMARY KEY	        OrderID
    fk_orders_ibfk_1	FOREIGN KEY	        PersonID */

CREATE TABLE FK_Orders (
    OrderID int NOT NULL,
    OrderNumber int NOT NULL,
    PersonID int,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (PersonID) REFERENCES FK_Persons(PersonID)  -- Table-level UN-NAMED constraint
);

CREATE TABLE FK_Orders (
    OrderID int NOT NULL,
    OrderNumber int NOT NULL,
    PersonID int,
    PRIMARY KEY (OrderID),
    CONSTRAINT FK_PersonOrder FOREIGN KEY (PersonID)       -- Table-level NAMED constraint
    REFERENCES FK_Persons(PersonID)
);

-- Adding FOREIGN KEY constraint to an existing table -- UN-NAMED
ALTER TABLE Orders
ADD FOREIGN KEY (PersonID) REFERENCES Persons(PersonID);

-- Adding FOREIGN KEY constraint to an existing table -- NAMED
ALTER TABLE Orders
ADD CONSTRAINT FK_PersonOrder
FOREIGN KEY (PersonID) REFERENCES Persons(PersonID);

-- Dropping a FOREIGN KEY constraint
ALTER TABLE Orders
DROP FOREIGN KEY FK_PersonOrder; -- need to specify the name of the foreign key constraint here

-- We cannot delete a record from parent table if it has matching records in child table
-- We must first delete the dependent child table records, and then delete the parent table record

-- Fails deletion due to foreign key constraint, Delete the child record first
DELETE FROM FK_Persons WHERE PersonID = 2;

-- First delete the child record, now hitting above query again will work
DELETE FROM FK_Orders WHERE PersonID = 2;


-- Similarly we cannot directly update a primary key value in parent table if it has matching records in child table
-- This direct update is not possible, we need to first update all dependent child-table rows  and then update the parent table records
UPDATE FK_Persons SET PersonID = 30 WHERE PersonID = 3;
-----------------------------------------------------------------------------------------------

/* This manual deletion of dependent records in child table can be automated/triggered using
Cascades.

Cascades comes under the concept of Referential actions on foreign keys.

Cascade: an action triggered automatically when a change occurs in a parent table, 
propagating the update or deletion to the related child table(s). 

ON DELETE CASCADE:
-------------------
When a record in the parent table is deleted, 
all dependent related records in the child table are automatically deleted.
*/

CREATE TABLE FK_Persons (
    PersonID INT PRIMARY KEY,
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    Age INT
);

INSERT INTO FK_Persons (PersonID, LastName, FirstName, Age) VALUES
(1, 'Hansen', 'Ola', 30),
(2, 'Svendson', 'Tove', 23),
(3, 'Pettersen', 'Kari', 20),
(4, 'Donald', 'Ross', 24);


CREATE TABLE FK_Orders (
    OrderID INT PRIMARY KEY,
    OrderNumber INT NOT NULL,
    PersonID INT,
    CONSTRAINT FK_CONST FOREIGN KEY(PersonID)
    REFERENCES FK_Persons(PersonID)
    ON DELETE CASCADE -- cascades are applied on the child tables so that changes in parent table triggers actions here in the child table
);

INSERT INTO FK_Orders (OrderID, OrderNumber, PersonID) VALUES
(1, 77895, 2),
(2, 44678, 3),
(3, 44678, 2),
(4, 44678, 3),
(5, 44678, 1);

-- Automatically, PersonID = 3 records from FK_Orders (child-table) are also deleted
DELETE FROM FK_Persons WHERE PersonID = 3;

DELETE FROM FK_Orders WHERE PersonID = 3;  -- No need of this separately now

/*
ON UPDATE CASCADE:
-------------------
When a record in the parent table is updated,
all dependent related records in the child table are automatically updated. */

CREATE TABLE FK_Persons (
    PersonID INT PRIMARY KEY,
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    Age INT
);

INSERT INTO FK_Persons (PersonID, LastName, FirstName, Age) VALUES
(1, 'Hansen', 'Ola', 30),
(2, 'Svendson', 'Tove', 23),
(3, 'Pettersen', 'Kari', 20),
(4, 'Donald', 'Ross', 24);


CREATE TABLE FK_Orders (
    OrderID INT PRIMARY KEY,
    OrderNumber INT NOT NULL,
    PersonID INT,
    CONSTRAINT FK_CONST FOREIGN KEY(PersonID)
    REFERENCES FK_Persons(PersonID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

INSERT INTO FK_Orders (OrderID, OrderNumber, PersonID) VALUES
(1, 77895, 2),
(2, 44678, 3),
(3, 44678, 2),
(4, 44678, 3),
(5, 44678, 1);

-- Now this update in parent table will be cascaded/reflected in child table automatically
UPDATE FK_Persons SET PersonID = 30 WHERE PersonID = 3;

/* These cascade actions can also be added while altering the table

You cannot directly modify a foreign key in MySQL.
Instead, you must:

- Drop the existing FK
- Recreate it with the new action

-- Drop old constraint
ALTER TABLE FK_Orders
DROP FOREIGN KEY fk_person;

-- Re-add with new cascade rule
ALTER TABLE FK_Orders
ADD CONSTRAINT fk_person
FOREIGN KEY (PersonID) REFERENCES FK_Persons(PersonID)
ON DELETE SET NULL
ON UPDATE CASCADE;


*/

-----------------------------------SOME MORE ACTIONS-------------------------------------------------------

/* ON DELETE SET NULL

Child rows will remain, but the foreign key column will be set to NULL when the parent is deleted. */

CREATE TABLE FK_Persons (
    PersonID INT PRIMARY KEY,
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    Age INT
);

INSERT INTO FK_Persons (PersonID, LastName, FirstName, Age) VALUES
(1, 'Hansen', 'Ola', 30),
(2, 'Svendson', 'Tove', 23),
(3, 'Pettersen', 'Kari', 20),
(4, 'Donald', 'Ross', 24);


CREATE TABLE FK_Orders (
    OrderID INT PRIMARY KEY,
    OrderNumber INT NOT NULL,
    PersonID INT,
    CONSTRAINT FK_CONST FOREIGN KEY(PersonID)
    REFERENCES FK_Persons(PersonID)
    ON DELETE SET NULL
);

INSERT INTO FK_Orders (OrderID, OrderNumber, PersonID) VALUES
(1, 77895, 2),
(2, 44678, 3),
(3, 44678, 2),
(4, 44678, 3),
(5, 44678, 1); 


-- All dependent records in child tables are set to null
DELETE FROM FK_Persons WHERE PersonID = 3;

/*ON DELETE SET DEFAULT -- NOT SUPPORTED IN MySQL*/

/* ON DELETE RESTRICT (or NO ACTION)

    This prevents deletion if there are child rows referencing the parent.

    This is the default behaviour of the foreign key constraint in MySQL.
    No need to use this explicitly. */