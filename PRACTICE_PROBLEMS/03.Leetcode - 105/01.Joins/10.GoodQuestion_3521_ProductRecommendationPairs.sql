/* 3521. Find Product Recommendation Pairs

Table: ProductPurchases

+-------------+------+
| Column Name | Type | 
+-------------+------+
| user_id     | int  |
| product_id  | int  |
| quantity    | int  |
+-------------+------+

Table: ProductInfo

+-------------+---------+
| Column Name | Type    | 
+-------------+---------+
| product_id  | int     |
| category    | varchar |
| price       | decimal |
+-------------+---------+

Amazon wants to implement the Customers who bought this also bought... feature 
based on co-purchase patterns. Write a solution to :

Identify distinct product pairs frequently purchased together by the same customers 
(where product1_id < product2_id)
For each product pair, determine how many customers purchased both products
A product pair is considered for recommendation if at least 3 different customers 
have purchased both products.

Return the result table ordered by customer_count in descending order, 
and in case of a tie, by product1_id in ascending order, and then by 
product2_id in ascending order.

The result format is in the following example.

ProductPurchases table:

+---------+------------+----------+
| user_id | product_id | quantity |
+---------+------------+----------+
| 1       | 101        | 2        |
| 1       | 102        | 1        |
| 1       | 103        | 3        |
| 2       | 101        | 1        |
| 2       | 102        | 5        |
| 2       | 104        | 1        |
| 3       | 101        | 2        |
| 3       | 103        | 1        |
| 3       | 105        | 4        |
| 4       | 101        | 1        |
| 4       | 102        | 1        |
| 4       | 103        | 2        |
| 4       | 104        | 3        |
| 5       | 102        | 2        |
| 5       | 104        | 1        |
+---------+------------+----------+

ProductInfo table:

+------------+-------------+-------+
| product_id | category    | price |
+------------+-------------+-------+
| 101        | Electronics | 100   |
| 102        | Books       | 20    |
| 103        | Clothing    | 35    |
| 104        | Kitchen     | 50    |
| 105        | Sports      | 75    |
+------------+-------------+-------+

Output:

+-------------+-------------+-------------------+-------------------+----------------+
| product1_id | product2_id | product1_category | product2_category | customer_count |
+-------------+-------------+-------------------+-------------------+----------------+
| 101         | 102         | Electronics       | Books             | 3              |
| 101         | 103         | Electronics       | Clothing          | 3              |
| 102         | 104         | Books             | Kitchen           | 3              |
+-------------+-------------+-------------------+-------------------+----------------+

Explanation:

Product pair (101, 102):
Purchased by users 1, 2, and 4 (3 customers)
Product 101 is in Electronics category
Product 102 is in Books category
Product pair (101, 103):
Purchased by users 1, 3, and 4 (3 customers)
Product 101 is in Electronics category
Product 103 is in Clothing category
Product pair (102, 104):
Purchased by users 2, 4, and 5 (3 customers)
Product 102 is in Books category
Product 104 is in Kitchen category
The result is ordered by customer_count in descending order. 
For pairs with the same customer_count, they are ordered by 
product1_id and then product2_id in ascending order.


APPROACH:

I was stuck at how to make the pairs in the first place, I could only think of GROUP BY user_id, product_id

for products, 101, 102, 103, pairs = [(101, 102), (101, 103), (102, 103)]

Hence we need to make pairs something like

+---------+-------------+-------------+
| user_id | product1_id | product1_id |
+---------+-------------+-------------+
| 1       | 101         | 102         |
| 1       | 101         | 103         |
| 1       | 102         | 103         |

To make these pairs, we can self join by user Ids

SELECT *
FROM ProductPurchases p1
JOIN ProductPurchases p2
    ON p1.user_id = p2.user_id

Here, we will get all the product pairs

p1.product | p2.product
-----------+-----------
101        | 101
101        | 102
101        | 103
102        | 101
102        | 102
102        | 103
103        | 101
103        | 102
103        | 103

We are given the pair filter in question (product1_id < product2_id)

SELECT
    p1.user_id,
    p1.product_id AS product1_id,
    p2.product_id AS product2_id
FROM ProductPurchases p1
JOIN ProductPurchases p2
    ON p1.user_id = p2.user_id
   AND p1.product_id < p2.product_id;

FOR user-1: we have

user_id | product1 | product2
--------+----------+---------
1       | 101      | 102
1       | 101      | 103
1       | 102      | 103

Similary, for all the users, the entire table becomes

user | product1 | product2
-----+----------+---------
1    | 101      | 102
1    | 101      | 103
1    | 102      | 103

2    | 101      | 102
2    | 101      | 104
2    | 102      | 104

3    | 101      | 103
3    | 101      | 105
3    | 103      | 105

4    | 101      | 102
4    | 101      | 103
4    | 101      | 104
4    | 102      | 103
4    | 102      | 104
4    | 103      | 104

5    | 102      | 104

Now, we have to count that pair(p1, p2) is bought by how many users --> GROUP BY product1_id, product2_idt

The query will be very big, hence we will use Common Table Expressions (CTEs)
*/

-- step-1: Create CTE for joining the purchases table and product table

-- New table with product info attached
WITH purchases AS (
    SELECT pp.user_id,
           pp.product_id,
           pi.category,
           pi.price
    FROM ProductPurchases AS pp
    JOIN ProductInfo AS pi
        ON pp.product_id = pi.product_id 
)

-- Step-2: Self join it to generate product pairs, group them and sort them as per the question conditions
SELECT p1.product_id AS product1_id,
       p2.product_id AS product2_id,
       p1.category AS product1_category,
       p2.category AS product2_category,
       COUNT(*) AS customer_count
FROM purchases AS p1    --      Use CTE here
JOIN purchases AS p2
    ON p1.user_id = p2.user_id
    AND p1.product_id < p2.product_id
GROUP BY product1_id, product2_id
HAVING customer_count >= 3
ORDER BY customer_count DESC, product1_id, product2_id;