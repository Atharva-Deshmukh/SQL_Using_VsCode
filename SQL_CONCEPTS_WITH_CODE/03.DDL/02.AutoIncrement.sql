/* AUTO_INCREMENT automatically generates a numeric value when
a new row is inserted.

Commonly used for:

→ PRIMARY KEY / unique identifier
→ User ID
→ Employee ID
→ Order ID

===========================================================
KEY RULES
===========================================================

- You can have only one AUTO_INCREMENT column per table.
- That column must be indexed (PRIMARY KEY or UNIQUE).
- It must use a numeric data type (INT, BIGINT, etc.). 

| Default start       | 1 (commonly)                         |
| Default increment   | 1                                    |
*/

CREATE TABLE UserData (
    UserID INT AUTO_INCREMENT UNIQUE, -- auto-increment column
    UserName VARCHAR(50) NOT NULL,
    Age INT,
    City VARCHAR(50)
);

-- UserID will automatically increase by 1 for each new row inserted.
-- We don’t need to specify it manually during insertion.
INSERT INTO UserData (UserName, Age, City) VALUES
('John', 25, 'Delhi'),
('Emma', 30, 'Mumbai'),
('Ravi', 28, 'Pune'),
('Sophia', 27, 'Chennai'),
('Liam', 35, 'Bangalore'),
('Olivia', 22, 'Hyderabad'),
('Ethan', 40, 'Delhi');

/* Table created

+--------+---------+-----+-----------+
| UserID | UserName| Age | City      |
+--------+---------+-----+-----------+
|   1    | John    | 25  | Delhi     |
|   2    | Emma    | 30  | Mumbai    |
|   3    | Ravi    | 28  | Pune      |
|   4    | Sophia  | 27  | Chennai   |
|   5    | Liam    | 35  | Bangalore |
|   6    | Olivia  | 22  | Hyderabad |
|   7    | Ethan   | 40  | Delhi     |
+--------+---------+-----+-----------+ */

===========================================================
START AUTO_INCREMENT FROM A DIFFERENT VALUE
===========================================================

CREATE TABLE UserData (
    UserID INT AUTO_INCREMENT UNIQUE, -- auto-increment column
    UserName VARCHAR(50) NOT NULL,
    Age INT,
    City VARCHAR(50)
) AUTO_INCREMENT = 100;

/* Table created

+--------+---------+-----+-----------+
| UserID | UserName| Age | City      |
+--------+---------+-----+-----------+
| 100    | John    | 25  | Delhi     |
| 101    | Emma    | 30  | Mumbai    |
| 102    | Ravi    | 28  | Pune      |
| 103    | Sophia  | 27  | Chennai   |
| 104    | Liam    | 35  | Bangalore |
| 105    | Olivia  | 22  | Hyderabad |
| 106    | Ethan   | 40  | Delhi     |
+--------+---------+-----+-----------+ */

===========================================================
ADD AUTO_INCREMENT TO AN EXISTING TABLE
===========================================================

ALTER TABLE UserData MODIFY UserID INT AUTO_INCREMENT;

-- insert new values after auto-increment addition
-- Values automatically start with 4 since previous row had 3 and this is a primary key column, so unique
INSERT INTO UserData (UserName, Age, City) VALUES
('Ravi', 28, 'Pune'),
('Sophia', 27, 'Chennai');

-- We can also modify the default-start of the auto-increment while altering the table
ALTER TABLE UserData AUTO_INCREMENT = 1000;
INSERT INTO UserData (UserName, Age, City) VALUES
('Liam', 35, 'Bangalore'),
('Olivia', 22, 'Hyderabad');

/* IMPORTANT INTERVIEW POINT:

AUTO_INCREMENT guarantees generated identifiers,
NOT gap-free numbering.

Example:

1
2
3    DELETE FROM UserData WHERE UserID = 3;
4


Now:

1
2
4


The next inserted row does NOT necessarily reuse 3.
It may be: 5


Output:

+--------+
| UserID |
+--------+
| 1      |
| 2      |
| 4      |
| 5      |
+--------+

===========================================================
COMMON INTERVIEW TRAPS
===========================================================

TRAP 1:

    "AUTO_INCREMENT guarantees unique numbers forever."

    NOT EXACTLY.

    It is commonly used for unique identifiers, especially when combined with PRIMARY KEY / UNIQUE constraints.
    The uniqueness guarantee comes from the constraint.
    AUTO_INCREMENT is responsible for generating values.


TRAP 2:

    "AUTO_INCREMENT means no gaps."
    FALSE.
    Gaps are possible if any row is deleted


TRAP 3:

    "AUTO_INCREMENT always starts at 1."
    FALSE.
    The starting value can be configured.


TRAP 4:

    "DELETE resets AUTO_INCREMENT."
    Generally FALSE.
    Deleting rows does not automatically reset the counter.
*/
