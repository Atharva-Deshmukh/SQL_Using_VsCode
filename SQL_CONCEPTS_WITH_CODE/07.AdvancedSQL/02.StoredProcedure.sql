/*
===========================================================
STORED PROCEDURE
===========================================================

Stored Procedure (SP)
→ Set of SQL statements stored in the database.
→ Execute it using CALL.
→ Used to perform operations / business logic.

Why use?
→ Reusable SQL
→ Encapsulates complex logic
→ Can control access to underlying tables

===========================================================
SP vs UDF
===========================================================

+-------------------+----------------------+-----------------------+
| Feature           | Stored Procedure      | UDF                  |
+-------------------+----------------------+-----------------------+
| Return            | Optional              | Must return 1 value  |
| SELECT usage      | ❌ No                 | ✅ Yes               |
| Modify tables     | ✅ Yes                | ❌ Generally no      |
| Parameters        | IN, OUT, INOUT        | IN                   |
| Call              | CALL procedure(...)   | SELECT function(...) |
| Main purpose      | Perform operations    | Compute a value      |
+-------------------+----------------------+----------------------+

===========================================================
1. PROCEDURE WITHOUT PARAMETERS
===========================================================

DELIMITER //

CREATE PROCEDURE sp_show_all_sales()
BEGIN
    SELECT * FROM WF_SALES;
END //

DELIMITER ;

/* Call */

CALL sp_show_all_sales();


===========================================================
2. IN PARAMETER
===========================================================

IN
→ Passes a value INTO the procedure.

DELIMITER //

CREATE PROCEDURE sp_sales_by_region(
    IN region_param VARCHAR(20),
    IN amount_param INT
)
BEGIN
    SELECT *
    FROM WF_SALES
    WHERE region = region_param
      AND amount = amount_param;
END //

DELIMITER ;


Call:

CALL sp_sales_by_region('East', 200);


Output:

+----+-------------+--------+--------+
| id | salesperson | region | amount |
+----+-------------+--------+--------+
|  2 | Bob         | East   |    200 |
+----+-------------+--------+--------+

===========================================================
3. OUT PARAMETER
===========================================================

OUT
→ Procedure calculates a value and returns it to the caller.

Example:

DELIMITER //

CREATE PROCEDURE sp_total_salesperson(
    IN p_salesperson VARCHAR(20),
    OUT p_total INT
)
BEGIN
    SELECT SUM(amount)
    INTO p_total
    FROM WF_SALES
    WHERE salesperson = p_salesperson;
END //

DELIMITER ;


Call:

CALL sp_total_salesperson('Alice', @total);

SELECT @total AS Alice_Total;


Output:

+-------------+
| Alice_Total |
+-------------+
|     250     |
+-------------+


IMPORTANT:
    OUT value is captured using a SESSION VARIABLE: @total

===========================================================
4. MULTIPLE OUT PARAMETERS
===========================================================

A procedure can have multiple OUT parameters.

DELIMITER //

CREATE PROCEDURE sales_summary(
    OUT total_sales INT,
    OUT max_sale INT,
    OUT avg_sale DECIMAL(10,2)
)
BEGIN
    SELECT SUM(amount), MAX(amount), AVG(amount)
    INTO total_sales, max_sale, avg_sale
    FROM sales;
END //

DELIMITER ;


Call:

CALL sales_summary(@tot, @max, @avg);

SELECT
    @tot AS total_sales,
    @max AS max_sale,
    @avg AS avg_sale;


Output:

+-------------+----------+----------+
| total_sales | max_sale | avg_sale |
+-------------+----------+----------+
|     450     |   200    |  150.00  |
+-------------+----------+----------+


===========================================================
5. INOUT PARAMETER
===========================================================

INOUT
→ Pass value INTO procedure
→ Procedure modifies it
→ Modified value comes back OUT


Example:

DELIMITER //

CREATE PROCEDURE demo_inout(INOUT x INT)
BEGIN
    SET x = x * 2;
END //

DELIMITER ;


SET @num = 5;

CALL demo_inout(@num);

SELECT @num;


Output:

10


===========================================================
IN vs OUT vs INOUT
===========================================================

IN
→ Input only

OUT
→ Output only

INOUT
→ Input + Output
*/