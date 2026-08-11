/*
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
1.1: ROW_NUMBER()
===========================================================

ROW_NUMBER() gives every row a UNIQUE sequential number.

Ex: Sales

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

East is numbered independently:
    200 → 1
    100 → 2
    50  → 3

West is numbered independently:
    300 → 1
    150 → 2

USE WHEN:
→ You need a unique sequential number
→ Top 1 / Top N per group


===========================================================
1.2: ROW_NUMBER() WITH TIES
===========================================================

ROW_NUMBER() always gives different numbers to different rows.

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
    | 2  | East   | 200    | 2       |  --> NOTE: The two 200s DO NOT receive the same row number.
    | 3  | East   | 150    | 3       |
    | 4  | East   | 100    | 4       |
    +----+--------+--------+---------+


IMPORTANT:
    If ORDER BY contains ties, SQL may choose an arbitrary
    order between tied rows unless you provide another tie-breaking column.

    For deterministic numbering:

    ROW_NUMBER() OVER(
        PARTITION BY region
        ORDER BY amount DESC, id
    )

===========================================================
2. RANK()
===========================================================

RANK() gives the SAME rank to tied values. 
After a tie, ranks are SKIPPED.

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

    SELECT id, amount,
        RANK() OVER(
            ORDER BY amount DESC   --> We need to rank everyone together, hence skipped PARTITION BY
        ) AS rnk
    FROM Sales;


Output:

    +----+--------+-----+
    | id | amount | rnk |
    +----+--------+-----+
    | 1  | 200    | 1   |
    | 2  | 200    | 1   |   Top Two rows occupy rank 1.
    | 3  | 150    | 3   |   Rank 2 is skipped.
    | 4  | 100    | 4   |
    +----+--------+-----+

===========================================================
3. DENSE_RANK()
===========================================================

DENSE_RANK() also gives the SAME rank to tied values BUT It does NOT skip numbers after a tie.

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
        id, amount,
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
    | 3  | 150    | 2         | No rank is skipped.
    | 4  | 100    | 3         |
    +----+--------+-----------+

    ===========================================================
    USE CASE OF RANKING WINDOW FUNCTIONS -->  TOP N PER GROUP
    ===========================================================

    Question 
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
            SELECT id, dept, salary,
                ROW_NUMBER() OVER(
                    PARTITION BY dept
                    ORDER BY salary DESC
                ) AS rn       
            FROM Employees
        ) AS ranked_employees        --> SQL requires a subquery in the FROM clause to have a name/alias
        WHERE rn <= 2;                   ranked_employees is not used anywhere, it just fulfills syntax requirement


    Working:

        Inner query creates a temporary result and ranked_employees names that temporary result

        +----+------+--------+----+
        | id | dept | salary | rn |
        +----+------+--------+----+
        | 1  | A    | 10000  | 1  |
        | 2  | A    | 9000   | 2  |
        | 3  | A    | 8000   | 3  |
        | 4  | B    | 12000  | 1  |
        | 5  | B    | 11000  | 2  |
        | 6  | B    | 7000   | 3  |
        +----+------+--------+----+

    Output:

        +----+------+--------+----+
        | id | dept | salary | rn |
        +----+------+--------+----+
        | 1  | A    | 10000  | 1  |
        | 2  | A    | 9000   | 2  |
        | 4  | B    | 12000  | 1  |
        | 5  | B    | 11000  | 2  |
        +----+------+--------+----+

WHY THE SUBQUERY?
    Window functions create the ranking first.
    But we need to FILTER the ranking afterward.


===========================================================
4. NTILE(N)
===========================================================

NTILE(N) divides ordered rows into N approximately equal buckets.

Syntax:

    NTILE(2) OVER(
        ORDER BY amount DESC
    )

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

    SELECT id, amount,
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

5 rows ÷ 2 buckets
    → Bucket 1 gets 3 rows
    → Bucket 2 gets 2 rows


IMPORTANT:
    If rows cannot be divided equally, earlier buckets receive the extra rows.

===========================================================
5. NTILE(4) — QUARTILES
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

→ Customer segmentation
→ Salary bands
→ Top/middle/bottom groups
→ Performance-wise segmentation

===========================================================
PARTITION BY WITH RANKING
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
    | 3  | B    | 12000  | 1   |    The ranking RESTARTS for every partition.
    | 4  | B    | 9000   | 2   |
    +----+------+--------+-----+

===========================================================
INTERVIEW QUESTION PATTERNS

    TOP N ROWS
    → ROW_NUMBER()

    TOP N RANKS / POSITIONS WITH TIES
    → RANK() or DENSE_RANK()

    TOP N DISTINCT VALUES
    → DENSE_RANK()

    BUCKET / QUARTILE / PERCENTILE-STYLE GROUPING
    → NTILE(N)
===========================================================

Question:
    Find the highest-paid employee in each department.

    ROW_NUMBER() + PARTITION BY department + ORDER BY salary DESC
    ROW_NUMBER() because for duplicate rows also, row number is unique

Question:
    Find the top 3 salaries in each department, including ties.

    DENSE_RANK() + PARTITION BY department + ORDER BY salary DESC


Question:
    Assign a unique sequence to employees within each department.

    ROW_NUMBER() + PARTITION BY department


Question:
    Divide customers into four equal groups.

    NTILE(4)


Question:
    Rank all employees by salary.

    RANK() + ORDER BY salary DESC