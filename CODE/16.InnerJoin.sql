/*  What is an SQL INNER JOIN?
Imagine you have two tables of data. An INNER JOIN is like connecting these two tables based on a 
matching piece of information (a common key) and only keeping the rows that have a match in both tables.

Simple Analogy: You have a list of Students and a list of Courses. An Enrollment table connects them. 
An INNER JOIN between Students and Enrollment would give you only the students who are enrolled in a 
course and the details of their enrollment. Students who aren't enrolled in anything are left out.

Some Real life applications:
-----------------------------

Users

UserID	UserName
---------------
1	     John
2	     Emma
3	     Ravi

Posts

PostID	  Title	            UserID
----------------------------------
201	      SQL Basics	      1
202	      Advanced Python	  2
203	      Blogging Tips	      1 

Question => Who authored which article?

INNER JOIN Result

    SELECT UserName, Title
    FROM Users
    INNER JOIN Posts ON Users.UserID = Posts.UserID;


THE ORDER DON'T MATTER

    SELECT UserName, Title
    FROM Posts
    INNER JOIN Users ON Users.UserID = Posts.UserID;

UserName	Title
------------------
John	   SQL Basics
Emma	   Advanced Python
John	   Blogging Tips


It is a good practice to include the table name when specifying columns in the SQL statement.

SELECT Users.UserName, Posts.Title
FROM Users
JOIN Posts ON Posts.UserID = Users.UserID;

JOIN or INNER JOIN
------------------
- JOIN and INNER JOIN will return the same result.
- INNER is the default join type for JOIN, so when you write JOIN the parser actually writes INNER JOIN.

                                        MULTIPLE TABLE JOINS
                                        --------------------

                                        Without parenthesis

3 tables joined:

SELECT Users.UserName, Posts.Title, Shippers.ShipperName
FROM Users 
INNER JOIN Posts ON Posts.UserID = Users.UserID
INNER JOIN Shippers ON Users.UserID = Shippers.UserID;

4 Tables joined:

SELECT Users.UserName, Posts.Title, Shippers.ShipperName, Results.Result
FROM Users 
INNER JOIN Posts ON Posts.UserID = Users.UserID
INNER JOIN Shippers ON Users.UserID = Shippers.UserID
INNER JOIN Results ON Users.UserID = Results.UserID;


                                            With parenthesis 
                (Not mandatory, we can omit this. Paranthesis bring better readability though)

3 tables joined:

SELECT Users.UserName, Posts.Title, Shippers.ShipperName
FROM (( Users 
INNER JOIN Posts ON Posts.UserID = Users.UserID)
INNER JOIN Shippers ON Users.UserID = Shippers.UserID);

4 tables joined:

SELECT Users.UserName, Posts.Title, Shippers.ShipperName, Results.Result
FROM ((( Users 
INNER JOIN Posts ON Posts.UserID = Users.UserID)
INNER JOIN Shippers ON Users.UserID = Shippers.UserID)
INNER JOIN Results ON Users.UserID = Results.UserID);


TO SELECT ALL THE COLUMNS:
--------------------------
SELECT * 
FROM ( Posts
INNER JOIN Users ON Posts.UserID = Users.UserID);


USING WITH WHERE CLAUSE
-------------------------------

SELECT Users.UserName, Posts.Title, Shippers.ShipperName, Results.Result
FROM ((( Users 
INNER JOIN Posts ON Posts.UserID = Users.UserID)
INNER JOIN Shippers ON Users.UserID = Shippers.UserID)
INNER JOIN Results ON Users.UserID = Results.UserID)
WHERE Results.Result = 'Pass';

*/
