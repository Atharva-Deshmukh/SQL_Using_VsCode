/*
===========================================================
LEFT JOIN = ALL LEFT + MATCHING RIGHT
===========================================================

LEFT JOIN
→ Returns ALL rows from the LEFT table.
→ Returns matching rows from the RIGHT table.
→ No match → RIGHT-table columns become NULL.

===========================================================
EXAMPLE
===========================================================

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

SELECT *
FROM t1
LEFT JOIN t2
    ON t1.UserID = t2.UserID;

OUTPUT:

+--------+----------+--------+------------+--------+---------+----------+---------+
| UserID | UserName | Sex    | RollNumber | UserID | Sub     | UserName | Surname |
+--------+----------+--------+------------+--------+---------+----------+---------+
| 1      | John     | Male   | 11         | NULL   | NULL    | NULL     | NULL    |
| 2      | Emma     | Female | 12         | NULL   | NULL    | NULL     | NULL    |
| 3      | Ravi     | Male   | 13         | 3      | Maths   | Jarret   | Joshi   |
| 4      | Raj      | Female | 14         | 4      | English | Erina    | Ekare   |
+--------+----------+--------+------------+--------+---------+----------+---------+

WHY?

t1 → LEFT table → ALL rows retained
t2 → RIGHT table → only matching rows retained

UserID 1, 2 → no match in t2 → t2 columns = NULL
UserID 3, 4 → match found → t2 data included
