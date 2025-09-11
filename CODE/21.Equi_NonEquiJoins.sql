/* EQUI JOINS
--------------
An Equi Join is just a join where the condition uses equality (=) between columns.

Example:

SELECT e.EmpName, d.DeptName
FROM employees e
JOIN departments d
  ON e.DeptId = d.DeptId;

This is basically the same as an INNER JOIN with = condition.

Most of the joins written till now were equi joins

NON-EQUI JOINS
--------------

A Non-Equi Join uses conditions other than = (like <, >, BETWEEN, etc.).
Example: Suppose we have employees with salaries, and we have a salary grade table:

           employees                           salary_grades
+--------+---------+--------+       +---------+------------+------------+
| EmpId  | Name    | Salary |       | GradeId | MinSalary  | MaxSalary  |
+--------+---------+--------+       +---------+------------+------------+
| 1      | John    | 2500   |       | A       | 0          | 3000       |
| 2      | Emma    | 4000   |       | B       | 3001       | 5000       |
| 3      | Ravi    | 7000   |       | C       | 5001       | 8000       |
+--------+---------+--------+       +---------+------------+------------+
*/

SELECT e.Name, e.Salary, s.GradeId
FROM employees e
JOIN salary_grades s
  ON e.Salary BETWEEN s.MinSalary AND s.MaxSalary;

/* Output:

#   Name	    Salary	    GradeId
-----------------------------------
    John	    2500.00	        A
    Joe	        2900.00	        A
    Emma	    4000.00	        B
    Ravi	    7000.00	        C

GradeId Column is selected as per the range of salary in table 2
*/