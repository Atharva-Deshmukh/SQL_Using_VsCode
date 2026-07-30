/* A view is just a query that pretends to be a table. There are a few uses for this.

Abstraction:
maybe you have to join data from dozens of different tables to get all the data needed for a specific 
type of report. So you can abstract that detail away by creating a view that pulls all that data together 
and just query it as if all that data was stored nicely joined together already.
Its just a SELECT statement that is aliased as a table.
A view is basically like an alias (or a saved shortcut) for a SQL query.
This alias/logic/query can then be reused in multiple places.

Views are not duplicated data

Security:
You don't want to give any more access to people than they need. By creating a view and only giving 
access to the view instead of the underlying tables, the user will only be able to query what you have 
specifically selected for in the view.

Efficiency:
If you know that your users are going to have to query a specific domain of data that will require 
several different tables all joined together in a specific way, it's more efficient 
(from a development perspective) and consistent to just have a single view they can all use.


Changes to base tables are reflected automatically in views

Disadvantages:
- Since view are created when a query requesting data from view is triggered, its bit slow
- When views are created for large tables, it occupy more memory .
- Views can hide performance-heavy joins and logic, which makes it look simple to the user but actually runs a very expensive query in the background.
- Views are read-only. They can be updated in certain conditions only
    The MySQL docs say: a view is updatable if it selects from exactly one table and does not use:
    => DISTINCT
    => GROUP BY or HAVING
    => UNION or UNION ALL
    => Aggregate functions
    => Subqueries in the select list
    => Joins (in most cases)
*/

--------------------------------------- CREATING A NEW VIEW ---------------------------------------------------

/*  TABLES USED:

t1: 

# UserID	UserName	Sex	    RollNumber
------------------------------------------
    1	    John	    Male	    11
    2	    Emma	    Female	    12
    3	    Ravi	    Male	    13
    4	    Raj	        Female	    14

t2:

#  UserID	    Sub	        UserName	Surname
------------------------------------------------
    3	        Maths	    Jarret	    Joshi
    4	        English	    Erina	    Ekare
    5	        Science	    Prashant	Patil
    6	        SSC	        Rajan	    Rawat
*/

-- Creating a simple view from a single table
CREATE VIEW AD_VIEW AS
SELECT UserID, Sex, RollNumber
FROM t1
WHERE RollNumber >= 12;

/* OUTPUT:
# UserID	Sex	    RollNumber
------------------------------
    2	    Female	    12
    3	    Male	    13
    4	    Female	    14
*/

-- Creating a little complex view on multiple tables
CREATE VIEW ComplexView AS
SELECT t1.UserName, t1.Sex, t2.Sub, emp_manager.EmpName
FROM t1, t2, emp_manager
WHERE emp_manager.EmpName = 'Atharva';

SELECT * FROM ComplexView;

/* OUTPUT:

#   UserName	Sex	    Sub	    EmpName
----------------------------------------
    Raj	        Female	Maths	Atharva
    Ravi	    Male	Maths	Atharva
    Emma	    Female	Maths	Atharva
    John	    Male	Maths	Atharva
    Raj	        Female	English	Atharva
    Ravi	    Male	English	Atharva
    Emma	    Female	English	Atharva
    John	    Male	English	Atharva
    Raj	        Female	Science	Atharva
    Ravi	    Male	Science	Atharva
    Emma	    Female	Science	Atharva
    John	    Male	Science	Atharva
    Raj	        Female	SSC	    Atharva
    Ravi	    Male	SSC	    Atharva
    Emma	    Female	SSC	    Atharva
    John	    Male	SSC	    Atharva  */

--------------------------------------- VIEWING ALL VIEWS IN A TABLE --------------------------------

-- To see all the views in a DB
SHOW FULL TABLES WHERE table_type LIKE "%VIEW";

/* OUTPUT:

# Tables_in_mydb	Table_type
------------------------------
    ad_view	        VIEW
    complexview	    VIEW  */


--------------------------------------- UPDATING A VIEW -----------------------------------------------

/* Rules to Update Views in SQL:
--------------------------------

If any of these conditions are not met, the view can not be updated.

- The SELECT statement which is used to create the view should not include GROUP BY clause or ORDER BY clause.
- The SELECT statement should not have the DISTINCT keyword.
- The View should have all NOT NULL values.
- The view should not be created using nested queries or complex queries.
- The view should be created from a single table.
  If the view is created using multiple tables then we will not be allowed to update the view.
*/

-- Updating a view (this view is UPDATABLE since it is simple one and statisfies all the conditions of the update)
SET SQL_SAFE_UPDATES = 0;  -- this is to disable safe updates mode in MySQL Workbench

UPDATE AD_VIEW
SET Sex = 'Other'
WHERE UserID = 3;  
-- This updates the base table t1 as well as view do not have data of its own, 
-- it just shows data from base table
 
SET SQL_SAFE_UPDATES = 1; -- (optional) turn it back on

-- Also, updates in a table is reflected in the view also
UPDATE t1
SET RollNumber = 122
WHERE RollNumber = 12;

SELECT * FROM AD_VIEW;

/* OUTPUT:

# UserID	Sex	    RollNumber
------------------------------
    2	    Female	    122
    3	    Other	    13
    4	    Female	    14
*/


/*CREATE OR REPLACE VIEW
- If the view does not exist → it creates it.
- If the view already exists → it replaces (redefines) it with the new query.
- Data in the underlying tables is not affected — only the definition of the view changes. */

CREATE OR REPLACE VIEW AD_VIEW AS
SELECT UserID, Sub, UserName, Surname
FROM t2
WHERE UserID >= 4;


SELECT * FROM AD_VIEW;

/* OUTPUT:

# UserID	Sub	        UserName	Surname
-------------------------------------------
    4	    English	    Erina	    Ekare
    5	    Science	    Prashant	Patil
    6	    SSC	        Rajan	    Rawat
*/

/* INSERTING IN A VIEW 

We can only insert into a view if it is updatable (i.e. it satisfies all the conditions mentioned above).
i.e. Created from a single table without using DISTINCT, GROUP BY, etc.
*/

INSERT INTO AD_VIEW(UserID, Sub, UserName, Surname)
VALUES(7, 'Compiler Design', 'Atharva', 'Deshmukh');

SELECT * FROM AD_VIEW;

/* OUTPUT:

# UserID	Sub	            UserName	Surname
-----------------------------------------------
    4	    English	        Erina	    Ekare
    5	    Science	        Prashant	Patil
    6	    SSC	            Rajan	    Rawat
    7	    Compiler Design	Atharva	    Deshmukh */


/* DROPPING/DELETING A VIEW */
DROP VIEW AD_VIEW;

/*Deleting a row from the view*/
CREATE OR REPLACE VIEW AD_VIEW AS
SELECT UserID, Sub, UserName, Surname
FROM t2
WHERE UserID >= 4;

-- Deleting a row from the view created from a single table is possible
DELETE FROM AD_VIEW WHERE UserID = 6;

-- Creating a little complex view on multiple tables
CREATE VIEW ComplexView AS
SELECT t1.UserName, t1.Sex, t2.Sub, emp_manager.EmpName
FROM t1, t2, emp_manager
WHERE emp_manager.EmpName = 'Atharva';

-- Deleting a row from a view that is created from multiple tables is not possible
-- It gives error
-- Error: Error Code: 1395. Can not delete from join view 'mydb.complexview'
DELETE FROM ComplexView
WHERE Sub = 'English';


/* WITH CHECK OPTION 

 It applies to an updatable view. It is used to prevent data modification (using INSERT or UPDATE) if 
 the condition in the WHERE clause in the CREATE VIEW statement is not satisfied.

 A view without a WHERE clause just shows all rows from the base table(s).
In such a case, there’s no restriction, so every row in the base table automatically satisfies 
the view definition.
Therefore, WITH CHECK OPTION has no effect on such views.


The key point is:

- DELETE always needs to match the WHERE clause of the view → so WITH CHECK OPTION does not change 
  delete behavior.
- UPDATE/INSERT are different: without CHECK OPTION, you can insert/update data that doesn’t 
  satisfy the view condition → it goes into the base table, but disappears from the view.
- With CHECK OPTION, MySQL rejects such operations.
*/

-- First of all, since view don't show all the columns, and some invisible columns may have NOT NULL constraint,
-- we need to disable safe updates mode in MySQL Workbench
ALTER TABLE t1 
MODIFY UserName VARCHAR(100) NOT NULL DEFAULT 'DEFAULT_USER';

-- Now create the view and insert violating the where condition
CREATE OR REPLACE VIEW AD_VIEW AS
SELECT UserID, Sex, RollNumber
FROM t1
WHERE UserID > 1;

-- This insertion is possible without WITH CHECK OPTION clause
-- although it violates where condition
INSERT INTO AD_VIEW(UserID, Sex, RollNumber) 
VALUES(0, 'Female', 77);

SELECT * FROM AD_VIEW;

/* OUTPUT:

View will be as it is since view is created by where contraint

# UserID	Sex	    RollNumber
------------------------------
    2	    Female	    122
    3	    Other	    13
    4	    Female	    14
    0	    Female	    77


But the underlying table t1 will have the new row

# UserID	UserName	    Sex	    RollNumber
-----------------------------------------------
    1	    John	        Male	    11
    2	    Emma	        Female	    122
    3	    Ravi	        Other	    13
    4	    Raj	            Female	    14
    0	    DEFAULT_USER	Female	    77  -- New row inserted */

CREATE OR REPLACE VIEW AD_VIEW AS
SELECT UserID, Sex, RollNumber
FROM t1
WHERE UserID > 3
WITH CHECK OPTION;

-- Insertion blocked: Message: Error Code: 1369. CHECK OPTION failed 'mydb.ad_view'
INSERT INTO AD_VIEW(UserID, Sex, RollNumber) 
VALUES(1, 'Female', 77);

/* UPDATE CONDITION */

CREATE OR REPLACE VIEW AD_VIEW AS
SELECT UserID, Sex, RollNumber
FROM t1
WHERE UserID <= 1;

-- This update is possible
SET SQL_SAFE_UPDATES = 0;
UPDATE AD_VIEW
SET Sex = 'OTHER' 
WHERE UserID = 4;

CREATE OR REPLACE VIEW AD_VIEW AS
SELECT UserID, Sex, RollNumber
FROM t1
WHERE UserID <= 1
WITH CHECK OPTION;

-- This update is BLOCKED:
-- Error -> Error Code: 1369. CHECK OPTION failed 'mydb.ad_view'
-- UserId check is violated hence error, but other column update is possible untill
-- userId is not changed
UPDATE AD_VIEW
SET UserId = 5 
WHERE UserID = 1;