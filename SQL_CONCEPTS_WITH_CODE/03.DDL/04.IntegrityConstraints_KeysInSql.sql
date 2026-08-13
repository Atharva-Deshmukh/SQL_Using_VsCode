/*
===========================================================
PRIMARY KEY vs FOREIGN KEY
===========================================================

PRIMARY KEY → Uniquely identifies a row in its own table.
FOREIGN KEY → Links a child table to a parent table.

+----------------------+----------------------------+-----------------------------+
| Feature              | PRIMARY KEY               | FOREIGN KEY                 |
+----------------------+----------------------------+-----------------------------+
| Purpose              | Identifies each row       | Maintains table relationship |
| Duplicate values     | NOT allowed               | Allowed                     |
| NULL                 | NOT allowed               | Allowed unless NOT NULL     |
| Per table            | Only ONE PK               | Multiple FKs allowed        |
| Can have multiple    | YES, composite PK         | YES, can reference columns  |
| columns              |                           |                             |

| References another   | NO                        | YES                         |
| table                |                           |                             |
+----------------------+----------------------------+-----------------------------+


===========================================================
1. PRIMARY KEY
===========================================================

Properties:

→ UNIQUE
→ NOT NULL
→ Only ONE primary key per table
→ Can contain multiple columns → COMPOSITE PRIMARY KEY

Column-level:

    CREATE TABLE UserData (
        UserID INT PRIMARY KEY,
        UserName VARCHAR(50),
        Age INT
    );


Table-level:

    CREATE TABLE UserData (
        UserID INT,
        UserName VARCHAR(50),
        Age INT,
        PRIMARY KEY(UserID)
    );


Composite primary key:

    CREATE TABLE UserData (
        UserID INT,
        UserName VARCHAR(50),
        PRIMARY KEY(UserID, UserName)
    );


===========================================================
2. ADD / DROP PRIMARY KEY
===========================================================

Add:
    ALTER TABLE UserData
    ADD PRIMARY KEY(UserID);


Named:
    ALTER TABLE UserData
    ADD CONSTRAINT AD_PK PRIMARY KEY(UserID);


Drop:
    ALTER TABLE UserData
    DROP PRIMARY KEY;


NOTE: 
    MySQL has only ONE PRIMARY KEY per table,
    so DROP PRIMARY KEY does not need a constraint name.

===========================================================
3. FOREIGN KEY
===========================================================

FOREIGN KEY maintains referential integrity between tables.

Parent table
    → Contains referenced PRIMARY KEY.

Child table
    → Contains FOREIGN KEY.


+----------------------+-----------------------------+
| Parent               | Child                       |
+----------------------+-----------------------------+
| FK_Persons           | FK_Orders                   |
| PersonID = 1         | PersonID = 1               |
| PersonID = 2         | PersonID = 2               |
| PersonID = 3         | PersonID = 3               |
+----------------------+-----------------------------+


A child FK value must reference a valid value in the parent's referenced key.


Parent:

    CREATE TABLE FK_Persons (
        PersonID INT PRIMARY KEY,
        LastName VARCHAR(50),
        FirstName VARCHAR(50)
    );


Child:

    CREATE TABLE FK_Orders (
        OrderID INT PRIMARY KEY,
        OrderNumber INT,
        PersonID INT,
        FOREIGN KEY(PersonID) REFERENCES FK_Persons(PersonID) -- Every non-NULL FK_Orders.PersonID must match a FK_Persons.PersonID
    );                                                           So the child table is not allowed to invent a person
                     

If parent contains:
    1
    2
    3


Then this is valid:
    INSERT INTO FK_Orders VALUES (1, 77895, 2);

But:
    INSERT INTO FK_Orders VALUES (2, 44678, 9); -- because PersonID = 9 does not exist in the parent.

===========================================================
PARENT vs CHILD Table
===========================================================

+----------------------+-----------------------------+
| Parent table         | Child table                 |
+----------------------+-----------------------------+
| Contains PK          | Contains FK                 |
| Referenced table     | Referencing table           |
+----------------------+-----------------------------+

One parent row can have MANY child rows.

===========================================================
COLUMN vs TABLE LEVEL FOREIGN KEY
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
        FOREIGN KEY(PersonID) REFERENCES FK_Persons(PersonID)
    );


Named:

    CREATE TABLE FK_Orders (
        OrderID INT PRIMARY KEY,
        PersonID INT,
        CONSTRAINT FK_PersonOrder FOREIGN KEY(PersonID) REFERENCES FK_Persons(PersonID)
    );


===========================================================
6. ADD / DROP FOREIGN KEY
===========================================================

Add:
    ALTER TABLE Orders
    ADD FOREIGN KEY(PersonID) REFERENCES Persons(PersonID);


Named:
    ALTER TABLE Orders
    ADD CONSTRAINT FK_PersonOrder FOREIGN KEY(PersonID) REFERENCES Persons(PersonID);


Drop:
    ALTER TABLE Orders
    DROP FOREIGN KEY FK_PersonOrder;


NOTE:
    Since Foreign keys aren't unique always, DROP FOREIGN KEY requires the FOREIGN KEY constraint name.


===========================================================
DEFAULT FOREIGN KEY BEHAVIOUR
===========================================================

Without a cascade action:
    Parent row cannot normally be deleted if child rows reference it.

===========================================================
ON DELETE CASCADE
===========================================================

Automatically deletes matching child rows when the parent row is deleted.

FOREIGN KEY(PersonID)
REFERENCES FK_Persons(PersonID)
ON DELETE CASCADE

ON DELETE CASCADE
→ Delete parent
→ Automatically delete matching children.

===========================================================
ON UPDATE CASCADE
===========================================================

Automatically updates matching child FK values when the
referenced parent key changes.

FOREIGN KEY(PersonID)
REFERENCES FK_Persons(PersonID)
ON UPDATE CASCADE

ON UPDATE CASCADE
→ Update parent key
→ Automatically update matching children.

===========================================================
ON DELETE SET NULL
===========================================================

Parent is deleted.
Child rows remain.
Their FK value becomes NULL.

FOREIGN KEY(PersonID)
REFERENCES FK_Persons(PersonID)
ON DELETE SET NULL


IMPORTANT:
    The child FK column must allow NULL.


CASCADE   → delete child
SET NULL  → keep child, remove relationship

===========================================================
CHANGING A FOREIGN KEY ACTION
===========================================================

You generally don't modify the existing FK action directly.

Drop the existing FK:

ALTER TABLE FK_Orders DROP FOREIGN KEY FK_CONST;

Recreate it:

    ALTER TABLE FK_Orders
    ADD CONSTRAINT FK_CONST
    FOREIGN KEY(PersonID)
    REFERENCES FK_Persons(PersonID)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

===========================================================
FIND CONSTRAINTS
===========================================================

Constraint names/types:

SELECT
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'FK_Orders'
AND TABLE_SCHEMA = 'mydb';

Example:

+------------------+-----------------+-------------+
| CONSTRAINT_NAME  | CONSTRAINT_TYPE | COLUMN_NAME |
+------------------+-----------------+-------------+
| PRIMARY          | PRIMARY KEY     | OrderID     |
| FK_PersonOrder   | FOREIGN KEY     | PersonID    |
+------------------+-----------------+-------------+
*/