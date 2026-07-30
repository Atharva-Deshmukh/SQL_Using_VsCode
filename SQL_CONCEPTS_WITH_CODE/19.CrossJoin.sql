/*  Cross Join (Cartesian Product)

Set A: [1, 2]       2
Set B: [a, b, c]    3

Cross join = 2 * 3 = 6

Set A         Set B
-----         -----
  1     ×      a
  1     ×      b
  1     ×      c
  2     ×      a
  2     ×      b
  2     ×      c

Each row from A combines with every row from B

CROSS JOIN in SQL generates the Cartesian product of two tables, meaning each row from the first 
table is paired with every row from the second. 
This is useful when you want all possible combinations of records. 

Since result grows as rows_in_table1 × rows_in_table2, it can get very large, so it’s best 
used with smaller tables or alongside a WHERE clause to filter results into meaningful pairs.

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
CROSS JOIN t2
ORDER BY t1.UserID ASC;

/*
# UserID	UserName	Sex	     RollNumber	UserID	Sub	        UserName	Surname
----------------------------------------------------------------------------------
    1	       John	    Male	    11	       3	Maths	    Jarret	    Joshi
    1	       John	    Male	    11	       4	English	    Erina	    Ekare
    1	       John	    Male	    11	       5	Science	    Prashant	Patil
    1	       John	    Male	    11	       6	SSC	        Rajan	    Rawat
    2	       Emma	    Female	    12	       3	Maths	    Jarret	    Joshi
    2	       Emma	    Female	    12	       4	English	    Erina	    Ekare
    2	       Emma	    Female	    12	       5	Science	    Prashant	Patil
    2	       Emma	    Female	    12	       6	SSC	        Rajan	    Rawat
    3	       Ravi	    Male	    13	       3	Maths	    Jarret	    Joshi
    3	       Ravi	    Male	    13	       4	English	    Erina	    Ekare
    3	       Ravi	    Male	    13	       5	Science	    Prashant	Patil
    3	       Ravi	    Male	    13	       6	SSC	        Rajan	    Rawat
    4	       Raj	    Female	    14	       3	Maths	    Jarret	    Joshi
    4	       Raj	    Female	    14	       4	English	    Erina	    Ekare
    4	       Raj	    Female	    14	       5	Science	    Prashant	Patil
    4	       Raj	    Female	    14	       6	SSC	        Rajan	    Rawat
*/
