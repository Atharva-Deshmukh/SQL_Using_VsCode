/*
===========================================================
SQL CONSTRAINTS
===========================================================

CONSTRAINTS → Restrict/validate data to maintain integrity.

+----------------+----------------------------------------------+
| Constraint     | Purpose                                      |
+----------------+----------------------------------------------+
| NOT NULL       | Column cannot contain NULL                  |
| DEFAULT        | Provides value when none is supplied        |
| CHECK          | Value must satisfy a condition              |
| UNIQUE         | Prevents duplicate values                   |
| PRIMARY KEY    | UNIQUE + NOT NULL; identifies each row      |
| FOREIGN KEY    | Maintains relationship with another table   |
+----------------+----------------------------------------------+

COLUMN LEVEL
    → Defined with a column.

TABLE LEVEL
    → Defined separately; useful for composite constraints.

Constraints can be added/modified/dropped after creation.


===========================================================
1. NOT NULL
===========================================================

Prevents a column from storing NULL.

    CREATE TABLE Persons (
        ID INT NOT NULL,
        Name VARCHAR(100) NOT NULL,
        Age INT
    );


    INSERT INTO Persons(ID, Name, Age)
    VALUES (1, 'John', 25);


Output:

    +----+------+-----+
    | ID | Name | Age |
    +----+------+-----+
    | 1  | John | 25  |
    +----+------+-----+


This fails:

    INSERT INTO Persons(ID, Name)
    VALUES (2, NULL);


ALTER:

    ALTER TABLE Persons
    MODIFY COLUMN Age INT NOT NULL;


To allow NULL again:

    ALTER TABLE Persons
    MODIFY COLUMN Age INT NULL;

===========================================================
2. DEFAULT
===========================================================

Provides a value when the column is omitted during INSERT.

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


If City is explicitly provided, DEFAULT is not used.

    INSERT INTO Persons(ID, Name, City)
    VALUES (2, 'Emma', 'Mumbai');


Output:

    +----+------+--------+
    | ID | Name | City   |
    +----+------+--------+
    | 1  | John | Pune   |
    | 2  | Emma | Mumbai |
    +----+------+--------+


===========================================================
3. CHECK
===========================================================

Restricts values using a condition.

Column-level:

    CREATE TABLE ProgrammingLanguages (
        lang_id INT,
        language_name VARCHAR(50),
        first_release_year INT CHECK(first_release_year > 1900)
    );


    This succeeds:
        INSERT INTO ProgrammingLanguages
        VALUES (1, 'Java', 1995);


    This fails:
        INSERT INTO ProgrammingLanguages
        VALUES (2, 'Java', 1800);


Table-level CHECK:

    CREATE TABLE Persons (
        ID INT,
        Age INT,
        City VARCHAR(50),
        CHECK(Age >= 18 AND City = 'Delhi')
    );


    TABLE LEVEL → useful when condition involves multiple columns.


-----------------------------------------------------------
NAMING CHECK CONSTRAINT
-----------------------------------------------------------

CREATE TABLE Persons (
    ID INT,
    Age INT,
    CONSTRAINT CHK_Age CHECK(Age >= 18)
);


Then:
    ALTER TABLE Persons DROP CHECK CHK_Age;


If not explicitly named, MySQL generates a name.


===========================================================
4. UNIQUE
===========================================================

Ensures that duplicate non-NULL values are not allowed.

CREATE TABLE UserData (
    UserID INT UNIQUE,
    UserName VARCHAR(50)
);

Valid:

1
2
3

Invalid:

1
1

-----------------------------------------------------------
UNIQUE + NULL
-----------------------------------------------------------

In MySQL, UNIQUE allows multiple NULL values.

CREATE TABLE Users (
    Email VARCHAR(100) UNIQUE
);


Valid:

    'a@example.com'
    'b@example.com'
    NULL
    NULL

But:

    'a@example.com'
    'a@example.com'

    → Duplicate key error.

IMPORTANT:
    UNIQUE ≠ NOT NULL
    PRIMARY KEY = UNIQUE + NOT NULL


-----------------------------------------------------------
COMPOSITE UNIQUE
-----------------------------------------------------------

CREATE TABLE UserData (
    UserID INT,
    Age INT,
    UNIQUE(UserID, Age)
);


This means:
    (UserID, Age) combination must be unique.
    Individual uniqueness does not matter


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
| Duplicate values  | Not allowed          | Not allowed          |
| NULL              | Allowed in MySQL     | Not allowed          |
| Per table         | Multiple allowed     | Only one             |
+-------------------+----------------------+----------------------+


===========================================================
ADD CONSTRAINT AFTER CREATE
===========================================================

CHECK:
    ALTER TABLE Persons ADD CHECK(Age >= 18);


Named CHECK:
    ALTER TABLE Persons
    ADD CONSTRAINT CHK_PersonAge
    CHECK(Age >= 18 AND City = 'Delhi');


UNIQUE:
    ALTER TABLE UserData ADD UNIQUE(UserID, Age);


Named UNIQUE:
    ALTER TABLE UserData
    ADD CONSTRAINT AD_UN
    UNIQUE(UserID, Age);


===========================================================
FIND CONSTRAINT NAMES
===========================================================

SELECT CONSTRAINT_NAME
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'ProgrammingLanguages'
AND CONSTRAINT_TYPE = 'CHECK';  // OR AND CONSTRAINT_TYPE = 'UNIQUE';

