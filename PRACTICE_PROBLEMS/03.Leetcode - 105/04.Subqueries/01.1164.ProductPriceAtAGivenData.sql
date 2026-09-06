/* 1164. Product Price at a Given Date

Table: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key (combination of columns with unique values) of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.
Initially, all products have price 10.

Write a solution to find the prices of all products on the date 2019-08-16.
Return the result table in any order.
The result format is in the following example.

Products table:
+------------+-----------+-------------+
| product_id | new_price | change_date |
+------------+-----------+-------------+
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |
+------------+-----------+-------------+

Output: 
+------------+-------+
| product_id | price |
+------------+-------+
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |
+------------+-------+

*/

WITH groupedRankedTable AS (
    SELECT 
        product_id,
        new_price,
        change_date,
        ROW_NUMBER() OVER (
            PARTITION BY product_id
            ORDER BY change_date DESC
        ) AS rnk
    FROM Products
    WHERE change_date <= '2019-08-16'      -- We filter those dates which are less than target
),


-- We left join with original table (filtered with DISTINCT ids only) because now, 
-- in Given example, for product_id = 3, it has no date > target date, it won't be shown in groupedRankedTable
-- But we need that row, even as null to give default value = 10
leftJoinedWithOriginalTable AS (
    SELECT 
        p.product_id,  -- only distinct product id is being fetched from P
        g.new_price,   -- rest other columns, take from g
        g.change_date,
        g.rnk
    FROM (SELECT DISTINCT product_id FROM Products) AS p
    LEFT JOIN groupedRankedTable AS g
        ON p.product_id = g.product_id
        AND g.rnk = 1 -- include only rank 1s from g table
)

/* Now, output is something like

| product_id | new_price | change_date | rnk  |
| ---------- | --------- | ----------- | ---- |
| 1          | 35        | 2019-08-16  | 1    |
| 2          | 50        | 2019-08-14  | 1    |
| 3          | null      | null        | null |

*/

SELECT product_id,
       COALESCE(new_price, 10) AS price
FROM leftJoinedWithOriginalTable;