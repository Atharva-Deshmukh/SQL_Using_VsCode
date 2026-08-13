/*
===========================================================
UNION vs UNION ALL
===========================================================

UNION
→ Combines SELECT results + removes duplicate rows.

UNION ALL
→ Combines SELECT results + keeps duplicates.

REQUIREMENTS:
→ Same number of columns
→ Compatible data types
→ Same column order

===========================================================
1. UNION
===========================================================

SELECT City FROM Customers
UNION
SELECT City FROM Suppliers;

OUTPUT:

+---------------+
| City          |
+---------------+
| Berlin        |
| México D.F.   |
| London        |
| New Orleans   |
| Ann Arbor     |
+---------------+

México D.F. appears once → duplicate removed.

-----------------------------------------------------------
COLUMN NAMES
-----------------------------------------------------------

Result column names come from the FIRST SELECT.

SELECT CustomerID, CustomerName FROM Customers
UNION
SELECT SupplierID, SupplierName FROM Suppliers;

OUTPUT:

+------------+----------------------------------+
| CustomerID | CustomerName                     |
+------------+----------------------------------+
| 1          | Alfreds Futterkiste              |
| 2          | Ana Trujillo Emparedados y helados|
| 3          | Antonio Moreno Taquería          |
| 1          | Exotic Liquid                    |
| 2          | New Orleans Cajun Delights       |
| 3          | Grandma Kelly's Homestead        |
+------------+----------------------------------+

→ Names "CustomerID" and "CustomerName" come from first SELECT.

===========================================================
2. UNION + WHERE
===========================================================

SELECT City, Country
FROM Customers
WHERE Country IN ('USA', 'Germany')

UNION

SELECT City, Country
FROM Suppliers
WHERE Country IN ('USA', 'Germany');

OUTPUT:

+-------------+---------+
| City        | Country |
+-------------+---------+
| Berlin      | Germany |
| New Orleans | USA     |
| Ann Arbor   | USA     |
+-------------+---------+

===========================================================
3. CUSTOM COLUMN WITH UNION
===========================================================

SELECT 'Customer' AS Type, ContactName, City, Country
FROM Customers

UNION

SELECT 'Supplier', ContactName, City, Country
FROM Suppliers;

OUTPUT:

+----------+------------------+-------------+---------+
| Type     | ContactName      | City        | Country |
+----------+------------------+-------------+---------+
| Customer | Maria Anders     | Berlin      | Germany |
| Customer | Ana Trujillo     | México D.F. | Mexico  |
| Customer | Antonio Moreno   | México D.F. | Mexico  |
| Supplier | Charlotte Cooper | London      | UK      |
| Supplier | Shelley Burke    | New Orleans | USA     |
| Supplier | Regina Murphy    | Ann Arbor   | USA     |
+----------+------------------+-------------+---------+

→ 'Customer' / 'Supplier' are added as output values.
→ Column name "Type" comes from first SELECT.

===========================================================
4. UNION ALL
===========================================================

SELECT Country FROM Customers
UNION ALL
SELECT Country FROM Suppliers;

OUTPUT:

+---------+
| Country |
+---------+
| Germany |
| Mexico  |
| Mexico  |
| UK      |
| USA     |
| USA     |
+---------+

→ Duplicates are KEPT.

===========================================================
UNION vs UNION ALL
===========================================================

+----------------+-----------------------------+----------------------+
|                | UNION                       | UNION ALL            |
+----------------+-----------------------------+----------------------+
| Combines rows  | YES                         | YES                  |
| Removes dupes  | YES                         | NO                   |
| Typical cost   | Higher (duplicate removal)  | Lower                |
+----------------+-----------------------------+----------------------+
