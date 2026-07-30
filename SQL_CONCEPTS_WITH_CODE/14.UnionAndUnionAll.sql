/*
The UNION operator is used to combine the result-set of two or more SELECT statements.
The UNION operator automatically removes duplicate rows from the result set.

Requirements for UNION:
- Every SELECT statement within UNION must have the same number of columns
- The columns must also have similar data types
- The columns in every SELECT statement must also be in the same order

UNION Syntax
SELECT column_name(s) FROM table1
UNION
SELECT column_name(s) FROM table2;

Note: The column names in the result-set are usually equal to the column names in the first SELECT statement.

Note: SQL UNION and UNION ALL difference is that UNION operator removes duplicate rows from results set and 
UNION ALL operator retains all rows, including duplicate.

                                                TABLES USED:
                                                -----------

Customers table

| CustomerID | CustomerName                       | ContactName    | Address                       | City        | PostalCode | Country |
| ---------- | ---------------------------------- | -------------- | ----------------------------- | ----------- | ---------- | ------- |
| 1          | Alfreds Futterkiste                | Maria Anders   | Obere Str. 57                 | Berlin      | 12209      | Germany |
| 2          | Ana Trujillo Emparedados y helados | Ana Trujillo   | Avda. de la Constitución 2222 | México D.F. | 05021      | Mexico  |
| 3          | Antonio Moreno Taquería            | Antonio Moreno | Mataderos 2312                | México D.F. | 05023      | Mexico  |


Suppliers table

| SupplierID | SupplierName                | ContactName      | Address         | City        | PostalCode | Country |
| ---------- | --------------------------- | ---------------- | --------------- | ----------- | ---------- | ------- |
| 1          | Exotic Liquid               | Charlotte Cooper | 49 Gilbert St.  | London      | EC1 4SD    | UK      |
| 2          | New Orleans Cajun Delights  | Shelley Burke    | P.O. Box 78934  | New Orleans | 70117      | USA     |
| 3          | Grandma Kelly's Homestead   | Regina Murphy    | 707 Oxford Rd.  | Ann Arbor   | 48104      | USA     |

*/

-- Combine cities, only unique values will be listed after union

SELECT City FROM customers
UNION
SELECT City FROM suppliers;

/* OUTPUT:
# City
Berlin
México D.F.  --> Duplicates removed
London
New Orleans
Ann Arbor  */

-- Combine CustomerId, CustomerName, SupplierId and SupplierName,
-- The column names will be from first select statement

SELECT CustomerID, CustomerName FROM customers
UNION
SELECT SupplierID, SupplierName FROM suppliers;

/* O/P

# CustomerID	CustomerName  --> Column names from first select statement
---------------------------
1	             Alfreds Futterkiste
2	             Ana Trujillo Emparedados y helados
3	             Antonio Moreno Taquería
1	             Exotic Liquid
2	             New Orleans Cajun Delights
3	             Grandma Kelly's Homestead
*/

SELECT SupplierID, SupplierName FROM suppliers
UNION
SELECT CustomerID, CustomerName FROM customers;

/* OUTPUT:

# SupplierID	SupplierName  --> Column names from first select statement
-----------------------------
1	            Exotic Liquid
2	            New Orleans Cajun Delights
3	            Grandma Kelly's Homestead
1	            Alfreds Futterkiste
2	            Ana Trujillo Emparedados y helados
3	            Antonio Moreno Taquería
*/

-- Union with WHERE clause

SELECT City, Country FROM customers
WHERE Country = 'USA' OR Country = 'Germany'
UNION 
SELECT City, Country FROM suppliers
WHERE Country = 'USA' OR Country = 'Germany';


/* OUTPUT:

# City	     Country
---------------------
Berlin	     Germany
New Orleans	 USA
Ann Arbor	 USA
*/

-- UNION of multiple columns, with adding our own custom columnSELECT 'Customer' AS Type, ContactName, City, Country
SELECT 'Customer' AS Type, ContactName, City, Country
FROM Customers
UNION
SELECT 'Supplier', ContactName, City, Country
FROM Suppliers;

/* OUTPUT: 

# Type	    ContactName	    City	      Country
-------------------------------------------------
Customer	Maria Anders	Berlin	      Germany
Customer	Ana Trujillo	México D.F.	  Mexico
Customer	Antonio Moreno	México D.F.	  Mexico
Supplier	Charlotte Cooper	London	  UK
Supplier	Shelley Burke	New Orleans	  USA
Supplier	Regina Murphy	Ann Arbor	  USA
*/

--------------------------------------------------------------------------------------------------

/*

The UNION ALL operator is used to combine the result-set of two or more SELECT statements.
The UNION ALL operator includes all rows from each statement, including any duplicates.

Requirements for UNION ALL: 

- Every SELECT statement within UNION ALL must have the same number of columns
- The columns must also have similar data types
- The columns in every SELECT statement must also be in the same order

UNION ALL Syntax
- While the UNION operator removes duplicate values by default, the UNION ALL includes duplicate values:

SELECT column_name(s) FROM table1
UNION ALL
SELECT column_name(s) FROM table2;

Note: The column names in the result-set are usually equal to the column names in the first SELECT statement.

*/

SELECT Country FROM customers
UNION ALL
SELECT Country FROM suppliers;

/* OUTPUT:

# Country
Germany
Mexico   -- Duplicates are allowed too
Mexico
UK
USA
USA


*/




