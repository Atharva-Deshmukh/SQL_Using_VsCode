/* 
===========================================================
CROSS JOIN (Cartesian Product)
===========================================================

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

CROSS JOIN → Every row from the LEFT table combines with
              every row from the RIGHT table.

ROWS IN RESULT = rows(t1) × rows(t2)

===========================================================
EXAMPLE
===========================================================

SELECT *
FROM t1
CROSS JOIN t2
ORDER BY t1.UserID ASC;

t1 → 4 rows
t2 → 4 rows

RESULT → 4 × 4 = 16 rows

For each t1 row:

UserID = 1 → combines with t2 rows 3, 4, 5, 6
UserID = 2 → combines with t2 rows 3, 4, 5, 6
UserID = 3 → combines with t2 rows 3, 4, 5, 6
UserID = 4 → combines with t2 rows 3, 4, 5, 6

OUTPUT:

+--------+----------+--------+------------+--------+---------+----------+---------+
| UserID | UserName | Sex    | RollNumber | UserID | Sub     | UserName | Surname |
+--------+----------+--------+------------+--------+---------+----------+---------+
| 1      | John     | Male   | 11         | 3      | Maths   | Jarret   | Joshi   |
| 1      | John     | Male   | 11         | 4      | English | Erina    | Ekare   |
| 1      | John     | Male   | 11         | 5      | Science | Prashant | Patil   |
| 1      | John     | Male   | 11         | 6      | SSC     | Rajan    | Rawat   |
| 2      | Emma     | Female | 12         | 3      | Maths   | Jarret   | Joshi   |
| 2      | Emma     | Female | 12         | 4      | English | Erina    | Ekare   |
| 2      | Emma     | Female | 12         | 5      | Science | Prashant | Patil   |
| 2      | Emma     | Female | 12         | 6      | SSC     | Rajan    | Rawat   |
| 3      | Ravi     | Male   | 13         | 3      | Maths   | Jarret   | Joshi   |
| 3      | Ravi     | Male   | 13         | 4      | English | Erina    | Ekare   |
| 3      | Ravi     | Male   | 13         | 5      | Science | Prashant | Patil   |
| 3      | Ravi     | Male   | 13         | 6      | SSC     | Rajan    | Rawat   |
| 4      | Raj      | Female | 14         | 3      | Maths   | Jarret   | Joshi   |
| 4      | Raj      | Female | 14         | 4      | English | Erina    | Ekare   |
| 4      | Raj      | Female | 14         | 5      | Science | Prashant | Patil   |
| 4      | Raj      | Female | 14         | 6      | SSC     | Rajan    | Rawat   |
+--------+----------+--------+------------+--------+---------+----------+---------+
