/*
A JOIN clause is used to combine rows from two or more tables, 
based on a related column between them in RDBMS.

The fundamental SQL joins most commonly referenced across web sources are:

INNER JOIN → returns only matching rows from both tables.
LEFT JOIN (LEFT OUTER JOIN) → returns all rows from the left table and matching rows from the right.
RIGHT JOIN (RIGHT OUTER JOIN) → returns all rows from the right table and matching rows from the left.
FULL OUTER JOIN → returns all rows from both tables, with NULLs where there is no match.
CROSS JOIN → returns the Cartesian product of the two tables.

Full outer join is not supported in MySQL

Some sources also mention SELF JOIN as a special case (not really a separate type, 
but an INNER JOIN of a table with itself).
*/