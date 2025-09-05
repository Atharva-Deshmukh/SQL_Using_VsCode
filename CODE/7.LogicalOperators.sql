-- ---------------------------------------AND------------------------------
-- All conditions must hold true for any filtering to happen

SELECT * FROM Persons WHERE 
FirstName = 'Raj' AND LastName = 'Thakre';

-- There can be multiple AND operators, All conditions must hold true for any filtering to happen
SELECT * FROM Persons WHERE 
PersonID = 4 AND 
FirstName LIKE 'A%' AND
City = 'Pune';

------------------------------------------OR--------------------------------------
-- Any one condition must hold true for any filtering to happen

SELECT * FROM Persons WHERE 
FirstName = 'Raj' OR PersonId > 4;

SELECT * FROM Persons WHERE 
FirstName = 'Raj' OR 
PersonId > 4 OR 
City LIKE 'P%';

---------------------------------Combining AND and OR--------------------------------------

-- Give parenthesis to specify the order in which evaluation must happen
-- Without parenthesis, AND is evaluated first, then OR

-- With parenthesis
SELECT * FROM Persons WHERE 
PersonId = 4 AND 
(FirstName LIKE 'a%' OR City = 'Pune');

-- Without parenthesis, AND will preceed OR
SELECT * FROM Persons WHERE 
PersonId = 4 AND 
FirstName LIKE 'a%' OR City = 'Pune';

-- Second query is read as => (PersonId = 4 AND FirstName LIKE 'a%' ) OR City = 'Pune';
-- Either records with id 4 and starting with a are filtered OR
-- All records with City = 'Pune' are filtered

---------------------------------NOT operator--------------------------------------
-- It negates a condition
SELECT * FROM Persons WHERE NOT City = 'Pune';
