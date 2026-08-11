/*

Query the Name of any student in STUDENTS who scored higher than 75 Marks. 
Order your output by the last three characters of each name. 
If two or more students both have names ending in the same last three characters 
(i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.


Important functions to be remebered:
-------------------------------------

First 2 characters	--> LEFT(Name, 2)
First 3 characters	--> LEFT(Name, 3)
Last 2 characters	--> RIGHT(Name, 2)
Last 3 characters	--> RIGHT(Name, 3)

SUBSTRING(string, starting_position, number_of_characters)

Take 3 chars from postition 2	        -->     SUBSTRING(Name, 2, 3)
Take 3 chars from 3rd position from end -->     SUBSTRING(Name, -3, 3)
*/

SELECT Name FROM STUDENTS 
WHERE Marks > 75
ORDER BY SUBSTRING(Name, -3, 3) ASC, ID ASC; 

