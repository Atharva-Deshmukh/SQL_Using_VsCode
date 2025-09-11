/* retrieves all records from the left table and only the matching records from the right table. 
If no match is found in the right table, the query will return NULL values for its columns.

Returns all rows from the left table.
Includes only matching rows from the right table.
Non-matching rows in the right table are represented as NULL

Note: In some databases LEFT JOIN is called LEFT OUTER JOIN.

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
*/

SELECT *
FROM t1
LEFT JOIN t2 ON t1.UserID = t2.UserID;

/* # UserID	    UserName	Sex	    RollNumber	UserID	  Sub	    UserName	Surname
---------------------------------------------------------------------------------------
        1	     John	    Male	   11		 Null	  Null	     Null       Null
        2	     Emma	    Female	   12		 Null	  Null       Null       Null
        3	     Ravi	    Male	   13	     3	      Maths	     Jarret	    Joshi
        4	     Raj	    Female	   14	     4	      English	 Erina	    Ekare

Here we have
- All rows from the left table
- Only Matching rows from right table
- Non-matching rows from the right table are null
*/