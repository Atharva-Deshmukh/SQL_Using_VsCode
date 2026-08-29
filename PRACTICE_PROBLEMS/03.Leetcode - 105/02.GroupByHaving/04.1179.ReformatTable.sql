/* 1179. Reformat Department Table

Table: Department

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| revenue     | int     |
| month       | varchar |
+-------------+---------+
In SQL,(id, month) is the primary key of this table.
The table has information about the revenue of each department per month.
The month has values in 
["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"].
 

Reformat the table such that there is a department id column and a revenue column for each month.
Return the result table in any order.
The result format is in the following example.

Department table:
+------+---------+-------+
| id   | revenue | month |
+------+---------+-------+
| 1    | 8000    | Jan   |
| 2    | 9000    | Jan   |
| 3    | 10000   | Feb   |
| 1    | 7000    | Feb   |
| 1    | 6000    | Mar   |
+------+---------+-------+

Output: 
+------+-------------+-------------+-------------+-----+-------------+
| id   | Jan_Revenue | Feb_Revenue | Mar_Revenue | ... | Dec_Revenue |
+------+-------------+-------------+-------------+-----+-------------+
| 1    | 8000        | 7000        | 6000        | ... | null        |
| 2    | 9000        | null        | null        | ... | null        |
| 3    | null        | 10000       | null        | ... | null        |
+------+-------------+-------------+-------------+-----+-------------+

Explanation: The revenue from Apr to Dec is null.
Note that the result table has 13 columns (1 for the department id + 12 for the months).

There is an important pattern here, normally we would do searched case:

SELECT 
    d.id AS id,
    CASE WHEN d.month = "Jan" THEN revenue ELSE NULL END AS Jan_Revenue,
    CASE WHEN d.month = "Feb" THEN revenue ELSE NULL END AS Feb_Revenue,
    CASE WHEN d.month = "Mar" THEN revenue ELSE NULL END AS Mar_Revenue,
    CASE WHEN d.month = "Apr" THEN revenue ELSE NULL END AS Apr_Revenue,
    CASE WHEN d.month = "May" THEN revenue ELSE NULL END AS May_Revenue,
    CASE WHEN d.month = "Jun" THEN revenue ELSE NULL END AS Jun_Revenue,
    CASE WHEN d.month = "Jul" THEN revenue ELSE NULL END AS Jul_Revenue,
    CASE WHEN d.month = "Aug" THEN revenue ELSE NULL END AS Aug_Revenue,
    CASE WHEN d.month = "Sep" THEN revenue ELSE NULL END AS Sep_Revenue,
    CASE WHEN d.month = "Oct" THEN revenue ELSE NULL END AS Oct_Revenue,
    CASE WHEN d.month = "Nov" THEN revenue ELSE NULL END AS Nov_Revenue,
    CASE WHEN d.month = "Dec" THEN revenue ELSE NULL END AS Dec_Revenue
FROM Department AS d
GROUP BY d.id;

But The problem here will then


id | month | revenue
---+-------+--------
1  | Jan   | 8000
1  | Feb   | 7000
1  | Mar   | 6000

CASE expressions create this:

id | Jan          | Feb          | Mar
---+--------------+--------------+--------------
1  | 8000         | NULL         | NULL
1  | NULL         | 7000         | NULL
1  | NULL         | NULL         | 6000

Then GROUP BY id says:

             GROUP 1
                ↓
       ┌────────┼────────┐
       ↓        ↓        ↓
      8000     NULL     NULL     → MAX → 8000
      NULL     7000     NULL     → MAX → 7000
      NULL     NULL     6000     → MAX → 6000

WITHOUT USING MAX(CASE...), we would be getting 3 rows for a single row
┌───────────────────────────────┐
│ id=1                          │
│                               │
│ 8000 | NULL | NULL            │
│ NULL | 7000 | NULL            │
│ NULL | NULL | 6000            │
└───────────────────────────────┘

WITH MAX AGGREGATE, we collapse the other rows to get MAX/NON-EMPTY RESULT

Final:

id | Jan  | Feb  | Mar
---+------+------+-----
1  | 8000 | 7000 | 6000

That's the entire trick.

*/

SELECT 
    d.id AS id,
    MAX(CASE WHEN d.month = "Jan" THEN revenue ELSE NULL END) AS Jan_Revenue,
    MAX(CASE WHEN d.month = "Feb" THEN revenue ELSE NULL END) AS Feb_Revenue,
    MAX(CASE WHEN d.month = "Mar" THEN revenue ELSE NULL END) AS Mar_Revenue,
    MAX(CASE WHEN d.month = "Apr" THEN revenue ELSE NULL END) AS Apr_Revenue,
    MAX(CASE WHEN d.month = "May" THEN revenue ELSE NULL END) AS May_Revenue,
    MAX(CASE WHEN d.month = "Jun" THEN revenue ELSE NULL END) AS Jun_Revenue,
    MAX(CASE WHEN d.month = "Jul" THEN revenue ELSE NULL END) AS Jul_Revenue,
    MAX(CASE WHEN d.month = "Aug" THEN revenue ELSE NULL END) AS Aug_Revenue,
    MAX(CASE WHEN d.month = "Sep" THEN revenue ELSE NULL END) AS Sep_Revenue,
    MAX(CASE WHEN d.month = "Oct" THEN revenue ELSE NULL END) AS Oct_Revenue,
    MAX(CASE WHEN d.month = "Nov" THEN revenue ELSE NULL END) AS Nov_Revenue,
    MAX(CASE WHEN d.month = "Dec" THEN revenue ELSE NULL END) AS Dec_Revenue
FROM Department AS d
GROUP BY d.id;