/*
Find the difference between the total number of CITY entries in the table 
and the number of distinct CITY entries in the table.
*/

SELECT COUNT(CITY) - COUNT(DISTINCT CITY) FROM STATION;

/*

The important thing is that SELECT isn't actually being applied separately to both.

SQL first looks at --> FROM STATION
So it gets the rows from STATION.

Then it evaluates the expression after SELECT --> COUNT(CITY) - COUNT(DISTINCT CITY)

    You can think of it roughly like:

    COUNT(CITY)              → 100
    COUNT(DISTINCT CITY)     →  80
                              ----
                                20

The SELECT simply says --> "Return the result of this expression."
So: SELECT 100 - 80 would return: 20

*/