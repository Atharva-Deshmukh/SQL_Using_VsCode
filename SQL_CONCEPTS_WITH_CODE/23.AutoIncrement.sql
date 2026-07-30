/* Auto-increment allows a unique number to be generated automatically 
when a new record is inserted into a table.

Often this is the primary key field that we would like to be created automatically 
every time a new record is inserted.

By default starts by 1 and increments by 1 for each new record.

Auto-increment is allowed at column-level only and not at table-level.

                                            Key rules about AUTO_INCREMENT
                                            ------------------------------
- You can have only one AUTO_INCREMENT column per table.
- That column must be indexed (PRIMARY KEY or UNIQUE).
- It must use a numeric data type (INT, BIGINT, etc.). */

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

-- We can also start auto-increment with some other number instead of default 1 always while create and alter table ops
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

/* Adding auto-incement via altering the table, after creation basically */

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
