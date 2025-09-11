/* 

Ex:

       emp_manager (t1)                     emp_manager (t2)
+-------+----------+-----------+     +-------+----------+-----------+
| EmpId | EmpName  | ManagerId |     | EmpId | EmpName  | ManagerId |
+-------+----------+-----------+     +-------+----------+-----------+
|   1   | Atharva  |     3     |     |   1   | Atharva  |     3     |
|   2   | Tushar   |     3     |     |   2   | Tushar   |     3     |
|   3   | Vishal   |     5     |     |   3   | Vishal   |     5     |
|   4   | Varad    |     2     |     |   4   | Varad    |     2     |
|   5   | Aditya   |   NULL    |     |   5   | Aditya   |   NULL    |  Aditya is managed by no one, top in hierarchy
+-------+----------+-----------+     +-------+----------+-----------+


Why do we even need to join a table with itself only?
----------------------------------------------------

Use case addressed by this: 
Based on the above two tables (duplicates), create two columns EmpName and corresponding ManagerName

In real life, Every employee has an EmpId (their own identity).
ManagerId points to another employee’s EmpId in the same table.
This is exactly how most HR/Org data is stored in real systems.

We cannot use SELECT like this directly
SELECT EmpName, ManagerId
FROM employees
WHERE ManagerId = EmpId;

Since, Select iterates row wise, and in each iteration, 
it compares emp_id of that row with manager_id OF THAT ROW

This is the case where we need to apply joins on the same table, self join, since join is always for 
two tables.
We here need to compare one row entity with another row entity at a time

To avoid ambiguity due to same table names, we ALIAS table two times

While ALIAS, we generally dont use AS for tablename, we use AS for column name only, its just a practice

- Tables → omit AS → FROM employees e
- Columns → keep AS → SELECT e.name AS EmployeeName

In real DBs, the tables are very long, and we need to scroll a lot to know the managerId for empId
Hence, joining two table is best there. */

SELECT t1.EmpName, t2.EmpName as ManagerName
FROM emp_manager AS t1    -- Aliasing same table
JOIN emp_manager AS t2    -- Aliasing same table
ON t1.ManagerId = t2.EmpId;

/* OUTPUT

#  EmpName	ManagerName
----------------------
    Varad	 Tushar
    Tushar	 Vishal
   Atharva	 Vishal
   Vishal	 Aditya

In each iteration, the query matches managerId of t1 with empId of t2 */

