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

    