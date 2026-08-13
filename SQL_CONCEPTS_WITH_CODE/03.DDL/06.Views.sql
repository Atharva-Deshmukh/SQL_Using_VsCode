/*
===========================================================
VIEWS
===========================================================

VIEW → Saved SELECT query that behaves like a virtual table.

→ Does NOT store a separate copy of the data.
→ Reads data from underlying/base table(s).
→ Changes in base tables are reflected in the view.

Main uses:
→ Hide complex queries/joins.
→ Restrict columns/rows for security.
→ Reuse common query logic.

===========================================================
WITHOUT A VIEW
===========================================================

Employees

    +----+--------+--------+--------+
    | ID | Name   | Dept   | Salary |
    +----+--------+--------+--------+
    | 1  | John   | IT     | 80000  |
    | 2  | Emma   | HR     | 60000  |
    | 3  | Ravi   | IT     | 90000  |
    | 4  | Raj    | Sales  | 70000  |
    +----+--------+--------+--------+

Every time we need IT employees:

SELECT Name, Salary FROM Employees WHERE Dept = 'IT';

Output:

    +------+--------+
    | Name | Salary |
    +------+--------+
    | John | 80000  |
    | Ravi | 90000  |
    +------+--------+

If this query is needed repeatedly, we have to write the same query logic repeatedly.

===========================================================
WITH A VIEW
===========================================================

Create the query once:

    CREATE VIEW IT_Employees AS
    SELECT Name, Salary
    FROM Employees
    WHERE Dept = 'IT';

Now simply:

    SELECT * FROM IT_Employees;

Output:

+------+--------+
| Name | Salary |
+------+--------+
| John | 80000  |
| Ravi | 90000  |
+------+--------+

-----------------------------------------------------------
CREATE VIEW
-----------------------------------------------------------

CREATE VIEW AD_VIEW AS
SELECT UserID, Sex, RollNumber FROM t1 WHERE RollNumber >= 12;

SELECT * FROM AD_VIEW;

OUTPUT:

    +--------+--------+------------+
    | UserID | Sex    | RollNumber |
    +--------+--------+------------+
    | 2      | Female | 12         |
    | 3      | Male   | 13         |
    | 4      | Female | 14         |
    +--------+--------+------------+

-----------------------------------------------------------
VIEW USING MULTIPLE TABLES
-----------------------------------------------------------

CREATE VIEW ComplexView AS
SELECT t1.UserName, t1.Sex, t2.Sub
FROM t1
JOIN t2 ON t1.UserID = t2.UserID;

→ Useful for hiding complex JOIN logic.

-----------------------------------------------------------
VIEW vs TABLE
-----------------------------------------------------------

TABLE → Stores data
VIEW  → Stores query definition; reads underlying data

Base table changes
        ↓
View automatically reflects the change

-----------------------------------------------------------
VIEW UPDATES
-----------------------------------------------------------

Suppose we have: t1

+--------+--------+------------+
| UserID | Sex    | RollNumber |
+--------+--------+------------+
| 1      | Male   | 11         |
| 2      | Female | 12         |
| 3      | Male   | 13         |
+--------+--------+------------+

CREATE VIEW AD_VIEW AS
SELECT UserID, Sex, RollNumber
FROM t1;

The view shows: AD_VIEW

+--------+--------+------------+
| UserID | Sex    | RollNumber |
+--------+--------+------------+
| 1      | Male   | 11         |
| 2      | Female | 12         |
| 3      | Male   | 13         |
+--------+--------+------------+

UPDATE AD_VIEW
SET Sex = 'Other'
WHERE UserID = 3;

--> "Change Sex of UserID 3 in the data represented by this view."

Since the view is based directly on t1:

        UPDATE AD_VIEW
              ↓
        underlying table
              ↓
              t1

So t1 becomes:

+--------+--------+------------+
| UserID | Sex    | RollNumber |
+--------+--------+------------+
| 1      | Male   | 11         |
| 2      | Female | 12         |
| 3      | Other  | 13         |
+--------+--------+------------+


And the view also shows:

+--------+--------+------------+
| UserID | Sex    | RollNumber |
+--------+--------+------------+
| 1      | Male   | 11         |
| 2      | Female | 12         |
| 3      | Other  | 13         |
+--------+--------+------------+

INSERT INTO AD_VIEW(UserID, Sex, RollNumber)
VALUES(4, 'Female', 14);

Again:

INSERT INTO AD_VIEW
        ↓
underlying table
        ↓
        t1

So t1 becomes:

+--------+--------+------------+
| UserID | Sex    | RollNumber |
+--------+--------+------------+
| 1      | Male   | 11         |
| 2      | Female | 12         |
| 3      | Other  | 13         |
| 4      | Female | 14         |
+--------+--------+------------+


CONCLUSION:

        SIMPLE VIEW:

            View
            ↓
            One base-table row
            ↓
            Easy to map
            ↓
            Usually updatable


        COMPLEX VIEW:

            View
            ↓
            JOIN / GROUP BY / DISTINCT / AGGREGATE / etc.
            ↓
            Result may not map to one specific base-table row
            ↓
            Usually not updatable

-----------------------------------------------------------
CREATE OR REPLACE VIEW
-----------------------------------------------------------

CREATE OR REPLACE VIEW AD_VIEW AS
SELECT UserID, Sex, RollNumber
FROM t1
WHERE UserID >= 4;

→ Creates the view if it doesn't exist.
→ Replaces its definition if it exists.
→ Does NOT modify existing base-table data.

-----------------------------------------------------------
VIEW INFORMATION
-----------------------------------------------------------

SHOW FULL TABLES WHERE table_type = 'VIEW';

OUTPUT:

    +----------------+------------+
    | Tables_in_mydb | Table_type |
    +----------------+------------+
    | AD_VIEW        | VIEW       |
    | ComplexView    | VIEW       |
    +----------------+------------+

-----------------------------------------------------------
DROP VIEW
-----------------------------------------------------------

DROP VIEW AD_VIEW;
→ Removes the view.
→ Does NOT delete the underlying table/data.

===========================================================
INSERT/UPDATE VIEW WITH CHECK OPTION
===========================================================

VIEW WHERE condition
        ↓
WITH CHECK OPTION
        ↓
INSERT / UPDATE must satisfy condition
        ↓
Otherwise → REJECT

Suppose the base table is: t1

    +--------+--------+------------+
    | UserID | Sex    | RollNumber |
    +--------+--------+------------+
    | 1      | Male   | 11         |
    | 2      | Female | 12         |
    | 3      | Male   | 13         |
    +--------+--------+------------+

WITHOUT CHECK OPTION:

Create a view:

    CREATE VIEW AD_VIEW AS
    SELECT UserID, Sex, RollNumber
    FROM t1
    WHERE UserID > 1;


The view can see ONLY:

    +--------+--------+------------+
    | UserID | Sex    | RollNumber |
    +--------+--------+------------+
    | 2      | Female | 12         |
    | 3      | Male   | 13         |
    +--------+--------+------------+

Now:

INSERT INTO AD_VIEW
VALUES (0, 'Female', 77);

t1:

    +--------+--------+------------+
    | UserID | Sex    | RollNumber |
    +--------+--------+------------+
    | 1      | Male   | 11         |
    | 2      | Female | 12         |
    | 3      | Male   | 13         |
    | 0      | Female | 77         |  ← inserted
    +--------+--------+------------+


AD_VIEW:

    +--------+--------+------------+
    | UserID | Sex    | RollNumber |
    +--------+--------+------------+
    | 2      | Female | 12         |
    | 3      | Male   | 13         |
    +--------+--------+------------+

The view's WHERE condition has UserID > 1 but 0 was allowed to be inserted.
Hence The row exists in the base table but is invisible through the view.


WITHOUT CHECK OPTION:

Now create:

    CREATE OR REPLACE VIEW AD_VIEW AS
    SELECT UserID, Sex, RollNumber
    FROM t1
    WHERE UserID > 1
    WITH CHECK OPTION;


Try:

    INSERT INTO AD_VIEW
    VALUES (0, 'Female', 77);


SQL checks --> UserID > 1 --> 0 > 1 → FALSE

Therefore:
→ INSERT is REJECTED.
→ Base table is NOT changed.