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