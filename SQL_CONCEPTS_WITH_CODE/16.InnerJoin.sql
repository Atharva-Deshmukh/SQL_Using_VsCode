/*  What is an SQL INNER JOIN?
An INNER JOIN is like connecting these two tables based on a 
matching piece of information (a common key) and only keeping the rows that have a match in both tables.

Only the records with common keys are extracted

t1
+--------+---------+--------+------------+
| UserID | UserName|  Sex   | RollNumber |
+--------+---------+--------+------------+
|   1    | John    | Male   |     11     |
|   2    | Emma    | Female |     12     |
|   3    | Ravi    | Male   |     13     |
|   4    | Raj     | Female |     14     |
+--------+---------+--------+------------+


t2
+--------+----------+----------+----------+
| UserID |   Sub    | UserName | Surname  |
+--------+----------+----------+----------+
|   3    | Maths    | Jarret   | Joshi    |
|   4    | English  | Erina    | Ekare    |
|   5    | Science  | Prashant | Patil    |
|   6    | SSC      | Rajan    | Rawat    |
+--------+----------+----------+----------+


SELECT *
FROM t1
INNER JOIN t2 ON t1.UserID = t2.UserID;

# UserID	UserName	Sex	    RollNumber	UserID	 Sub	  UserName	Surname
--------------------------------------------------------------------------------
   3	     Ravi	    Male	  13	      3	     Maths	  Jarret	Joshi
   4	     Raj	    Female	  14	      4	     English  Erina	    Ekare

The INNER JOIN keyword returns only the rows that have matching values in both tables.  
In this case, only UserID 3 and 4 are present in both t1 and t2, so the result includes  
Ravi (with Maths) and Raj (with English). 
UserIDs 1 and 2 from t1, and 5 and 6 from t2,  
do not appear because they don’t have matches in the other table.

FULL RECORD (ALL COLUMNS) FOR MATCHING COLUMN DATA IN BOTH TABLES IS TAKEN



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

"In real life, we use separate tables because of the normalization concept, which helps avoid data redundancy. 
Joins allow us to combine data from multiple tables to get meaningful results.


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
