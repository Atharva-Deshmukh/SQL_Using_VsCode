/*
                                    What are Window Functions?
                                    -------------------------

- Basically, Window functions operate over a window of rows

- Difference from normal GROUP BY aggregate functions:
  GROUP BY collapses rows into a single row.
  Window functions keep all rows, but add extra calculated values alongside them.

                                    Real-Life Use Cases
                                    -------------------

- Ranking students/employees by marks, salary, etc.
- Running totals / moving averages in finance or sales.
- Comparing with previous/next row (e.g., stock price change compared to yesterday).

                            Can we use Aggregate Functions as Window Functions?
                            ---------------------------------------------------

✅ Yes. Any aggregate function can be used as a window function by adding OVER(...).

                                TYPES OF WINDOW FUNCTIONS
                                -------------------------

(A) Aggregate Window Functions

These are the same aggregate functions you already know, but applied over a window.
    SUM()
    AVG()
    COUNT()
    MIN()
    MAX()
👉 Instead of collapsing rows into one, they return a value for each row.


                                                CLAUSES USED:
                                                -------------

Using PARTITION BY
- Used to divide the result set into partitions. 
- The window function is then applied independently to each partition. 
- Ex: department-wise cumulative salaries.

---------------------------------------------------------------------------------------------------------

                                            TABLE USED:
                                            -----------

                                +----+-----------+--------+--------+
                                | id | salesperson | region | amount |
                                +----+-----------+--------+--------+
                                |  1 | Alice     | East   |    100 |
                                |  2 | Bob       | East   |    200 |
                                |  3 | Alice     | West   |    150 |
                                |  4 | Bob       | West   |    300 |
                                |  5 | Charlie   | East   |     50 |
                                +----+-----------+--------+--------+ */
                                
-- SUM() As Aggregate Function -> Returns one row per region.

SELECT region, SUM(amount) AS total_sales
FROM WF_SALES
GROUP BY region;

/* OUTPUT:

# region	total_sales
    East	350
    West	450 */

-- Sum() As Window Function
SELECT id, region, amount,
       SUM(amount) OVER (PARTITION BY region ORDER BY id) AS running_total
FROM WF_SALES;

/* OUTPUT:

# id	region	amount	running_total
    1	East	100	    100
    2	East	200	    300
    5	East	50	    350
    3	West	150	    150
    4	West	300	    450  */

---------------------------------------------------------------------------------------------------------

-- AVG()  As Aggregate Function

SELECT salesperson, AVG(amount) AS avg_sales
FROM WF_SALES
GROUP BY salesperson;

/* OUTPUT:

# salesperson	avg_sales
Alice	        125.0000
Bob	            250.0000
Charlie	        50.0000


*/

-- AVG()  As Window Function

SELECT id, region, amount,
       AVG(amount) OVER (PARTITION BY region) AS avg_in_region
FROM WF_SALES;

/* OUTPUT:

# id	region	amount	avg_in_region
    1	East	100	    116.6667
    2	East	200	    116.6667
    5	East	50	    116.6667
    3	West	150	    225.0000
    4	West	300	    225.0000  */

---------------------------------------------------------------------------------------------------------

-- COUNT() As Aggregate Function

SELECT region, COUNT(*) AS sales_count
FROM WF_SALES
GROUP BY region;

/* OUTPUT:
# region	sales_count
East	        3
West	        2           */

-- COUNT() As Window Function

SELECT id, region, amount,
       COUNT(*) OVER (PARTITION BY region) AS count_in_region
FROM WF_SALES;

/* OUTPUT:

# id	region	amount	count_in_region
    1	East	100	            1   
    2	East	200	            2
    5	East	50	            3
    3	West	150	            1
    4	West	300	            2       */

---------------------------------------------------------------------------------------------------------

-- MIN() As Aggregate Function

SELECT region, MIN(amount) AS min_sale
FROM WF_SALES
GROUP BY region;

/* OUTPUT:

# region	min_sale
    East	50
    West	150] */

-- MIN() AS Window Function

SELECT id, region, amount,
       MIN(amount) OVER (PARTITION BY region) AS min_in_region
FROM WF_SALES;

/* OUTPUT:

# id	region	amount	min_in_region
    1	East	    100	      50
    2	East	    200	      50
    5	East	    50	      50
    3	West	    150	      150
    4	West	    300	      150  */

---------------------------------------------------------------------------------------------------------

-- MAX() As Aggregate Function

SELECT region, MAX(amount) AS max_sale
FROM WF_SALES
GROUP BY region;

/* OUTPUT:

# region	max_sale
    East	200
    West	300    */

-- MAX() AS window Function

SELECT id, region, amount,
       MAX(amount) OVER (PARTITION BY region) AS max_in_region
FROM WF_SALES;

/* OUTPUT:

# id	region	amount	max_in_region
    1	East	100	        200
    2	East	200	        200
    5	East	50	        200
    3	West	150	        300
    4	West	300	        300      */


---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
(B) Ranking Functions

Used for ranking and numbering rows.

    ROW_NUMBER() → unique sequence per row
    RANK() → gives same rank for ties, leaves gaps
    DENSE_RANK() → gives same rank for ties, no gaps
    NTILE(N) → divides rows into N buckets

*/

-- ROW_NUMBER()

-- Assigns a unique sequential number per partition/order.
SELECT id, salesperson, region, amount,
       ROW_NUMBER() OVER (PARTITION BY region ORDER BY amount DESC) AS row_num
FROM WF_SALES;

/* OUTPUT:

# id	salesperson	region	amount	row_num
    2	Bob	           East	200	        1   
    1	Alice	       East	100	        2
    5	Charlie	       East	50	        3
    4	Bob	           West	300	        1
    3	Alice	       West	150	        2  */

---------------------------------------------------------------------------------------------------------

-- RANK()

-- Ties get same rank, gaps left in ranking.
-- If two people have same amount, they share the rank, but the next rank is skipped.
SELECT id, salesperson, region, amount,
       RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS rank_in_region
FROM WF_SALES;

/* OUTPUT:

# id	salesperson	region	amount	rank_in_region
    2	Bob	        East	200	        1
    1	Alice	    East	100	        2
    5	Charlie	    East	50	        3
    4	Bob	        West	300	        1
    3	Alice	    West	150	        2    */


---------------------------------------------------------------------------------------------------------

-- DENSE_RANK()

SELECT id, salesperson, region, amount,
       DENSE_RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS dense_rank_in_region
FROM Sales;


/* OUTPUT DIFFERENCE

id  salesperson  region  amount  rank_in_region  dense_rank_in_region
2   Bob          East    200     1               1
3   Carol        East    200     1               1
4   David        East    150     3               2
1   Alice        East    100     4               3
5   Eve          West    300     1               1
6   Frank        West    300     1               1
7   Grace        West    250     3               2
8   Heidi        West    200     4               3   


Difference visible:

In East region: Bob & Carol tie at 200.
    RANK() → next is 3 (gap at 2).
    DENSE_RANK() → next is 2 (no gap).
*/



---------------------------------------------------------------------------------------------------------
-- NTILE(N) -> Divides rows into N buckets as evenly as possible.

-- Splits entire result set into 2 groups based on ordering.
SELECT id, salesperson, region, amount,
       NTILE(2) OVER (ORDER BY amount DESC) AS bucket
FROM WF_SALES;

/* OUTPUT:

# id	salesperson	region	amount	bucket
    4	Bob	        West	300	        1
    2	Bob	        East	200	        1
    3	Alice	    West	150	        1
    1	Alice	    East	100	        2
    5	Charlie	    East	50	        2   */


---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

/*

(C) Value Functions (a.k.a. Navigation functions)

Used to access values from current or other rows.

    LEAD(expr, offset, default) → value from next row(s)
    LAG(expr, offset, default) → value from previous row(s)
    FIRST_VALUE(expr) → first value in window
    LAST_VALUE(expr) → last value in window
    NTH_VALUE(expr, N) → Nth value in window    */


-- LEAD()

-- If there’s no next row, it returns the default (0 here).
SELECT id, salesperson, amount,
    LEAD(amount, 1, 0) OVER (ORDER BY id) AS next_amount
FROM WF_SALES;

/* OUTPUT:

#   id	salesperson	amount	next_amount
    1	Alice	    100	        200
    2	Bob	        200	        150
    3	Alice	    150	        300
    4	Bob	        300	        50
    5	Charlie	    50	        0    */  <-- default since no next row

---------------------------------------------------------------------------------------------------------
-- LAG()

-- If there’s no previous row, it returns the default (0 here).
SELECT  id, salesperson, amount,
    LAG(amount, 1, 0) OVER (ORDER BY id) AS prev_amount
FROM WF_SALES;

/* OUTPUT:

#   id	salesperson	amount	prev_amount
    1	Alice	    100	        0
    2	Bob	        200	        100
    3	Alice	    150	        200
    4	Bob	        300	        150
    5	Charlie	    50	        300  */


---------------------------------------------------------------------------------------------------------

-- FIRST_VALUE(expr) → First value in the window

SELECT id, salesperson, region, amount,
    FIRST_VALUE(amount) OVER (
        PARTITION BY region ORDER BY amount DESC
    ) AS first_val
FROM WF_SALES;

/* OUTPUT:

#   id	salesperson	region	amount	first_val
    2	Bob	        East	200	    200         <-- highest in East
    1	Alice	    East	100	    200
    5	Charlie	    East	50	    200
    4	Bob	        West	300	    300        <-- highest in West
    3	Alice	    West	150	    300 */

---------------------------------------------------------------------------------------------------------
-- LAST_VALUE() → Last Value in Partition
-- (Need full frame for correctness → ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)

SELECT id, salesperson, region, amount,
    LAST_VALUE(amount) OVER (
        PARTITION BY region 
        ORDER BY amount DESC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_val
FROM WF_SALES;

/* OUTPUT:

#   id	salesperson	region	amount	last_val
    2	Bob	        East	200	        50
    1	Alice	    East	100	        50
    5	Charlie	    East	50	        50
    4	Bob	        West	300	        150
    3	Alice	    West	150	        150  */

---------------------------------------------------------------------------------------------------------
-- NTH_VALUE() → Nth Value in Partition

SELECT id, salesperson, region, amount,
    NTH_VALUE(amount, 2) OVER (
        PARTITION BY region 
        ORDER BY amount DESC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS second_val
FROM WF_SALES;

/* OUTPUT:

#   id	salesperson	region	amount	second_val
    2	Bob	        East	200	        100
    1	Alice	    East	100	        100
    5	Charlie	    East	50	        100
    4	Bob	        West	300	        150
    3	Alice	    West	150	        150  */

---------------------------------------------------------------------------------------------------------

/*                                               FRAMES

Default Frame : RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
Think of it as: “For this row, which other rows around it should I look at when applying the function?”

Types of Frame Units

    ROWS frame → looks at a fixed number of rows relative to the current row (physical row positions).
    Example: ROWS BETWEEN 2 PRECEDING AND CURRENT ROW → current row + 2 rows before it.

    RANGE frame → looks at rows based on values in the ORDER BY column (value-based).
    Example: RANGE BETWEEN 100 PRECEDING AND CURRENT ROW → current row + all rows whose 
    ORDER BY value is within [value-100, value].

🔹 Frame Boundaries

We can specify how far the frame extends:

UNBOUNDED PRECEDING → from the start of partition up to current row.
N PRECEDING → N rows before current row (ROWS) or values within N units before (RANGE).
CURRENT ROW → just the current row.
N FOLLOWING → N rows/values after the current row.
UNBOUNDED FOLLOWING → from current row to end of partition.  */

/*                                   TABLE USED

                        +----+-------------+--------+--------+
                        | id | salesperson | region | amount |
                        +----+-------------+--------+--------+
                        |  1 | Alice       | East   |    100 |
                        |  2 | Bob         | East   |    200 |
                        |  3 | Alice       | West   |    150 |
                        |  4 | Bob         | West   |    300 |
                        |  5 | Charlie     | East   |     50 |
                        +----+-------------+--------+--------+
                        */

-- 🔹 ROWS Example (Frame by row position)
-- 👉 "How many physical rows around the current row should be included?"

SELECT
    id,
    salesperson,
    amount,
    SUM(amount) OVER (
        ORDER BY id
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
    ) AS running_sum
FROM Sales;

/* Explanation

ROWS BETWEEN 1 PRECEDING AND CURRENT ROW → look at the current row plus the 1 row before it
(based on ORDER BY id).

It does not care about values being equal, just the position of rows.

Output
+----+-------------+--------+-------------+
| id | salesperson | amount | running_sum |
+----+-------------+--------+-------------+
|  1 | Alice       |    100 |         100 |
|  2 | Bob         |    200 |         300 |  (100 + 200)
|  3 | Alice       |    150 |         350 |  (200 + 150)
|  4 | Bob         |    300 |         450 |  (150 + 300)
|  5 | Charlie     |     50 |         350 |  (300 + 50)
+----+-------------+--------+-------------+
*/

-- 🔹 RANGE Example (Frame by value range)
-- 👉 "How many rows have values within a certain numeric range around the current value?"

SELECT
    id,
    salesperson,
    amount,
    SUM(amount) OVER (
        ORDER BY amount
        RANGE BETWEEN 100 PRECEDING AND CURRENT ROW
    ) AS range_sum
FROM Sales;

/* Explanation

RANGE BETWEEN 100 PRECEDING AND CURRENT ROW → for each row, include all rows where amount is within 
[current_amount - 100 , current_amount].
Unlike ROWS, this may include multiple rows with the same amount if they fall in the numeric range.

Output
+----+-------------+--------+-----------+
| id | salesperson | amount | range_sum |
+----+-------------+--------+-----------+
|  5 | Charlie     |     50 |        50 | (only 50 itself)
|  1 | Alice       |    100 |       150 | (100 + 50 within 100 range)
|  3 | Alice       |    150 |       250 | (150 + 100 within 100 range)
|  2 | Bob         |    200 |       350 | (200 + 150 within 100 range)
|  4 | Bob         |    300 |       500 | (300 + 200 within 100 range)
+----+-------------+--------+-----------+

🔑 Key Difference

ROWS → based on row positions (fixed number of rows before/after).
RANGE → based on value range in the ORDER BY column.

*/

---------------------------------------------------------------------------------------------------------