/*
- GROUP BY collapses rows into groups, and aggregates (like COUNT, SUM) compute values for each group.
- So, GROUP BY helps summarize data into meaningful chunks.

- Instead of looking at individual rows, you group rows that share the same values in one or more columns.


👉 Real-world use cases:
- Find total sales per customer from an orders table.
- Count how many students are in each class year.
- Find the average salary per department in a company.

Why aggregate functions?
Because after grouping, you usually want to compute something per group 
(e.g., count, sum, average). 

✅ So in simple terms:
    GROUP BY = "put rows into buckets"
    Aggregate functions = "what do we want to calculate inside each bucket"

For example:
- How many students per year?
- What is the average score per subject?

- GROUP BY always comes after WHERE and before ORDER BY

- GROUP BY clause always follows a specific syntax in SQL (including MySQL).

✅ Basic Syntax
    SELECT column1, column2, ..., aggregate_function(columnN)
    FROM table_name
    WHERE condition
    GROUP BY column1, column2, ...   -- grouping happens here
    HAVING condition                 -- (optional) filter groups
    ORDER BY column1, column2, ...   -- (optional) sort results


-----------------------------------------------------------------

Ex Table used

                        +-----------+------+-------------+
                        | name      | year | subject     |
                        +-----------+------+-------------+
                        | Avery     |    1 | Mathematics |
                        | Elijah    |    2 | English     |
                        | Harper    |    3 | Science     |
                        | James     |    1 | Mathematics |
                        | Charlotte |    2 | English     |
                        | Benjamin  |    3 | Science     |
                        +-----------+------+-------------+

-----------------------------------------------------------------
How many students are there for each subject?

SELECT subject, COUNT(name)
FROM student
GROUP BY subject; 

subject	     COUNT(name)
------------------------
Mathematics     2
English	        2
Science	        2

We created 3 buckets for each subjects, and stored count of students in each bucket.

Now, this query is wrong:

SELECT subject, COUNT(name), year
FROM student
GROUP BY subject; 

Reasons: When you use GROUP BY, every column in the SELECT list must either be:
- Included in the GROUP BY clause, OR
- Used inside an aggregate function (COUNT(), SUM(), AVG(), etc.).

Corrected query: ALSO grouping multiple columns

SELECT subject, year, COUNT(name) as StudentCount
FROM student
GROUP BY subject, year; 

# subject	year	StudentCount
----------------------------
Mathematics	 1	        2
English	     2	        2       
Science	     3	        2


-----------------------------------------------------------------

👉 HAVING clause with group by clause


                            TABLE USED:

                            +--------+----------+----------+-----+
                            | emp_no | name     | sal      | age |
                            +--------+----------+----------+-----+
                            |      1 | Liam     | 50000.00 |  25 |
                            |      2 | Emma     | 60000.50 |  30 |
                            |      3 | Noah     | 75000.75 |  35 |
                            |      4 | Olivia   | 45000.25 |  28 |
                            |      5 | Ethan    | 80000.00 |  32 |
                            |      6 | Sophia   | 65000.00 |  27 |
                            |      7 | Mason    | 55000.50 |  29 |
                            |      8 | Isabella | 72000.75 |  31 |
                            |      9 | Logan    | 48000.25 |  26 |
                            |     10 | Mia      | 83000.00 |  33 |
                            +--------+----------+----------+-----+

Q) List down all the employees whose salary is greater than 60000

This query is wrong:
SELECT name, sal
FROM Emp
GROUP BY name
HAVING sal > 50000;   -- ❌ wrong

Problem:
- When you GROUP BY name, all rows with the same name are combined into one group.
- But inside that group, there may be multiple salary values (sal).
- SQL now has no idea which salary you mean — the first one? last one? average?
- That’s why you must use an aggregate function like SUM(), AVG(), MAX(), etc., 
  to tell SQL how to combine multiple rows into a single value.

Although for each name bucket, we have only one salary value, SQL doesn't know that.
Bascially we are just following the syntax rules of SQL by using an aggregate function.
In future if table changes and we have multiple salary values for a name, our query will still work.

SELECT name, SUM(sal) AS Salary
FROM emp
GROUP BY name
HAVING SUM(sal) >= 60000;   -- ✅ correct

OUTPUT:

# name	   Salary
-----------------
Emma	  60000.50
Noah	  75000.75
Ethan	  80000.00
Sophia	  65000.00
Isabella  72000.75
Mia	      83000.00


Q) group employees by age and display only those age groups where average salary is above 60,000.
SELECT age, SUM(sal)
FROM emp
GROUP BY age
HAVING SUM(sal) > 60000;

                                        Some practice Questions:
                                        ------------------------

-- Count how many employees have the same age
SELECT age, COUNT(emp_no)
FROM emp
GROUP BY age;

-- Show the average salary of employees grouped by age in ascending order
SELECT age, TRUNCATE(AVG(sal), 2)
FROM emp
GROUP BY age
ORDER BY age;

-- Show all ages where more than 1 employee exists
SELECT age , COUNT(emp_no) AS EMPLOYEES_WITH_AGE
FROM emp
GROUP BY age
HAVING COUNT(emp_no) > 1
ORDER BY age;

-- Find employees grouped by the first letter of their name
SELECT LEFT(name, 1) AS First_Name_Letter, COUNT(emp_no) AS EMP_COUNT
FROM emp
GROUP BY LEFT(name, 1);  -- OR GROUP BY First_Name_Letter

-- Find age groups where the average salary is greater than 60,000
SELECT age, TRUNCATE(AVG(sal), 2) as AVERAGE_SAL
FROM emp
GROUP BY age
HAVING AVERAGE_SAL > 60000;

-- Show total salary per age, but only keep ages where the total salary is more than 120,000
SELECT age, SUM(sal) as Total_Salary
FROM emp
GROUP BY age
HAVING Total_Salary > 120000
ORDER BY Total_Salary DESC;

-- Show employees ordered by salary (highest first) and break ties using age
SELECT name, age, sal
FROM emp
ORDER BY sal DESC, age ASC;








*/