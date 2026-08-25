Euclidean Distance = 	SQRT(POWER(x2-x1,2) + POWER(y2-y1,2))
Manhattan Distance = 	ABS(x2-x1) + ABS(y2-y1)

Question:
Consider  and  to be two points on a 2D plane.

 happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
 happens to equal the minimum value in Western Longitude (LONG_W in STATION).
 happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
 happens to equal the maximum value in Western Longitude (LONG_W in STATION).

Query the Manhattan Distance between points  and  and round it to a scale of 
 decimal places.

 SELECT
    ROUND((ABS(MAX(LAT_N) - MIN(LAT_N)) + ABS(MAX(LONG_W) - MIN(LONG_W))), 4)
FROM STATION;


Euclidean distance can be similarly calculated

SELECT 
    ROUND(SQRT(POWER(MAX(LAT_N) - MIN(LAT_N), 2) + POWER(MAX(LONG_W) - MIN(LONG_W), 2)), 4)
FROM STATION;