Employee

   | employee_id | name  |last_name| age | department_id | manager_id | salary | experience_years | status | hire_date  |
   |-------------|-------|---------|-----|---------------|------------|--------|------------------|--------|------------|
   | 1           | John  |Joseph   | 35  | 10            | NULL       | 90000  | 8                | A      | 2018-03-15 |
   | 2           | Alice |Anderson | 29  | 10            | 1          | 70000  | 4                | A      | 2021-06-10 |
   | 3           | Bob   |Buffet   | 31  | 20            | 5          | 60000  | 3                | I      | 2022-01-20 |
   | 4           | Carol |Collins  | 24  | NULL          | 1          | 50000  | 1                | A      | 2025-02-05 |
   | 5           | David |Dance    | 40  | 20            | NULL       | 80000  | 10               | A      | 2016-09-12 |

PROBLEMS
--------

1. Find length of each employee name.

    SELECT name, LENGTH(name) AS Len FROM Employee;


2. Convert names to uppercase.

    SELECT name, UPPER(name) AS UpperCase FROM Employee;

3. Convert names to lowercase.

    SELECT name, LOWER(name) AS LowerCase FROM Employee;

4. Extract first 3 characters.

    --                         one-based indexing
    SELECT name, SUBSTRING(name, 1, 3) AS FirstThreeChars FROM Employee;

    SELECT name, LEFT(name, 3) AS FIRST_3 FROM Employee;  -- BETTER APPROACH    

5. Extract last 3 characters.

    SELECT name, RIGHT(name, 3) AS LAST_3 FROM Employee;

6. Find names beginning with A. -- REVISE

    SELECT name 
    FROM Employee
    WHERE name REGEXP '^[Aa].*$';

7. Find names containing 'a'.  -- REVISE This less complicated regexp

    SELECT name 
    FROM Employee
    WHERE name REGEXP '[Aa]';

8. Concatenate first_name and last_name.
   (Create/use a small table with both columns.)

   SELECT name, last_name,
    CONCAT(name, " ", last_name) AS ConcatenatedName
   FROM Employee;

9. Replace a substring in employee names. -- REVISE

    SELECT name,
    REPLACE(name, 'a', 'X') AS ModifiedName
    FROM Employee;

    Output:
    +-------+--------------+
    | name  | ModifiedName |
    +-------+--------------+
    | John  | John         |
    | Alice | Alice        |
    | Bob   | Bob          |
    | Carol | CXrol        |
    | David | DXvid        |
    +-------+--------------+

10. Find the position of 'o' in each employee name.  -- REVISE, didn't know this function

    SELECT name,
        LOCATE('o', name) AS position
    FROM Employee;

    Output:
    +-------+----------+
    | name  | position |
    +-------+----------+
    | John  |        2 |
    | Alice |        0 |
    | Bob   |        2 |
    | Carol |        4 |
    | David |        0 |
    +-------+----------+

