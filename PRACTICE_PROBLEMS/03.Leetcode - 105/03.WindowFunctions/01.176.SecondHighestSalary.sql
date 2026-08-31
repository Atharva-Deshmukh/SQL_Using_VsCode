/* 176. Second Highest Salary

Table: Employee

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
id is the primary key (column with unique values) for this table.
Each row of this table contains information about the salary of an employee.
 

Write a solution to find the second highest distinct salary from the Employee table.
If there is no second highest salary, return null (return None in Pandas).

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+

Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+

Example 2:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+

Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| null                |
+---------------------+

I was stuck at how to return null.
Solution: Use MAX(salary), MAX(on empty result) returns null if there is no value

*/

SELECT MAX(salary) AS SecondHighestSalary 
FROM (
    SELECT salary, 
           DENSE_RANK() OVER (
            ORDER BY salary DESC
           ) AS rnk
    FROM Employee
) AS ALIAS_UNUSED 
WHERE rnk = 2;  


-- NTH Highest salary
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      SELECT MAX(salary) 
      FROM (
        SELECT salary, 
                DENSE_RANK() OVER (
                    ORDER BY salary DESC
                ) AS rnk
        FROM Employee
      ) AS UNUSED_ALIAS
      WHERE rnk = N
  );
END
