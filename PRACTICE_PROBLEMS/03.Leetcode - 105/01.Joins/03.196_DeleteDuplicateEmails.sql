/* 196. Delete Duplicate Emails

Table: Person

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table contains an email. The emails will not contain uppercase letters.
 

Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.

After running your script, the answer shown is the Person table. 
The driver will first compile and run your piece of code and then show the Person table. 
The final order of the Person table does not matter.

The result format is in the following example.

Input: 

    Person table:
    +----+------------------+
    | id | email            |
    +----+------------------+
    | 1  | john@example.com |
    | 2  | bob@example.com  |
    | 3  | john@example.com |
    +----+------------------+

Output: 
    +----+------------------+
    | id | email            |
    +----+------------------+
    | 1  | john@example.com |
    | 2  | bob@example.com  |
    +----+------------------+
Explanation: john@example.com is repeated two times. We keep the row with the smallest Id = 1.

*/

-- Niave way: It doesn't work because we need to modify the original table itself
SELECT MIN(Person.id) AS id, Person.email AS email
FROM Person
GROUP BY Person.email;

-- We can delete this using JOIN ITSELF
DELETE P1
FROM Person AS P1 
JOIN Person AS P2
    ON (P1.email = P2.email) AND (P1.id > P2.id);