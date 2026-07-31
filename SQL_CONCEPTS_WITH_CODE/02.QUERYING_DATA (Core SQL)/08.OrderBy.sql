/**********************************************************************
                            ORDER BY
**********************************************************************/

/*
ORDER BY sorts the result set.

Default:
ASC (Ascending)

DESC:
Sorts in descending order.
*/

----------------------------------------------------------------------
Ascending Order (Default)
----------------------------------------------------------------------

SELECT *
FROM Product
ORDER BY Price;

Output

+-----------+-------------------------------+-------+
| ProductID | ProductName                   | Price |
+-----------+-------------------------------+-------+
| 3         | Aniseed Syrup                 | 10.00 |
| 1         | Chais                         | 18.00 |
| 2         | Chang                         | 19.00 |
| 5         | Chef Anton's Gumbo Mix        | 21.35 |
| 4         | Chef Anton's Cajun Seasoning  | 22.00 |
+-----------+-------------------------------+-------+

----------------------------------------------------------------------
Descending Order
----------------------------------------------------------------------

SELECT *
FROM Product
ORDER BY Price DESC;

Output

22.00
21.35
19.00
18.00
10.00

----------------------------------------------------------------------
Alphabetical Sorting
----------------------------------------------------------------------

SELECT *
FROM Product
ORDER BY ProductName;

Output

Aniseed Syrup
Chais
Chang
Chef Anton's Cajun Seasoning
Chef Anton's Gumbo Mix

----------------------------------------------------------------------
Multiple Columns
----------------------------------------------------------------------

SELECT *
FROM Product
ORDER BY CategoryID ASC,
         Price DESC;

Sorting Order:
1. CategoryID (Ascending)
2. If CategoryID is same → Price (Descending)

Example Data

+-----------+------------+-------+
| ProductID | CategoryID | Price |
+-----------+------------+-------+
| 4         | 2          | 22.00 |
| 5         | 2          | 21.35 |
| 3         | 2          | 10.00 |
| 2         | 1          | 19.00 |
| 1         | 1          | 18.00 |
+-----------+------------+-------+

Output

+-----------+------------+-------+
| ProductID | CategoryID | Price |
+-----------+------------+-------+
| 2         | 1          | 19.00 |
| 1         | 1          | 18.00 |
| 4         | 2          | 22.00 |
| 5         | 2          | 21.35 |
| 3         | 2          | 10.00 |
+-----------+------------+-------+

Remember:
ORDER BY col1, col2

→ Sort by col1 first.
→ If values are equal, sort by col2.
→ Continue similarly for additional columns.

/**********************************************************************/

Interview tip: A common follow-up question is:

Does ORDER BY always guarantee the same order for rows with identical sort values?

Answer: No. If multiple rows have identical values in all ORDER BY columns, 
their relative order is not guaranteed. To make the ordering deterministic, 
include another unique column (such as the primary key) in the ORDER BY clause.