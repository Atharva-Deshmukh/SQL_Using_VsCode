Query the average population for all cities in CITY, rounded down to the nearest integer.

SELECT ROUND(AVG(POPULATION))
FROM CITY;

-- Another Similar question

Query the following two values from the STATION table:

The sum of all values in LAT_N rounded to a scale of  decimal places.
The sum of all values in LONG_W rounded to a scale of  decimal places.

SELECT ROUND(SUM(LAT_N), 2), ROUND(SUM(LONG_W), 2)
FROM STATION;

-- Another Similar question

Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than  
and less than . Truncate your answer to  decimal places.

SELECT ROUND(SUM(LAT_N), 4)
FROM STATION
WHERE LAT_N BETWEEN 38.7880 AND 137.2345;

--

Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in 
STATION that is less than . Round your answer to  decimal places.

SELECT ROUND(LONG_W, 4)
FROM STATION
WHERE LAT_N = (
    SELECT MAX(LAT_N) FROM STATION
    WHERE LAT_N < 137.2345
);
