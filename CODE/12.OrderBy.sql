CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    SupplierID INT,
    CategoryID INT,
    Unit VARCHAR(50),
    Price DECIMAL(10,2)   -- for money values (can store 21.35 properly)
);

INSERT INTO Product (ProductID, ProductName, SupplierID, CategoryID, Unit, Price) VALUES
(1, 'Chais', 1, 1, '10 boxes x 20 bags', 18.00),
(2, 'Chang', 1, 1, '24 - 12 oz bottles', 19.00),
(3, 'Aniseed Syrup', 1, 2, '12 - 550 ml bottles', 10.00),
(4, 'Chef Anton''s Cajun Seasoning', 2, 2, '48 - 6 oz jars', 22.00),
(5, 'Chef Anton''s Gumbo Mix', 2, 2, '36 boxes', 21.35);

-- The ORDER BY keyword is used to sort the result-set in ascending or descending order.

-- Default is ASC (ascending)
SELECT * FROM Product
ORDER BY Price;

-- For descending order, we need to write DESC explicitly
SELECT * FROM Product
ORDER BY Price DESC;

-- To sort any column alphabetically
SELECT * FROM Product 
ORDER BY ProductName;


/* SORTING WITH MULTIPLE COLUMNS
---------------------------------

- When you use ORDER BY with multiple columns, SQL sorts in this sequence:
- First, it sorts by the first column.
- If there are ties (same values) in the first column, it looks at the second column.
- If there are still ties, it looks at the third column, and so on…
- If all columns are the same, the row order is arbitrary (unless you add something else to break ties).
*/

-- Multi column sorting
SELECT * FROM Product
ORDER BY CategoryId ASC, ProductId DESC, Price ASC;
