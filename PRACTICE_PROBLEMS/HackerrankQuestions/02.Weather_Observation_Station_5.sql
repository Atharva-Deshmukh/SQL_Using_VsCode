/*
Query the two cities in STATION with the shortest and longest CITY names, 
as well as their respective lengths (i.e.: number of characters in the name). 
If there is more than one smallest or largest city, choose the one that comes 
first when ordered alphabetically.
*/

SELECT CITY, LENGTH(CITY) FROM STATION 
ORDER BY LENGTH(CITY) ASC, 
         CITY ASC
LIMIT 1;  -- returns 1 row only

SELECT CITY, LENGTH(CITY) FROM STATION 
ORDER BY LENGTH(CITY) DESC,
         CITY ASC
LIMIT 1;

-- This can be also given under a single query using a subquery and union all

SELECT CITY, LENGTH(CITY)
FROM (
    SELECT CITY, LENGTH(CITY)
    FROM STATION
    ORDER BY LENGTH(CITY) ASC, CITY ASC
    LIMIT 1
) AS shortest

UNION ALL

SELECT CITY, LENGTH(CITY)
FROM (
    SELECT CITY, LENGTH(CITY)
    FROM STATION
    ORDER BY LENGTH(CITY) DESC, CITY ASC
    LIMIT 1
) AS longest;
