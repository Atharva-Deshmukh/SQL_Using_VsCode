-- AND: all conditions must be true
SELECT * FROM Persons
WHERE FirstName = 'Raj' AND LastName = 'Thakre';

SELECT * FROM Persons
WHERE PersonID = 4
  AND FirstName LIKE 'A%'
  AND City = 'Pune';

-- OR: any one condition can be true
SELECT * FROM Persons
WHERE FirstName = 'Raj' OR PersonID > 4;

SELECT * FROM Persons
WHERE FirstName = 'Raj'
   OR PersonID > 4
   OR City LIKE 'P%';

-- AND + OR
-- Use () to control evaluation.
-- Without (), AND is evaluated before OR.

SELECT * FROM Persons
WHERE PersonID = 4
  AND (FirstName LIKE 'A%' OR City = 'Pune');

-- Equivalent to:
-- (PersonID = 4 AND FirstName LIKE 'A%') OR City = 'Pune'
SELECT * FROM Persons
WHERE PersonID = 4
  AND FirstName LIKE 'A%'
   OR City = 'Pune';

-- NOT: negates a condition
SELECT * FROM Persons
WHERE NOT City = 'Pune';

-- BETWEEN / NOT BETWEEN: inclusive range
SELECT * FROM Persons WHERE PersonID BETWEEN 3 AND 6;
SELECT * FROM Persons WHERE PersonID NOT BETWEEN 3 AND 6;

-- IN / NOT IN: match from a list
SELECT * FROM Persons WHERE PersonID IN (1, 4);
SELECT * FROM Persons WHERE Address IN ('Kothrud', 'B-Lane');
SELECT * FROM Persons WHERE PersonID NOT IN (1, 4);