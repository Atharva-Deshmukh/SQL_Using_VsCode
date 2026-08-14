/*
======================================================================
INNER JOIN → Returns ONLY rows having a matching value in BOTH tables.
======================================================================

Ex:

t1
    +--------+---------+--------+------------+
    | UserID | UserName| Sex    | RollNumber |
    +--------+---------+--------+------------+
    | 1      | John    | Male   | 11         |
    | 2      | Emma    | Female | 12         |
    | 3      | Ravi    | Male   | 13         |
    | 4      | Raj     | Female | 14         |
    +--------+---------+--------+------------+

t2
    +--------+----------+----------+---------+
    | UserID | Sub      | UserName | Surname |
    +--------+----------+----------+---------+
    | 3      | Maths    | Jarret   | Joshi   |
    | 4      | English  | Erina    | Ekare   |
    | 5      | Science  | Prashant | Patil   |
    | 6      | SSC      | Rajan    | Rawat   |
    +--------+----------+----------+---------+

Query:

SELECT *
FROM t1
INNER JOIN t2
    ON t1.UserID = t2.UserID;

OUTPUT:

+--------+---------+--------+------------+--------+---------+----------+---------+
| UserID | UserName| Sex    | RollNumber | UserID | Sub     | UserName | Surname |
+--------+---------+--------+------------+--------+---------+----------+---------+
| 3      | Ravi    | Male   | 13         | 3      | Maths   | Jarret   | Joshi   |
| 4      | Raj     | Female | 14         | 4      | English | Erina    | Ekare   |
+--------+---------+--------+------------+--------+---------+----------+---------+

WHY?

t1 UserID → 1, 2, 3, 4
t2 UserID → 3, 4, 5, 6

Common IDs → 3, 4
              ↓
        Only these rows appear.

===========================================================
JOIN + SELECT
===========================================================

You don't have to select all columns.

SELECT Users.UserName, Posts.Title
FROM Users
INNER JOIN Posts
    ON Users.UserID = Posts.UserID;

OUTPUT:

+----------+------------------+
| UserName | Title            |
+----------+------------------+
| John     | SQL Basics       |
| Emma     | Advanced Python  |
| John     | Blogging Tips    |
+----------+------------------+

→ JOIN combines rows.
→ SELECT decides which columns to display.

===========================================================
JOIN vs INNER JOIN
===========================================================

   JOIN
    ↓
 Same as
    ↓
INNER JOIN

INNER is the default JOIN type.

===========================================================
TABLE ORDER DO NOT MATTER IN INNER JOINS
===========================================================

These produce the same matching set:

SELECT Users.UserName, Posts.Title
FROM Users
INNER JOIN Posts
    ON Users.UserID = Posts.UserID;


SELECT Users.UserName, Posts.Title
FROM Posts
INNER JOIN Users
    ON Users.UserID = Posts.UserID;

→ For INNER JOIN, swapping table order does not change which matching rows exist.

===========================================================
QUALIFY COLUMNS WITH TABLE NAME
===========================================================

If a column exists in multiple joined tables, specify
which table it comes from.

Without qualification:
    SELECT UserID
    FROM Users                                         → Ambiguous if both tables have UserID.
    JOIN Posts ON Users.UserID = Posts.UserID;

Use table name:
    SELECT Users.UserID
    FROM Users
    JOIN Posts ON Users.UserID = Posts.UserID;

Or use aliases (preferred for shorter queries):

    SELECT u.UserName, p.Title
    FROM Users AS u
    JOIN Posts AS p ON p.UserID = u.UserID;

===========================================================
MULTIPLE TABLE JOINS
===========================================================

3 tables:

SELECT u.UserName, p.Title, s.ShipperName
FROM Users u
JOIN Posts p
    ON p.UserID = u.UserID
JOIN Shippers s
    ON s.UserID = u.UserID;

4 tables:

SELECT u.UserName, p.Title, s.ShipperName, r.Result
FROM Users u
JOIN Posts p
    ON p.UserID = u.UserID
JOIN Shippers s
    ON s.UserID = u.UserID
JOIN Results r
    ON r.UserID = u.UserID;

→ Each JOIN adds matching data from another table.

===========================================================
JOIN + WHERE
===========================================================

SELECT u.UserName, p.Title, s.ShipperName, r.Result
FROM Users u
JOIN Posts p
    ON p.UserID = u.UserID
JOIN Shippers s
    ON s.UserID = u.UserID
JOIN Results r
    ON r.UserID = u.UserID
WHERE r.Result = 'Pass';
