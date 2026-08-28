/* Question:

===========================================================
STUDENTS TABLE
===========================================================

+----+---------+-------+
| ID | Name    | Marks |
+----+---------+-------+
| 1  | Alice   | 95    |
| 2  | Bob     | 88    |
| 3  | Charlie | 88    |
| 4  | David   | 76    |
| 5  | Emma    | 76    |
| 6  | Frank   | 65    |
| 7  | Grace   | 55    |
+----+---------+-------+


===========================================================
GRADES TABLE
===========================================================

+-------+-----------+-----------+
| Grade | Min_Marks | Max_Marks |
+-------+-----------+-----------+
| 10    | 90        | 100       |
| 9     | 80        | 89        |
| 8     | 70        | 79        |
| 7     | 60        | 69        |
| 6     | 50        | 59        |
| 5     | 40        | 49        |
+-------+-----------+-----------+

Ketty gives Eve a task to generate a report containing three columns: Name, Grade and Mark. 
Ketty doesn't want the NAMES of those students who received a grade lower than 8. 
The report must be in descending order by grade -- i.e. higher grades are entered first. 
If there is more than one student with the same grade (8-10) assigned to them, 
order those particular students by their name alphabetically. 
Finally, if the grade is lower than 8, use "NULL" as their name and list them by their 
grades in descending order. If there is more than one student with the same grade (1-7) 
assigned to them, order those particular students by their marks in ascending order.

Write a query to help Eve.

===========================================================
SAMPLE OUTPUT
===========================================================

+---------+-------+-------+
| Name    | Grade | Marks |
+---------+-------+-------+
| Alice   | 10    | 95    |
| Bob     | 9     | 88    |
| Charlie | 9     | 88    |
| David   | 8     | 76    |
| Emma    | 8     | 76    |
| NULL    | 7     | 65    |
| NULL    | 6     | 55    |
+---------+-------+-------+
*/


Ans Query:

SELECT 
    CASE
        WHEN G.Grade >= 8 THEN S.Name
        ELSE NULL
    END,
    G.Grade,
    S.Marks 
FROM Students AS S 
JOIN Grades AS G 
    ON S.Marks BETWEEN G.Min_Mark AND G.Max_Mark   -- We can conditionally join two unrelated tables
ORDER BY G.Grade DESC,                             -- Order by when multiple conditions are there
             CASE                                  -- expression is returning a value from a column. That returned value is then used for sorting.
                WHEN G.Grade BETWEEN 8 AND 10 THEN S.Name  -- If grade between (8 and 10) -> return name and sort it in asc
             END ASC,
             CASE 
                WHEN G.Grade BETWEEN 1 AND 7 THEN S.Marks
              END ASC;