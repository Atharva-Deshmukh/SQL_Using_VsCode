
-- Create DB if it do not exist
CREATE DATABASE IF NOT EXISTS myDB;

-- Select the DB/Schema we are targeting first
USE myDB;

CREATE TABLE IF NOT EXISTS Persons (
    PersonID int(12) NOT NULL,
    FirstName varchar(255),
    LastName varchar(255),
    Address varchar(255),
    City varchar(255)
);

/* INSERT Rows INTO TABLE
THERE ARE 3 WAYS TO INSERT DATA INTO A TABLE */

-- WAY-1: Insert data in every column of the table
INSERT INTO Persons VALUES (1, 'Nitish', 'Kumar', 'B-Lane', 'Pune');

-- -- WAY-2: Insert data in specific columns of the table
-- Rest other columns data will be NULL
INSERT INTO Persons (PersonID, FirstName, LastName) VALUES (2, 'Raj', 'Thakre');

-- -- WAY-3: Null insertions
-- If we want to insert full record/row, but don't know some of the column values, we can use NULL keyword
-- Later we can update those values using UPDATE command
INSERT INTO Persons (PersonID, FirstName, LastName, Address) VALUES (3, 'Rahul', 'Dravid', NULL);

-- Check the inserted data
SELECT * FROM Persons;
-- OR => SELECT * FROM mydb.persons;