/* Returns all records from the right table and only the matching records from the left table. 
If there is no match in the left table, the result will show NULL values for the left table’s columns.

Returns all rows from the right table.
Includes only matching rows from the left table.
Non-matching rows from the left table appear as NULL

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
RIGHT JOIN t2 ON t1.UserID = t2.UserID;

/*    # UserID	    UserName	Sex	   RollNumber	  UserID	  Sub	  UserName	 Surname
--------------------------------------------------------------------------------------------
          3	          Ravi	    Male	  13	        3	      Maths	   Jarret	 Joshi
          4	          Raj	   Female	  14	        4	     English   Erina	 Ekare
		 Null          Null     Null      Null          5	     Science   Prashant	 Patil
		 Null         Null      Null      Null        	6	       SSC	   Rajan	 Rawat
*/