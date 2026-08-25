Samantha calculates the average monthly salary incorrectly because her keyboards
0 key is broken. So, all zeros are removed from each salary before calculating
the incorrect average.

Find the difference between:
    1. Actual average salary
    2. Incorrect average salary (after removing all 0s from salaries)

Round the error UP to the next integer.

SAMPLE INPUT:

EMPLOYEES
+----+--------+
| ID | SALARY |
+----+--------+
| 1  | 1000   |
| 2  | 2000   |
| 3  | 3000   |
+----+--------+

BLUNDERED TABLE / SALARIES:

Original Salary    Salary after removing 0s
--------------     -------------------------
1000               1
2000               2
3000               3

ACTUAL AVERAGE:
    (1000 + 2000 + 3000) / 3 = 2000

INCORRECT AVERAGE:
    (1 + 2 + 3) / 3 = 2

ERROR:
    2000 - 2 = 1998

SAMPLE OUTPUT:

1998


SELECT
CEIL(
    AVG(Salary) - AVG(CAST(REPLACE(Salary, '0', '') AS UNSIGNED))
)
FROM EMPLOYEES;

-- LEARNINGS
REPLACE(Salary, '0', '')          -> Removes all 0s From number directly, no need to convert to string
CAST(... AS UNSIGNED)             -> Converts result back to number
AVG(Salary)                       -> Actual average
CEIL(...)                         -> Rounds UP to next integer