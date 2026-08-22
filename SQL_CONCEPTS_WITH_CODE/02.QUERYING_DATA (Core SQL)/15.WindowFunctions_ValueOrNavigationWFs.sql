/*
===========================================================
VALUE / NAVIGATION WINDOW FUNCTIONS
===========================================================

Value / Navigation window functions allow us to ACCESS values from other rows without collapsing the result.

Main functions:

    LAG()         → previous row
    LEAD()        → next row
    FIRST_VALUE() → first value
    LAST_VALUE()  → last value
    NTH_VALUE()   → Nth value


===========================================================
LAG()
===========================================================

LAG() gets a value from a PREVIOUS row.

Ex:

    +----+--------+
    | id | amount |
    +----+--------+
    | 1  | 100    |
    | 2  | 200    |
    | 3  | 150    |
    | 4  | 300    |
    | 5  | 50     |
    +----+--------+

Query:

    SELECT id, amount,
        LAG(amount, 1, 0) OVER(
            ORDER BY id
        ) AS previous_amount
    FROM Sales;

Output:

    +----+--------+-----------------+
    | id | amount | previous_amount |
    +----+--------+-----------------+
    | 1  | 100    | 0               |    100 → no previous row → 0
    | 2  | 200    | 100             |
    | 3  | 150    | 200             |
    | 4  | 300    | 150             |
    | 5  | 50     | 300             |
    +----+--------+-----------------+


LAG(amount, 1, 0)

    1 → move 1 row backward
    0 → value to return when no previous row exists


===========================================================
LEAD()
===========================================================

LEAD() gets a value from a FOLLOWING row.

Ex:

    +----+--------+
    | id | amount |
    +----+--------+
    | 1  | 100    |
    | 2  | 200    |
    | 3  | 150    |
    | 4  | 300    |
    | 5  | 50     |
    +----+--------+

Query:

    SELECT id, amount,
        LEAD(amount, 1, 0) OVER(
            ORDER BY id
        ) AS next_amount
    FROM Sales;

Output:

    +----+--------+-------------+
    | id | amount | next_amount |
    +----+--------+-------------+
    | 1  | 100    | 200         |
    | 2  | 200    | 150         |
    | 3  | 150    | 300         |
    | 4  | 300    | 50          |
    | 5  | 50     | 0           |    50  → no next row → 0
    +----+--------+-------------+

===========================================================
FIRST_VALUE()
===========================================================

FIRST_VALUE() returns the FIRST value of the window frame

Ex:

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

    SELECT id, region, amount,
        FIRST_VALUE(amount) OVER(
            PARTITION BY region
            ORDER BY amount DESC
        ) AS highest_amount
    FROM Sales;

Output:

+----+--------+--------+----------------+
| id | region | amount | highest_amount |
+----+--------+--------+----------------+
| 1  | East   | 200    | 200            |
| 2  | East   | 100    | 200            |
| 3  | East   | 50     | 200            |
| 4  | West   | 300    | 300            |
| 5  | West   | 150    | 300            |
+----+--------+--------+----------------+

===========================================================
LAST_VALUE()
===========================================================

LAST_VALUE() returns the LAST value in the window frame.

Ex:

    +----+--------+--------+
    | id | region | amount |
    +----+--------+--------+
    | 1  | East   | 200    |
    | 2  | East   | 100    |
    | 3  | East   | 50     |
    +----+--------+--------+

Query:

    SELECT id, region, amount,
        LAST_VALUE(amount) OVER(
            PARTITION BY region
            ORDER BY amount DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS lowest_amount
    FROM Sales;


Window Frame --> window of (from row) to the (to row)
UNBOUNDED PRECEDING -->  means go full backwards from current row
                        if row = 2 --> Frame = [200, 100]

Output:

    +----+--------+--------+---------------+
    | id | region | amount | lowest_amount |
    +----+--------+--------+---------------+
    | 1  | East   | 200    | 50            |   Window = [200, 100, 50] || 50 -> Last value of the FULL FRAME
    | 2  | East   | 100    | 50            |   Window = [200, 100, 50] || 50 -> Last value of the FULL FRAME
    | 3  | East   | 50     | 50            |   Window = [200, 100, 50] || 50 -> Last value of the FULL FRAME
    +----+--------+--------+---------------+

NOTE:
    If we won't consider FULL FRAME, then we may get the last value as the current row itself, 
    and this can be confusing as we may think why are we not getting the last value

Query:

    SELECT id, region, amount,
        LAST_VALUE(amount) OVER(
            PARTITION BY region
            ORDER BY amount DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS lowest_amount
    FROM Sales;

Output:

    +----+--------+--------+---------------+
    | id | region | amount | lowest_amount |
    +----+--------+--------+---------------+
    | 1  | East   | 200    | 200           |   Window = [200] ||              200 -> Last value of the CURRENT FRAME
    | 2  | East   | 100    | 100           |   Window = [200, 100] ||         100 -> Last value of the CURRENT FRAME
    | 3  | East   | 50     | 50            |   Window = [200, 100, 50] ||      50 -> Last value of the CURRENT FRAME
    +----+--------+--------+---------------+


FULL FRAME means --> ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

We can but generally don't use ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING 
with FIRST_VALUE() because the first row is already inside the default frame.

===========================================================
NTH_VALUE()
===========================================================

NTH_VALUE() returns the Nth value in the window.

Ex:

    +----+--------+--------+
    | id | region | amount |
    +----+--------+--------+
    | 1  | East   | 200    |
    | 2  | East   | 100    |
    | 3  | East   | 50     |
    +----+--------+--------+

Query:

    SELECT id, region, amount,
        NTH_VALUE(amount, 2) OVER(         --> N = 2
            PARTITION BY region
            ORDER BY amount DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS second_highest
    FROM Sales;

Output:

    +----+--------+--------+---------------+
    | id | region | amount | second_highest|
    +----+--------+--------+---------------+
    | 1  | East   | 200    | 100           |
    | 2  | East   | 100    | 100           |
    | 3  | East   | 50     | 100           |
    +----+--------+--------+---------------+

===========================================================
COMMON INTERVIEW PATTERNS
===========================================================

Question:
    Find the previous salary of each employee.

Answer:
    LAG(salary) OVER(
        ORDER BY employee_id
    )


Question:
    Find the next transaction amount.

Answer:
    LEAD(amount) OVER(
        ORDER BY transaction_date
    )


Question:
    Find the highest salary in each department and display it on every employee row.

Answer:
    FIRST_VALUE(salary) OVER(
        PARTITION BY department
        ORDER BY salary DESC
    )


Question:
    Find the lowest salary in each department and display it on every employee row.

Answer:
    LAST_VALUE(salary) OVER(
        PARTITION BY department
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING   --> means the entire partition, not the entire table 
    )                                                                  since we have PARTITION BY now
                      

Question:
    Find the second-highest salary in each department.

Answer:
    NTH_VALUE(salary, 2) OVER(
        PARTITION BY department
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )

===========================================================