/*
===========================================================
SELF JOIN → A table is joined with itself.
===========================================================

Use case:
→ When a row references another row in the SAME table.

Example:

emp_manager
+-------+----------+-----------+
| EmpId | EmpName  | ManagerId |
+-------+----------+-----------+
| 1     | Atharva  | 3         |
| 2     | Tushar   | 3         |
| 3     | Vishal   | 5         |
| 4     | Varad    | 2         |
| 5     | Aditya   | NULL      |
+-------+----------+-----------+

ManagerId → refers to another employee's EmpId.

Goal:
EmpName → ManagerName

===========================================================
QUERY
===========================================================

SELECT t1.EmpName,
       t2.EmpName AS ManagerName
FROM emp_manager t1
JOIN emp_manager t2
    ON t1.ManagerId = t2.EmpId;

t1 → Employee
t2 → Manager

ON:
    t1.ManagerId = t2.EmpId

Meaning:
    Employee's ManagerId
            ↓
    find that employee's EmpId
            ↓
    get Manager's EmpName

===========================================================
OUTPUT
===========================================================

+---------+-------------+
| EmpName | ManagerName |
+---------+-------------+
| Atharva | Vishal      |
| Tushar  | Vishal      |
| Vishal  | Aditya      |
| Varad   | Tushar      |
+---------+-------------+

Aditya → ManagerId = NULL
        → no matching manager
        → excluded because JOIN = INNER JOIN

===========================================================
IMPORTANT
===========================================================

SELF JOIN is NOT a separate JOIN type.
SELF JOIN = joining a table with itself.

Here:
       JOIN = INNER JOIN
       SELF JOIN = INNER JOIN of emp_manager with itself
*/
