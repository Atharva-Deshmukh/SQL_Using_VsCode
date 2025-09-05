/*
In MySQL, we only use 2 wildcards with the LIKE and NOT LIKE operator:
% → any sequence of characters (0 or more)
_ → exactly one character
    It can be any character or number, but each _ represents one, and only one, character.

Wildcards have few characters and they are very limited, we overcome there shortages via REGEXP operator

Some wildcards, in general, not SQL specific:
* → matches zero or more characters (hello* → matches hello, helloworld, hello123).
? → matches exactly one character (h?llo → matches hello, hallo, but not hllo).
Character ranges (sometimes supported): [a-z] → matches one lowercase letter. */

/* ------------------------ % Character -----------------------------------------------*/

SELECT * FROM Persons WHERE FirstName LIKE 'R%';  -- All firstnames starting with 'R'
SELECT * FROM Persons WHERE FirstName LIKE '%ha';  -- All firstnames ending with 'ha'
SELECT * FROM Persons WHERE FirstName LIKE '%d%';  -- All firstnames having 'd' anywhere in the name

-- All addresses starting with 'k' and ending with 'D', anything in between
-- Case insensitive
SELECT * FROM Persons WHERE Address LIKE 'k%D';

/* ------------------------ _ Character -----------------------------------------------------*/

SELECT * FROM Persons WHERE FirstName LIKE 'R__';  -- Any 3 letter word starting with 'R'
SELECT * FROM Persons WHERE FirstName LIKE '__j';  -- Any 2 letters ending with 'j'
SELECT * FROM Persons WHERE FirstName LIKE '_____';  -- Any 6 letter word (_ 6 times)


/* ------------------------ % and _ Character -----------------------------------------------*/

SELECT * FROM Persons WHERE FirstName LIKE '%d_';

/* ----------------------------------- REGEXP -----------------------------------------------*/

-- Matches using regexp, any word that starts with R and ends with J
SELECT * FROM Persons WHERE FirstName REGEXP '^r.*j$'; 


/* Some more regexp patterns

. → matches any single character
.* → matches zero or more characters
[abc] → matches a, b, or c
^ → beginning of string
$ → end of string */