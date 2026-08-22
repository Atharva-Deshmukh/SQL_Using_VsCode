EXISTS is used to check whether a subquery returns at least one row.

Basic syntax:

   WHERE EXISTS (
       SELECT 1
       FROM table
       WHERE condition
   );

EXISTS returns TRUE if the subquery returns at least one row.
EXISTS returns FALSE if the subquery returns no rows.

Example:

   SELECT name
   FROM Employee AS e
   WHERE EXISTS (
       SELECT 1
       FROM Department AS d
       WHERE d.department_id = e.department_id
   );

   Meaning:
   For each employee, check whether a matching department
   exists in the Department table.

Why SELECT 1?

   Inside EXISTS, the actual value being selected does not matter.
   EXISTS only checks whether the subquery returns at least one row.

   Therefore, these are conceptually equivalent:

   SELECT 1
   FROM Department
   WHERE ...

   SELECT department_id
   FROM Department
   WHERE ...

EXISTS is commonly used with a correlated subquery.

   Example:

   SELECT name
   FROM Employee AS e
   WHERE EXISTS (
       SELECT 1
       FROM Department AS d
       WHERE d.department_id = e.department_id
   );

   The inner query depends on the current outer row.

EXISTS vs IN:

    IN:
    "Is this value present in the results of the subquery?"

    EXISTS:
    "Does at least one matching row exist?"

Common use case:

    Find employees whose department exists:

    SELECT name
    FROM Employee AS e
    WHERE EXISTS (
        SELECT 1
        FROM Department AS d
        WHERE d.department_id = e.department_id
    );
