/*
Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) 
and their respective average city populations (CITY.Population) 
rounded down to the nearest integer.

Note: CITY.CountryCode and COUNTRY.Code are matching key columns.

CITY TABLE
NAME, COUNTRYCODE, POPULATION

COUNTRY TABLE
CONTINENT, NAME, CODE


I forgot that Aggregate functions can be used with group by and they give resultes per groups

*/

SELECT COUNTRY.CONTINENT, FLOOR(AVG(CITY.POPULATION))
FROM COUNTRY 
INNER JOIN CITY 
    ON COUNTRY.CODE = CITY.COUNTRYCODE 
GROUP BY COUNTRY.CONTINENT;