/*
                                What is a Stored Procedure?
                                ---------------------------

- A stored procedure (SP) is basically a set of SQL statements that you can save in the database 
  and run whenever you need. Think of it like a little program inside MySQL.
- Instead of writing the same SQL query again and again, you can put it inside a stored procedure 
  and just call it.

                                Why use Stored Procedures?
                                --------------------------

- Reusability: Write once, use many times.
- Simplicity: Your queries can be complex, but you just call the procedure.
- Security: You can restrict direct access to tables and allow only SPs to modify data.
- Performance: SPs are compiled once and stored, so execution can be faster than sending 
  raw queries repeatedly.

+------------------------+----------------------------+------------------------------+
| Feature                | Stored Procedure (SP)      | User Defined Function (UDF)  |
+------------------------+----------------------------+------------------------------+
| Returns                | Optional (via OUT params)  | Must return a single value   |
| Use in SELECT          | ❌ Not allowed             | ✅ Can be used in SELECT,    |
|                        |                            | WHERE, ORDER BY, etc.       |
| Can modify tables      | ✅ Allowed                 | ❌ Not allowed (except temp  |
|                        |                            | tables in some cases)       |
| Parameters             | IN, OUT, INOUT             | IN only                      |
| Call Syntax            | CALL procedure_name(...)   | SELECT function_name(...)    |
| Purpose                | Perform operations /       | Compute a value / calculation|
|                        | business logic             |                              |
+------------------------+----------------------------+------------------------------+


---------------------------------------------------------------------------------------------------------

                                            TABLE USED:
                                            -----------

                                +----+-----------+--------+--------+
                                | id | salesperson | region | amount |
                                +----+-----------+--------+--------+
                                |  1 | Alice     | East   |    100 |
                                |  2 | Bob       | East   |    200 |
                                |  3 | Alice     | West   |    150 |
                                |  4 | Bob       | West   |    300 |
                                |  5 | Charlie   | East   |     50 |
                                +----+-----------+--------+--------+   */

---------------------------------------------------------------------------------------------------------
-- Stored procedure without any parameters
---------------------------------------------------------------------------------------------------------
DELIMITER //

CREATE PROCEDURE sp_show_all_sales()
BEGIN
    SELECT * FROM WF_SALES;
END //

DELIMITER ;

-- Call it:
CALL sp_show_all_sales();

/* OUTPUT => same table as above */

---------------------------------------------------------------------------------------------------------
-- Stored procedure with IN parameters
---------------------------------------------------------------------------------------------------------
DELIMITER //

CREATE PROCEDURE sp_sales_by_region(
IN region_param VARCHAR(20),
IN amount_param INT
)
BEGIN
    SELECT * 
    FROM WF_SALES
    WHERE region = region_param AND amount = amount_param;
END //

DELIMITER ;

-- Call it:
CALL sp_sales_by_region('East', 200);

/* OUTPUT:
+----+-----------+--------+--------+
| id | salesperson | region | amount |
+----+-----------+--------+--------+
|  2 | Bob       | East   |    200 |
+----+-----------+--------+--------+ */

---------------------------------------------------------------------------------------------------------
-- Stored procedure with OUT parameters

/* How to catch the output => create a session variable using @var_name 
                              DON'T use DECLARE for this purpose 

+------------------------------+------------------------------------------------------------+---------------------------+
| Type of variable            | Scope & lifetime                                           | Can be used as OUT arg?   |
+------------------------------+------------------------------------------------------------+---------------------------+
| Session variable (@x)       | Exists for the entire client session. Accessible anywhere. | ✅ Yes                    |
| Local variable (DECLARE x;) | Exists only inside the BEGIN…END block where declared.     | ❌ No (cannot be passed)  |
+------------------------------+------------------------------------------------------------+---------------------------+

                                    Why use @ with OUT parameters?
                                    -----------------------------

OUT parameters cannot directly return values like SELECT.
Instead, MySQL requires you to supply a variable to hold the value that the procedure sets.
Session variables (prefixed with @) are perfect for this because:
  - They don’t need to be declared beforehand.
  - These @ variables don’t need DECLARE; they’re created on the fly.
  - They persist until the session ends.
  - They can be accessed immediately after the procedure finishes.


Ex: 
CALL get_max_amount(@max_value);
SELECT @max_value;   -- Retrieve the value


🔹 What happens:

- @max_value is a session variable.
- The procedure sets max_amt (the OUT parameter) to the max amount
- MySQL copies that value into @max_value.
- We can then read it with a SELECT.

*/
---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE sp_total_salesperson(
    IN p_salesperson VARCHAR(20),
    OUT p_total INT
)
BEGIN
    SELECT SUM(amount)
    INTO p_total           -- store the sum into p_total
    FROM WF_SALES
    WHERE salesperson = p_salesperson;
END //

DELIMITER ;

-- Call it and read the OUT value:
CALL sp_total_salesperson('Alice', @total);
SELECT @total AS Alice_Total;

/*OUTPUT:

# Alice_Total
--------------
  250
*/

/* We can output multiple values also */
USE mydb;

CREATE TABLE sales (
    id INT,
    amount INT
);

INSERT INTO sales VALUES
(1, 100),
(2, 200),
(3, 150);

DELIMITER //

CREATE PROCEDURE sales_summary(
    OUT total_sales INT,
    OUT max_sale   INT,
    OUT avg_sale   DECIMAL(10,2)
)
BEGIN
    SELECT SUM(amount), MAX(amount), AVG(amount)
    INTO total_sales, max_sale, avg_sale
    FROM sales;
END //

DELIMITER ;

CALL sales_summary(@tot, @max, @avg);
SELECT @tot AS total_sales, @max AS max_sale, @avg AS avg_sale;

/* OUTPUT:

# total_sales	  max_sale	  avg_sale
------------------------------------
    450	          200	      150.00 */

---------------------------------------------------------------------------------------------------------
-- Stored procedure with INOUT parameters

/* OUT vs INOUT:
---------------

OUT: Used to return a value from the procedure to the caller. The caller cannot pass an input value for it.
use case: Returning calculated results (e.g., a sum, a count, a status code).


INOUT: Used to pass a value into the procedure and return an updated value back to the caller.
use case: Updating or transforming a value based on the logic inside the procedure 
          (e.g., incrementing a counter, adjusting a date).


*/
---------------------------------------------------------------------------------------------------------

DELIMITER //

CREATE PROCEDURE demo_out(IN a INT, OUT b INT)
BEGIN
    SET b = a * 2;
END //

CREATE PROCEDURE demo_inout(INOUT x INT)
BEGIN
    SET x = x * 2;
END //

DELIMITER ;

-- Usage:
CALL demo_out(5, @out_val);
SELECT @out_val;         -- returns 10

SET @num = 5;
CALL demo_inout(@num);
SELECT @num;             -- returns 10


