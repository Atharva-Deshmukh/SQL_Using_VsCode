/* A median is defined as a number separating the higher half of a data set 
from the lower half. Query the median of the Northern Latitudes (LAT_N) 
from STATION and round your answer to  decimal places.

        ODD ELEMENTS: 1, 2, 3, 4, 5  ->  5
                            3  
                    (FLOOR(5/2) + 1)th term    
            
       EVEN ELEMENTS: 1, 2, 3, 4, 5, 6 -> 6
                         (3 + 4)/2 = 3  
                 (FLOOR(6/2) + FLOOR(6/2) + 1)th terms    


Recall that in Binary Search DSA also, we used + 1 to handle both even and odd cases

 ODD -> 5 -> [3, 3] -> [FLOOR((total + 1) / 2), CEIL((total + 1) / 2)]
EVEN -> 6 -> [3, 4] -> [FLOOR((total + 1) / 2), CEIL((total + 1) / 2)]

*/

SELECT ROUND(AVG(LAT_N), 4)
FROM (
    SELECT LAT_N,
           ROW_NUMBER() OVER (ORDER BY LAT_N) AS rn,
           COUNT(*) OVER () AS total
    FROM STATION
) AS t
WHERE rn IN (
    FLOOR((total + 1) / 2),
    CEIL((total + 1) / 2)
);

/*

Example:

LAT_N
-----
10
20
30
40
50

After ROW_NUMBER():

LAT_N    rn
-----    --
10       1
20       2
30       3
40       4
50       5


COUNT(*) OVER ()

counts the total number of rows WITHOUT grouping them.

Example:

LAT_N    rn    total
-----    --    -----
10       1      5
20       2      5
30       3      5
40       4      5
50       5      5

total = 5 for every row.

Important:

COUNT(*) OVER () ≠ COUNT(*)

COUNT(*) normally gives one result for the whole table.

COUNT(*) OVER () keeps every row and adds the total count to each row.

creates a temporary result.

Example:

LAT_N    rn    total
-----    --    -----
10       1      5
20       2      5
30       3      5
40       4      5
50       5      5
*/