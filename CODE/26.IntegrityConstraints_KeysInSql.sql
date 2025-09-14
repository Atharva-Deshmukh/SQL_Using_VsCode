/* Keys are also intergrity constraints in sql, writing here seprately for better understanding.

---------------------------------------------------------------------------------------------
-- PRIMARY KEY Constraint

/* Properties
---------------
- No duplicate values are allowed, i.e. The column assigned as the primary key should have UNIQUE values only.
- NO NULL values are present in the Primary key column. Hence there is a Mandatory value in the column 
  having the Primary key.
- Only one primary key per table exists although the Primary key may have multiple columns (composite primary key).
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