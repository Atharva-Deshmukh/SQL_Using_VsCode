/*
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


NOTE: WITHOUT ORDER BY
 For each row, calculate the total amount of the entire partition.
 Hence full total is added to the end of the row

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

NOTE: With ORDER BY
Within each partition, arrange the rows by ORDER BY, and calculate the SUM up to the current row.
Thats why we get running total

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
