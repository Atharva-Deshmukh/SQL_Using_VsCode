/* Select Command can be used in multiple ways*/ 

-- Way-1: Select all columns from the table
use myDB;
SELECT * FROM Persons;

-- WAY -2: Select specific columns from the table
SELECT FirstName, Address FROM Persons;

-- ----------------------------------------------------------------------------------------
-- If you want to increase values of a column by some number we can do that in select only

use myDB;
SELECT PersonID + 100 FROM Persons;
-- This will add 100 to all values in PersonID column and show the result
