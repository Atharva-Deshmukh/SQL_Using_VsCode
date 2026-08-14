/*
===========================================================
RIGHT JOIN = MATCHING LEFT + ALL RIGHT
===========================================================

RIGHT JOIN
→ Returns ALL rows from the RIGHT table.
→ Returns matching rows from the LEFT table.
→ No match → LEFT-table columns become NULL.

===========================================================
EXAMPLE
===========================================================

SELECT *
FROM t1
RIGHT JOIN t2
    ON t1.UserID = t2.UserID;

OUTPUT:

+--------+----------+--------+------------+--------+---------+----------+---------+
| UserID | UserName | Sex    | RollNumber | UserID | Sub     | UserName | Surname |
+--------+----------+--------+------------+--------+---------+----------+---------+
| 3      | Ravi     | Male   | 13         | 3      | Maths   | Jarret   | Joshi   |
| 4      | Raj      | Female | 14         | 4      | English | Erina    | Ekare   |
| NULL   | NULL     | NULL   | NULL       | 5      | Science | Prashant | Patil   |
| NULL   | NULL     | NULL   | NULL       | 6      | SSC     | Rajan    | Rawat   |
+--------+----------+--------+------------+--------+---------+----------+---------+

WHY?

t2 → RIGHT table → ALL rows retained
t1 → LEFT table → only matching rows retained

UserID 3, 4 → match found → t1 data included
UserID 5, 6 → no match in t1 → t1 columns = NULL
