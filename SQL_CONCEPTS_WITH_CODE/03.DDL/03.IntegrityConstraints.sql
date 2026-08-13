/*
===========================================================
SQL CONSTRAINTS
===========================================================

CONSTRAINT       → PURPOSE
--------------------------
NOT NULL         → NULL not allowed
DEFAULT          → Value used when column is omitted
CHECK            → Value must satisfy condition
UNIQUE           → Duplicate values not allowed
PRIMARY KEY      → UNIQUE + NOT NULL; identifies row
FOREIGN KEY      → Maintains parent-child relationship

===========================================================
1. NOT NULL
===========================================================

CREATE TABLE Persons (
    ID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Age INT
);

INSERT INTO Persons
VALUES (1, 'John', 25);

+----+------+-----+
| ID | Name | Age |
+----+------+-----+
| 1  | John | 25  |
+----+------+-----+

NULL fails:

    INSERT INTO Persons
    VALUES (2, NULL, 30);

ALTER:

    ALTER TABLE Persons
    MODIFY COLUMN Age INT NOT NULL;

===========================================================
2. DEFAULT
===========================================================

CREATE TABLE Persons (
    ID INT,
    Name VARCHAR(100),
    City VARCHAR(50) DEFAULT 'Pune'
);

INSERT INTO Persons(ID, Name)
VALUES (1, 'John');

Output:

+----+------+------+
| ID | Name | City |
+----+------+------+
| 1  | John | Pune |
+----+------+------+

If value is provided → DEFAULT is NOT used.

INSERT INTO Persons
VALUES (2, 'Emma', 'Mumbai');

===========================================================
3. CHECK
===========================================================

CHECK → restricts values using a condition.

CREATE TABLE Persons (
    ID INT,
    Age INT CHECK(Age >= 18)
);

Valid:
    INSERT INTO Persons VALUES (1, 25);

Invalid:
    INSERT INTO Persons VALUES (2, 15);


TABLE-LEVEL CHECK:

    CREATE TABLE Persons (
        ID INT,
        Age INT,
        City VARCHAR(50),
        CHECK(Age >= 18 AND City = 'Delhi')
    );

    → Useful when condition involves multiple columns.

NAMED CHECK:

    CREATE TABLE Persons (
        ID INT,
        Age INT,
        CONSTRAINT CHK_Age CHECK(Age >= 18)
    );

DROP:
    ALTER TABLE Persons DROP CHECK CHK_Age;

===========================================================
4. UNIQUE
===========================================================

CREATE TABLE Users (
    UserID INT UNIQUE,
    Email VARCHAR(100)
);

Valid:

1
2
3

Invalid:

1
1       → duplicate


IMPORTANT:

UNIQUE
→ Duplicate non-NULL values not allowed
→ In MySQL, multiple NULLs are allowed

UNIQUE ≠ NOT NULL

PRIMARY KEY
→ UNIQUE + NOT NULL


COMPOSITE UNIQUE:

CREATE TABLE UserData (
    UserID INT,
    Age INT,
    UNIQUE(UserID, Age)
);

→ Combination must be unique.

Valid:

+--------+-----+
| UserID | Age |
+--------+-----+
| 1      | 25  |
| 2      | 25  |
| 1      | 30  |
+--------+-----+

Invalid:

+--------+-----+
| UserID | Age |
+--------+-----+
| 1      | 25  |
| 1      | 25  |  ← duplicate combination
+--------+-----+


===========================================================
5. UNIQUE vs PRIMARY KEY
===========================================================

+-------------------+----------------------+----------------------+
| Feature           | UNIQUE               | PRIMARY KEY         |
+-------------------+----------------------+----------------------+
| Duplicates        | NO                   | NO                   |
| NULL              | Allowed in MySQL     | NOT allowed          |
| Per table         | Multiple             | Only ONE              |
+-------------------+----------------------+----------------------+


===========================================================
6. ADD CONSTRAINT AFTER CREATE
===========================================================

CHECK:

    ALTER TABLE Persons
    ADD CONSTRAINT CHK_Age
    CHECK(Age >= 18);

UNIQUE:

    ALTER TABLE UserData
    ADD CONSTRAINT UQ_User
    UNIQUE(UserID, Age);
