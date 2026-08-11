/* SQL WINDOW FUNCTIONS

===========================================================

1. WHAT ARE WINDOW FUNCTIONS?

Window functions perform calculations across a set of related
rows WITHOUT collapsing those rows.

→ Return a value for EVERY row.
→ GROUP BY collapses rows; Window Functions do not.

Basic syntax:
    FUNCTION() OVER (
        PARTITION BY column
        ORDER BY column
        [FRAME]
    )

Think:
    PARTITION BY → "Which group?"
    ORDER BY     → "In what order?"
    FRAME        → "Which rows around the current row?"

Example:
    SELECT region, amount,
        AVG(amount) OVER(PARTITION BY region) AS avg_region
    FROM Sales;

Every row remains, but each row gets its region's average.

===========================================================
2. WINDOW FUNCTION vs GROUP BY
==============================

GROUP BY:

    SELECT region, SUM(amount)
    FROM Sales
    GROUP BY region;

    → One row per region.

WINDOW:

    SELECT id, region, amount,
        SUM(amount) OVER(PARTITION BY region)
    FROM Sales;

    → Every original row remains + region total is shown beside it.


    GROUP BY      → COLLAPSES ROWS
    WINDOW        → PRESERVES ROWS

===========================================================
3. MAIN TYPES OF WINDOW FUNCTIONS
===========================================================

A) Aggregate Functions USED AS Window Functions
   SUM() OVER(...)  --> OVER() turns an applicable aggregate function into a window calculation.
   AVG() OVER(...)
   COUNT() OVER(...)
   MIN() OVER(...)
   MAX() OVER(...)


B) Ranking Window Functions
   ROW_NUMBER()
   RANK()
   DENSE_RANK()
   NTILE()


C) Value / Navigation Window Functions
   LAG()
   LEAD()
   FIRST_VALUE()
   LAST_VALUE()
   NTH_VALUE()

===========================================================
4. AGGREGATE WINDOW FUNCTIONS
=============================

Aggregate + OVER() = Window Aggregate.

    SUM()
    AVG()
    COUNT()
    MIN()
    MAX()

===========================================================
4.1: PARTITION BY
===========================================================

- PARTITION BY divides rows into groups.
- The window function is then calculated independently for each group.
- PARTITION BY does NOT remove rows.

Ex: Sales

    +----+--------+--------+
    | id | region | amount |
    +----+--------+--------+
    | 1  | East   | 100    |
    | 2  | East   | 200    |
    | 3  | East   | 50     |
    | 4  | West   | 150    |
    | 5  | West   | 300    |
    +----+--------+--------+


Query:

    SELECT id,region,amount,
        SUM(amount) OVER(PARTITION BY region) AS region_total
    FROM Sales;


Output:

    +----+--------+--------+-------------+
    | id | region | amount | region_total|
    +----+--------+--------+-------------+
    | 1  | East   | 100    | 350         |
    | 2  | East   | 200    | 350         |  NOTE: PARTITION BY does NOT collapse the rows into groups like GROUP BY
    | 3  | East   | 50     | 350         |
    | 4  | West   | 150    | 450         |
    | 5  | West   | 300    | 450         |
    +----+--------+--------+-------------+


===========================================================
4.2: SUM() OVER(PARTITION BY ...)
===========================================================

- Use when you want the total for each group while retaining every individual row.

Input:

    +----+--------+--------+
    | id | region | amount |
    +----+--------+--------+
    | 1  | East   | 100    |
    | 2  | East   | 200    |
    | 3  | East   | 50     |
    | 4  | West   | 150    |
    | 5  | West   | 300    |
    +----+--------+--------+

Query:

    SELECT id, region, amount,
        SUM(amount) OVER(PARTITION BY region) AS region_total
    FROM table;


Output:

    +----+--------+--------+-------------+
    | id | region | amount | region_total|
    +----+--------+--------+-------------+
    | 1  | East   | 100    | 350         |
    | 2  | East   | 200    | 350         |
    | 3  | East   | 50     | 350         |
    | 4  | West   | 150    | 450         |
    | 5  | West   | 300    | 450         |
    +----+--------+--------+-------------+


===========================================================
4.3: SUM() + ORDER BY = RUNNING TOTAL
===========================================================

Input:

    +----+--------+--------+
    | id | region | amount |
    +----+--------+--------+
    | 1  | East   | 100    |
    | 2  | East   | 200    |
    | 3  | West   | 150    |
    | 4  | East   | 50     |
    | 5  | West   | 300    |
    +----+--------+--------+

Query:

    SELECT id, region, amount, 
        SUM(amount) OVER(
                          PARTITION BY region 
                          ORDER BY id
                        ) AS running_total
    FROM table;

--> East — IDs 1, 2, 4

    id  amount  running_total
    1   100     100
    2   200     300
    4   50      350

--> West — IDs 3, 5:

    id  amount  running_total
    3   150     150
    5   300     450


Output:

+----+--------+--------+---------------+
| id | region | amount | running_total |
+----+--------+--------+---------------+
| 1  | East   | 100    | 100           |
| 2  | East   | 200    | 300           |
| 3  | West   | 150    | 150           |
| 4  | East   | 50     | 350           |
| 5  | West   | 300    | 450           |
+----+--------+--------+---------------+


===========================================================
4. AVG() OVER(PARTITION BY ...)
===========================================================

Input:

+----+--------+--------+
| id | region | amount |
+----+--------+--------+
| 1  | East   | 100    |
| 2  | East   | 200    |
| 3  | East   | 50     |
| 4  | West   | 150    |
| 5  | West   | 300    |
+----+--------+--------+

Query:

    SELECT id, region, amount, 
        AVG(amount) OVER(PARTITION BY region) AS region_avg
    FROM table;


Output:

+----+--------+--------+----------+
| id | region | amount | region_avg|
+----+--------+--------+----------+
| 1  | East   | 100    | 116.67   |
| 2  | East   | 200    | 116.67   |     Every row in the same partition receives the same average.
| 3  | East   | 50     | 116.67   |
| 4  | West   | 150    | 225      |
| 5  | West   | 300    | 225      |
+----+--------+--------+----------+

===========================================================
5. COUNT(*) OVER(PARTITION BY ...)
===========================================================

Input:

    +----+--------+--------+
    | id | region | amount |
    +----+--------+--------+
    | 1  | East   | 100    |
    | 2  | East   | 200    |
    | 3  | East   | 50     |
    | 4  | West   | 150    |
    | 5  | West   | 300    |
    +----+--------+--------+

Query:

    SELECT id, region, amount, 
        COUNT(*) OVER(PARTITION BY region) AS region_count
    FROM table;


Output:

    +----+--------+--------+-------------+
    | id | region | amount | region_count|
    +----+--------+--------+-------------+
    | 1  | East   | 100    | 3           | 
    | 2  | East   | 200    | 3           | 
    | 3  | East   | 50     | 3           |
    | 4  | West   | 150    | 2           |
    | 5  | West   | 300    | 2           |
    +----+--------+--------+-------------+

NOTE:
    COUNT(*) → counts rows
    COUNT(column) → counts NON-NULL values in that column


Example:

+----+--------+--------+
| id | region | amount |
+----+--------+--------+
| 1  | East   | 100    |
| 2  | East   | NULL   |
| 3  | East   | 50     |
+----+--------+--------+

COUNT(*) OVER(PARTITION BY region)      → 3
COUNT(amount) OVER(PARTITION BY region) → 2

Because NULL is not counted by COUNT(amount).


===========================================================
6. MIN() OVER(PARTITION BY ...)
===========================================================

Query:

    SELECT id, region, amount, 
        MIN(amount) OVER(PARTITION BY region) as region_min
    FROM table;

Output:

    +----+--------+--------+-----------+
    | id | region | amount | region_min|
    +----+--------+--------+-----------+
    | 1  | East   | 100    | 50        |
    | 2  | East   | 200    | 50        |
    | 3  | East   | 50     | 50        |
    | 4  | West   | 150    | 150       |
    | 5  | West   | 300    | 150       |
    +----+--------+--------+-----------+

===========================================================
7. MAX() OVER(PARTITION BY ...)
===========================================================

Query:

    SELECT id, region, amount, 
        MAX(amount) OVER(PARTITION BY region) as region_max
    FROM table;


Output:

    +----+--------+--------+-----------+
    | id | region | amount | region_max|
    +----+--------+--------+-----------+
    | 1  | East   | 100    | 200       |
    | 2  | East   | 200    | 200       |
    | 3  | East   | 50     | 200       |
    | 4  | West   | 150    | 300       |
    | 5  | West   | 300    | 300       |
    +----+--------+--------+-----------+

Useful question --> "What is the maximum sale in this salesperson's region?"

===========================================================
5. RANKING WINDOW FUNCTIONS
===========================================================

Ranking window functions assign a number/rank to each row within an ordered result.

Main ranking functions:
    ROW_NUMBER() → unique number
    RANK()       → ties + gaps
    DENSE_RANK() → ties + no gaps
    NTILE(N)     → divide rows into N buckets


===========================================================
1. ROW_NUMBER()
===========================================================

ROW_NUMBER() gives every row a UNIQUE sequential number.

Syntax:

ROW_NUMBER() OVER(
    PARTITION BY region
    ORDER BY amount DESC
)


Example table: Sales

+----+--------+--------+
| id | region | amount |
+----+--------+--------+
| 1  | East   | 200    |
| 2  | East   | 100    |
| 3  | East   | 50     |
| 4  | West   | 300    |
| 5  | West   | 150    |
+----+--------+--------+


Query:

SELECT
    id,
    region,
    amount,
    ROW_NUMBER() OVER(
        PARTITION BY region
        ORDER BY amount DESC
    ) AS row_num
FROM Sales;


Output:

+----+--------+--------+---------+
| id | region | amount | row_num |
+----+--------+--------+---------+
| 1  | East   | 200    | 1       |
| 2  | East   | 100    | 2       |
| 3  | East   | 50     | 3       |
| 4  | West   | 300    | 1       |
| 5  | West   | 150    | 2       |
+----+--------+--------+---------+


Notice:

East is numbered independently:

200 → 1
100 → 2
50  → 3


West is numbered independently:

300 → 1
150 → 2


PARTITION BY region
→ creates separate ranking sequences.


USE WHEN:

→ You need a unique sequential number
→ Top 1 / Top N per group
→ Deduplication
→ Selecting one row from each group


===========================================================
2. ROW_NUMBER() WITH TIES
===========================================================

Important:

ROW_NUMBER() always gives different numbers
to different rows.

Example:

Input:

+----+--------+--------+
| id | region | amount |
+----+--------+--------+
| 1  | East   | 200    |
| 2  | East   | 200    |
| 3  | East   | 150    |
| 4  | East   | 100    |
+----+--------+--------+


Query:

ROW_NUMBER() OVER(
    PARTITION BY region
    ORDER BY amount DESC
)


Possible output:

+----+--------+--------+---------+
| id | region | amount | row_num |
+----+--------+--------+---------+
| 1  | East   | 200    | 1       |
| 2  | East   | 200    | 2       |
| 3  | East   | 150    | 3       |
| 4  | East   | 100    | 4       |
+----+--------+--------+---------+


The two 200s DO NOT receive the same row number.


IMPORTANT:

If ORDER BY contains ties, SQL may choose an arbitrary
order between tied rows unless you provide another
tie-breaking column.

For deterministic numbering:

ROW_NUMBER() OVER(
    PARTITION BY region
    ORDER BY amount DESC, id
)


===========================================================
3. RANK()
===========================================================

RANK() gives the SAME rank to tied values.

After a tie, ranks are SKIPPED.

Example:

Input:

+----+--------+
| id | amount |
+----+--------+
| 1  | 200    |
| 2  | 200    |
| 3  | 150    |
| 4  | 100    |
+----+--------+


Query:

SELECT
    id,
    amount,
    RANK() OVER(
        ORDER BY amount DESC
    ) AS rnk
FROM Sales;


Output:

+----+--------+-----+
| id | amount | rnk |
+----+--------+-----+
| 1  | 200    | 1   |
| 2  | 200    | 1   |
| 3  | 150    | 3   |
| 4  | 100    | 4   |
+----+--------+-----+


Why?

Two rows occupy rank 1.

Therefore:

200 → rank 1
200 → rank 1
150 → rank 3
100 → rank 4


Rank 2 is skipped.


MEMORY:

RANK() → ties + gaps


===========================================================
4. DENSE_RANK()
===========================================================

DENSE_RANK() also gives the SAME rank to tied values.

BUT:

It does NOT skip numbers after a tie.


Same input:

+----+--------+
| id | amount |
+----+--------+
| 1  | 200    |
| 2  | 200    |
| 3  | 150    |
| 4  | 100    |
+----+--------+


Query:

SELECT
    id,
    amount,
    DENSE_RANK() OVER(
        ORDER BY amount DESC
    ) AS dense_rnk
FROM Sales;


Output:

+----+--------+-----------+
| id | amount | dense_rnk |
+----+--------+-----------+
| 1  | 200    | 1         |
| 2  | 200    | 1         |
| 3  | 150    | 2         |
| 4  | 100    | 3         |
+----+--------+-----------+


Why?

200 → rank 1
200 → rank 1
150 → rank 2
100 → rank 3


No rank is skipped.


MEMORY:

DENSE_RANK() → ties + NO gaps


===========================================================
5. RANK() vs DENSE_RANK()
===========================================================

Input:

Amount:

200
200
150
100


RANK():

+--------+------+
| amount | rank |
+--------+------+
| 200    | 1    |
| 200    | 1    |
| 150    | 3    |
| 100    | 4    |
+--------+------+


DENSE_RANK():

+--------+------------+
| amount | dense_rank |
+--------+------------+
| 200    | 1          |
| 200    | 1          |
| 150    | 2          |
| 100    | 3          |
+--------+------------+


MEMORY TRICK:

RANK
→ ties + gaps

DENSE_RANK
→ ties + no gaps


===========================================================
6. ROW_NUMBER vs RANK vs DENSE_RANK
===========================================================

Input:

Amount:

200
200
150
100


ROW_NUMBER():

1
2
3
4

Every row gets a unique number.


RANK():

1
1
3
4

Ties share rank.
Gaps occur.


DENSE_RANK():

1
1
2
3

Ties share rank.
No gaps.


QUICK COMPARISON:

                 Ties?      Gaps?

ROW_NUMBER       NO         N/A
RANK             YES        YES
DENSE_RANK       YES        NO


===========================================================
7. TOP N PER GROUP
===========================================================

This is one of the MOST IMPORTANT uses of
ranking window functions.

Question:

"Find the top 2 salaries in each department."

Input:

+----+------+--------+
| id | dept | salary |
+----+------+--------+
| 1  | A    | 10000  |
| 2  | A    | 9000   |
| 3  | A    | 8000   |
| 4  | B    | 12000  |
| 5  | B    | 11000  |
| 6  | B    | 7000   |
+----+------+--------+


Query:

SELECT *
FROM (
    SELECT
        id,
        dept,
        salary,
        ROW_NUMBER() OVER(
            PARTITION BY dept
            ORDER BY salary DESC
        ) AS rn
    FROM Employees
) x
WHERE rn <= 2;


Output:

+----+------+--------+----+
| id | dept | salary | rn |
+----+------+--------+----+
| 1  | A    | 10000  | 1  |
| 2  | A    | 9000   | 2  |
| 4  | B    | 12000  | 1  |
| 5  | B    | 11000  | 2  |
+----+------+--------+----+


Mental model:

PARTITION BY dept
→ restart ranking for every department

ORDER BY salary DESC
→ highest salary first

ROW_NUMBER()
→ assign positions

WHERE rn <= 2
→ keep top 2


===========================================================
8. WHEN TO USE RANK vs DENSE_RANK FOR TOP N
===========================================================

Suppose salaries are:

10000
10000
9000
8000


If you want:

"Exactly 2 rows"

Use:

ROW_NUMBER()


Result:

10000 → 1
10000 → 2


If you want:

"Top 2 salary positions,
including all employees tied at those positions"

Use:

DENSE_RANK()


Result:

10000 → 1
10000 → 1
9000  → 2


Therefore:

ROW_NUMBER()
→ top N ROWS


RANK()
→ top N RANKS, with gaps


DENSE_RANK()
→ top N DISTINCT VALUES / RANKS, no gaps


This distinction is extremely important in
SQL interview questions.


===========================================================
9. NTILE(N)
===========================================================

NTILE(N) divides ordered rows into N approximately
equal buckets.

Syntax:

NTILE(2) OVER(
    ORDER BY amount DESC
)


Example:

Input:

+----+--------+
| id | amount |
+----+--------+
| 1  | 300    |
| 2  | 200    |
| 3  | 150    |
| 4  | 100    |
| 5  | 50     |
+----+--------+


Query:

SELECT
    id,
    amount,
    NTILE(2) OVER(
        ORDER BY amount DESC
    ) AS bucket
FROM Sales;


Output:

+----+--------+--------+
| id | amount | bucket |
+----+--------+--------+
| 1  | 300    | 1      |
| 2  | 200    | 1      |
| 3  | 150    | 1      |
| 4  | 100    | 2      |
| 5  | 50     | 2      |
+----+--------+--------+


5 rows
÷
2 buckets

→ Bucket 1 gets 3 rows
→ Bucket 2 gets 2 rows


IMPORTANT:

If rows cannot be divided equally,
earlier buckets receive the extra rows.


===========================================================
10. NTILE(4) — QUARTILES
===========================================================

NTILE(4) creates 4 approximately equal groups.

Common interpretation:

Bucket 1 → Top 25%
Bucket 2 → Next 25%
Bucket 3 → Next 25%
Bucket 4 → Bottom 25%


Example:

NTILE(4) OVER(
    ORDER BY salary DESC
)


USE CASES:

→ Quartiles
→ Customer segmentation
→ Salary bands
→ Top/middle/bottom groups
→ Performance segmentation


===========================================================
11. PARTITION BY WITH RANKING
===========================================================

Without PARTITION BY:

RANK() OVER(
    ORDER BY salary DESC
)

→ rank everyone together.


With PARTITION BY:

RANK() OVER(
    PARTITION BY department
    ORDER BY salary DESC
)

→ rank employees separately inside each department.


Example:

Input:

+----+------+--------+
| id | dept | salary |
+----+------+--------+
| 1  | A    | 10000  |
| 2  | A    | 8000   |
| 3  | B    | 12000  |
| 4  | B    | 9000   |
+----+------+--------+


Output:

+----+------+--------+-----+
| id | dept | salary | rnk |
+----+------+--------+-----+
| 1  | A    | 10000  | 1   |
| 2  | A    | 8000   | 2   |
| 3  | B    | 12000  | 1   |
| 4  | B    | 9000   | 2   |
+----+------+--------+-----+


Notice:

Department A:
10000 → 1
8000  → 2

Department B:
12000 → 1
9000  → 2


The ranking RESTARTS for every partition.


===========================================================
12. RANKING FUNCTIONS — QUICK REVISION
===========================================================

ROW_NUMBER()

→ Every row gets a unique number.

1
2
3
4


RANK()

→ Same values get same rank.
→ Gaps after ties.

1
1
3
4


DENSE_RANK()

→ Same values get same rank.
→ No gaps.

1
1
2
3


NTILE(N)

→ Divides ordered rows into N buckets.

1
1
1
2
2


===========================================================
13. ONE-LINE MEMORY TRICK
===========================================================

ROW_NUMBER
→ "Give every row a unique position."


RANK
→ "Same value = same rank,
   but leave gaps."


DENSE_RANK
→ "Same value = same rank,
   don't leave gaps."


NTILE
→ "Divide the rows into buckets."


===========================================================
14. INTERVIEW PATTERN RECOGNITION
===========================================================

Question:

"Find the highest-paid employee in each department."

Think:

ROW_NUMBER()
+
PARTITION BY department
+
ORDER BY salary DESC


Question:

"Find the top 3 salaries in each department,
including ties."

Think:

DENSE_RANK()
+
PARTITION BY department
+
ORDER BY salary DESC


Question:

"Assign a unique sequence to employees
within each department."

Think:

ROW_NUMBER()
+
PARTITION BY department


Question:

"Divide customers into four equal groups."

Think:

NTILE(4)


Question:

"Rank all employees by salary."

Think:

RANK()
+
ORDER BY salary DESC


===========================================================
FINAL RANKING RULE
===========================================================

                    RANKING FUNCTIONS

                           |
          +----------------+----------------+
          |                |                |
     ROW_NUMBER          RANK         DENSE_RANK
          |                |                |
      Unique           Ties + gaps    Ties + no gaps


                           +
                         NTILE
                           |
                    N approximately
                    equal buckets


The most important distinction:

ROW_NUMBER
→ unique row position

RANK
→ ranking with gaps

DENSE_RANK
→ ranking without gaps

NTILE
→ grouping rows into buckets


For LeetCode SQL:

TOP N ROWS
→ ROW_NUMBER()

TOP N RANKS / POSITIONS WITH TIES
→ RANK() or DENSE_RANK()

TOP N DISTINCT VALUES
→ DENSE_RANK()

BUCKET / QUARTILE / PERCENTILE-STYLE GROUPING
→ NTILE(N)

===========================================================
6. VALUE / NAVIGATION FUNCTIONS
===============================

Used to access values from other rows.

```
LAG()         → previous row
LEAD()        → next row
FIRST_VALUE() → first value
LAST_VALUE()  → last value
NTH_VALUE()   → Nth value
```

---

## LAG()

Gets a value from a PREVIOUS row.

```
LAG(amount, 1, 0) OVER(ORDER BY id)
```

Meaning:

```
LAG(expression, offset, default)
```

Example:

```
amount:       100   200   150   300   50
previous:       0   100   200   150   300
```

Useful for:
→ Month-over-month comparison
→ Previous transaction
→ Difference from previous row

---

## LEAD()

Gets a value from a FOLLOWING row.

```
LEAD(amount, 1, 0) OVER(ORDER BY id)
```

Example:

```
amount:       100   200   150   300   50
next:         200   150   300    50    0
```

Useful for:
→ Next transaction
→ Future value
→ Comparing current vs next row

MEMORY:

```
LAG  → behind
LEAD → ahead
```

---

## FIRST_VALUE()

Returns the first value according to the window ordering.

```
FIRST_VALUE(amount) OVER(
    PARTITION BY region
    ORDER BY amount DESC
)
```

With DESC:

```
first value = highest amount.
```

Example:

```
East: 200, 100, 50
first_value = 200 for every East row.
```

---

## LAST_VALUE()

Returns the last value in the window.

IMPORTANT:
LAST_VALUE() often needs an explicit FULL frame to reliably
return the actual last value of the partition.

```
LAST_VALUE(amount) OVER(
    PARTITION BY region
    ORDER BY amount DESC
    ROWS BETWEEN UNBOUNDED PRECEDING
         AND UNBOUNDED FOLLOWING
)
```

With DESC:

```
East: 200, 100, 50
last_value = 50
```

---

## NTH_VALUE()

Returns the Nth value in the window.

```
NTH_VALUE(amount, 2) OVER(
    PARTITION BY region
    ORDER BY amount DESC
    ROWS BETWEEN UNBOUNDED PRECEDING
         AND UNBOUNDED FOLLOWING
)
```

East:

```
200, 100, 50
```

2nd value = 100.

===========================================================
7. PARTITION BY vs ORDER BY
===========================

PARTITION BY:
Splits rows into independent groups.

ORDER BY:
Determines the order in which rows are processed.

Example:

```
SUM(amount) OVER(
    PARTITION BY region
    ORDER BY id
)
```

Meaning:

```
1. Separate by region.
2. Sort each region by id.
3. Calculate the running sum.
```

IMPORTANT:
ORDER BY inside OVER() is NOT necessarily the same as the
final output order.

If you want final result ordering:

```
ORDER BY ...
```

===========================================================
8. WINDOW FRAMES
================

A frame specifies WHICH rows around the current row are
included in the calculation.

Common frame:

```
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
```

Meaning:

```
Start of partition → current row
```

This produces a running calculation.

---

## FRAME UNITS

ROWS
→ Based on physical row positions.

RANGE
→ Based on ORDER BY values.

---

## ROWS example

```
SUM(amount) OVER(
    ORDER BY id
    ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
)
```

Means:

```
Current row + exactly 1 physical row before it.
```

Amounts:

```
100, 200, 150, 300, 50
```

Result:

```
100
300       = 100 + 200
350       = 200 + 150
450       = 150 + 300
350       = 300 + 50
```

---

## RANGE example

```
SUM(amount) OVER(
    ORDER BY amount
    RANGE BETWEEN 100 PRECEDING AND CURRENT ROW
)
```

For amount = 150:

```
Include values from 50 to 150.

50 + 100 + 150 = 300
```

For amount = 200:

```
Include values from 100 to 200.

100 + 150 + 200 = 450
```

---

## ROWS vs RANGE

ROWS:
"How many rows?"

RANGE:
"Which ORDER BY values fall in this range?"

Example:

```
ROWS  BETWEEN 1 PRECEDING AND CURRENT ROW
→ current row + previous physical row

RANGE BETWEEN 100 PRECEDING AND CURRENT ROW
→ all rows whose ORDER BY value is within 100
```

===========================================================
9. FRAME BOUNDARIES
===================

UNBOUNDED PRECEDING
→ Start of partition.

N PRECEDING
→ N rows/values before current row
(depending on ROWS/RANGE).

CURRENT ROW
→ Current row/value.

N FOLLOWING
→ N rows/values after current row.

UNBOUNDED FOLLOWING
→ End of partition.

Very important full-partition frame:

```
ROWS BETWEEN UNBOUNDED PRECEDING
     AND UNBOUNDED FOLLOWING
```

===========================================================
10. MOST IMPORTANT PATTERNS TO REMEMBER
=======================================

① Total per group:

```
SUM(x) OVER(PARTITION BY group_col)
```

② Average per group:

```
AVG(x) OVER(PARTITION BY group_col)
```

③ Running total:

```
SUM(x) OVER(
    PARTITION BY group_col
    ORDER BY date
)
```

④ Rank within each group:

```
RANK() OVER(
    PARTITION BY group_col
    ORDER BY x DESC
)
```

⑤ Unique row number within each group:

```
ROW_NUMBER() OVER(
    PARTITION BY group_col
    ORDER BY x DESC
)
```

⑥ Previous value:

```
LAG(x) OVER(ORDER BY date)
```

⑦ Next value:

```
LEAD(x) OVER(ORDER BY date)
```

⑧ Highest value in each group:

```
FIRST_VALUE(x) OVER(
    PARTITION BY group_col
    ORDER BY x DESC
)
```

⑨ Lowest/last value in each group:

```
LAST_VALUE(x) OVER(
    PARTITION BY group_col
    ORDER BY x DESC
    ROWS BETWEEN UNBOUNDED PRECEDING
         AND UNBOUNDED FOLLOWING
)
```

⑩ Divide into groups:

```
NTILE(4) OVER(ORDER BY x DESC)
```

===========================================================
11. EXAM / INTERVIEW MEMORY TABLE
=================================

## Function       Main Purpose

SUM            Total / running total
AVG            Average
COUNT          Number of rows / non-NULL values
MIN            Minimum
MAX            Maximum

ROW_NUMBER     Unique numbering
RANK           Ranking with gaps
DENSE_RANK     Ranking without gaps
NTILE          Divide into buckets

LAG            Previous row
LEAD           Next row
FIRST_VALUE    First value
LAST_VALUE     Last value
NTH_VALUE      Nth value

===========================================================
12. QUICK DIFFERENCE CHEAT SHEET
================================

## GROUP BY vs WINDOW

GROUP BY → collapses rows
WINDOW   → preserves rows

## PARTITION BY vs GROUP BY

PARTITION BY → creates calculation groups but keeps rows
GROUP BY     → creates groups and collapses rows

## ROW_NUMBER vs RANK

ROW_NUMBER → ties get different numbers
RANK       → ties get same rank + gaps

## RANK vs DENSE_RANK

RANK       → 1, 1, 3, 4
DENSE_RANK → 1, 1, 2, 3

## LAG vs LEAD

LAG  → previous
LEAD → next

## ROWS vs RANGE

ROWS  → physical row positions
RANGE → ORDER BY value range

## FIRST_VALUE vs LAST_VALUE

FIRST_VALUE → first according to ordering
LAST_VALUE  → last according to frame

===========================================================
13. ONE-LINE REVISION
=====================

WINDOW FUNCTIONS = "Calculate across related rows WITHOUT
losing the individual rows."

PARTITION BY = GROUP
ORDER BY     = ORDER
FRAME        = ROWS INCLUDED

SUM/AVG/COUNT/MIN/MAX → calculate
ROW_NUMBER/RANK/...   → rank
LAG/LEAD              → navigate
FIRST/LAST/NTH        → access values

===========================================================
*/

This version should be **much faster to revise**: learn sections 1, 3, 7, 10 and 12 first, then use the examples to reinforce them.
