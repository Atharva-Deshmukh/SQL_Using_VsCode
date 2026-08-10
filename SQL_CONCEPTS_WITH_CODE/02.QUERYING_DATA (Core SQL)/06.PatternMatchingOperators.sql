/**********************************************************************
                    LIKE & REGEXP (Pattern Matching)
**********************************************************************/

/*
LIKE uses simple wildcards.

Wildcards in MySQL:
% → Zero or more characters
_ → Exactly one character

For advanced pattern matching, use REGEXP.
*/

----------------------------------------------------------------------
% Wildcard
----------------------------------------------------------------------

-- Starts with 'R'
SELECT * FROM Persons
WHERE FirstName LIKE 'R%';

-- Ends with 'ha'
SELECT * FROM Persons
WHERE FirstName LIKE '%ha';

-- Contains 'd'
SELECT * FROM Persons
WHERE FirstName LIKE '%d%';

-- Starts with 'k' and ends with 'D'
SELECT * FROM Persons
WHERE Address LIKE 'k%D';

----------------------------------------------------------------------
_ Wildcard
----------------------------------------------------------------------

-- Exactly 3 letters, starts with 'R'
SELECT * FROM Persons
WHERE FirstName LIKE 'R__';

-- Exactly 3 letters, ends with 'j'
SELECT * FROM Persons
WHERE FirstName LIKE '__j';

-- Exactly 5-letter word
SELECT * FROM Persons
WHERE FirstName LIKE '_____';

----------------------------------------------------------------------
Combining % and _
----------------------------------------------------------------------

-- Ends with 'd' followed by exactly one character
SELECT * FROM Persons
WHERE FirstName LIKE '%d_';

----------------------------------------------------------------------
REGEXP
----------------------------------------------------------------------

-- Starts with 'R' and ends with 'j'
SELECT * FROM Persons
WHERE FirstName REGEXP '^R.*j$';

/*
Common REGEXP Symbols

^      → Start of string
$      → End of string
.      → Any single character
.*     → Zero or more characters
[abc]  → a, b or c
[^abc]  → NOT a, b or c
*/