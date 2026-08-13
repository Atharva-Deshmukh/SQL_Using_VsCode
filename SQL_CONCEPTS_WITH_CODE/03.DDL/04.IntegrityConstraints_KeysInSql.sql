/*
===========================================================
PRIMARY KEY vs FOREIGN KEY
===========================================================

+-------------------+----------------------+----------------------+
| Feature           | PRIMARY KEY          | FOREIGN KEY          |
+-------------------+----------------------+----------------------+
| Purpose           | Identifies row       | Links tables         |
| Duplicate         | NO                   | YES                  |
| NULL              | NO                   | YES*                 |
| Per table         | Only ONE             | Multiple             |
| Composite         | YES                  | YES                  |
| References table  | NO                   | YES                  |
+-------------------+----------------------+----------------------+

*Unless FK column is NOT NULL.

===========================================================
1. PRIMARY KEY
===========================================================

→ UNIQUE + NOT NULL
→ Only ONE PK per table
→ Can contain multiple columns (composite PK)

Column-level:

    CREATE TABLE UserData (
        UserID INT PRIMARY KEY,
        UserName VARCHAR(50)
    );

Table-level:

    CREATE TABLE UserData (
        UserID INT,
        UserName VARCHAR(50),
        PRIMARY KEY(UserID)
    );

Composite PK:

    CREATE TABLE UserData (
        UserID INT,
        UserName VARCHAR(50),
        PRIMARY KEY(UserID, UserName)
    );


ADD:
    ALTER TABLE UserData ADD PRIMARY KEY(UserID);

DROP:
    ALTER TABLE UserData DROP PRIMARY KEY;

===========================================================
2. FOREIGN KEY
===========================================================

→ Links CHILD table to PARENT table.
→ FK value must match a value in the parent's referenced key
  (unless the FK is NULL).

Parent:

    CREATE TABLE FK_Persons (
        PersonID INT PRIMARY KEY
    );

Child:

    CREATE TABLE FK_Orders (
        OrderID INT PRIMARY KEY,
        PersonID INT,
        FOREIGN KEY(PersonID)
            REFERENCES FK_Persons(PersonID)
    );

Parent:

    +----------+
    | PersonID |
    +----------+
    | 1        |
    | 2        |
    | 3        |
    +----------+

Valid:

INSERT INTO FK_Orders
VALUES (1, 77895, 2);

Invalid:

INSERT INTO FK_Orders
VALUES (2, 44678, 9);

→ Fails because PersonID = 9 does not exist in parent.

===========================================================
3. PARENT vs CHILD
===========================================================

+----------------------+----------------------+
| PARENT               | CHILD                |
+----------------------+----------------------+
| Has referenced key   | Has FOREIGN KEY      |
| Referenced table     | Referencing table    |
+----------------------+----------------------+

ONE parent → MANY children

===========================================================
4. FOREIGN KEY SYNTAX
===========================================================

Column-level:

    CREATE TABLE FK_Orders (
        OrderID INT PRIMARY KEY,
        PersonID INT REFERENCES FK_Persons(PersonID)
    );

Table-level:

    CREATE TABLE FK_Orders (
        OrderID INT PRIMARY KEY,
        PersonID INT,
        FOREIGN KEY(PersonID)
            REFERENCES FK_Persons(PersonID)
    );

Named:

    CREATE TABLE FK_Orders (
        OrderID INT PRIMARY KEY,
        PersonID INT,
        CONSTRAINT FK_PersonOrder
            FOREIGN KEY(PersonID)
            REFERENCES FK_Persons(PersonID)
    );

===========================================================
5. ADD / DROP FOREIGN KEY
===========================================================

ADD:

    ALTER TABLE FK_Orders
    ADD CONSTRAINT FK_PersonOrder
    FOREIGN KEY(PersonID)
    REFERENCES FK_Persons(PersonID);

DROP:
    ALTER TABLE FK_Orders DROP FOREIGN KEY FK_PersonOrder;

→ DROP FOREIGN KEY needs the FK constraint name.

===========================================================
6. FOREIGN KEY ACTIONS
===========================================================

Default behavior:
→ Parent cannot normally be deleted while referenced
  child rows exist.

ON DELETE CASCADE:

    FOREIGN KEY(PersonID)
    REFERENCES FK_Persons(PersonID)
    ON DELETE CASCADE

    Parent deleted
        ↓
    Matching child rows deleted


ON UPDATE CASCADE:

    FOREIGN KEY(PersonID)
    REFERENCES FK_Persons(PersonID)
    ON UPDATE CASCADE

    Parent key updated
        ↓
    Matching child FK values updated


ON DELETE SET NULL:

    FOREIGN KEY(PersonID)
    REFERENCES FK_Persons(PersonID)
    ON DELETE SET NULL

    Parent deleted
        ↓
    Child remains
        ↓
    Child.PersonID = NULL

    IMPORTANT:
    → FK column must allow NULL.


===========================================================
CASCADE vs SET NULL
===========================================================

CASCADE  → Delete parent → DELETE child
SET NULL → Delete parent → KEEP child + FK = NULL

===========================================================
7. CHANGE FK ACTION
===========================================================

Drop existing FK:

    ALTER TABLE FK_Orders
    DROP FOREIGN KEY FK_PersonOrder;

Recreate:

    ALTER TABLE FK_Orders
    ADD CONSTRAINT FK_PersonOrder
    FOREIGN KEY(PersonID)
    REFERENCES FK_Persons(PersonID)
    ON DELETE SET NULL
    ON UPDATE CASCADE;
