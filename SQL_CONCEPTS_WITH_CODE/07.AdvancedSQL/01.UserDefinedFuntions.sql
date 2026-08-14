/*
============================================================================================
USER-DEFINED FUNCTION (UDF) → A function you create when built-in functions are not enough.
============================================================================================

INPUT → LOGIC → SINGLE RETURN VALUE

Key points:
→ Takes parameter(s)
→ Must return ONE value
→ Use RETURN
→ DELIMITER is used while creating the function
→ CREATE ROUTINE privilege may be required

===========================================================
1. BASIC UDF
===========================================================

DELIMITER //

CREATE FUNCTION addNumber(a INT, b INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN a + b;
END //

DELIMITER ;

                                                -----
                                                NOTE
                                                -----

MySQL normally uses `;` to identify the end of a SQL statement.
But a function contains multiple `;` statements:

    BEGIN
        RETURN a + b;
    END

MySQL may treat the `;` after RETURN as the end of the CREATE FUNCTION statement.
Solution → temporarily change the delimiter to //
DELIMITER --> Switch back to normal ;


SELECT addNumber(4, 5);

Output:

    +----------------+
    | addNumber(4,5) |
    +----------------+
    | 9              |
    +----------------+

===========================================================
2. DETERMINISTIC
===========================================================

DETERMINISTIC
→ Same input → same output.

Example:

addNumber(4,5) → 9
addNumber(4,5) → 9


NOT DETERMINISTIC
→ Same input may produce different output.

Example:
→ RAND()
→ NOW()


===========================================================
3. SQL DATA CHARACTERISTICS
===========================================================

NO SQL
→ Function does not read/modify database data.

READS SQL DATA
→ Function reads database data but does not modify it.

MODIFIES SQL DATA
→ Function modifies database data.

===========================================================
4. UDF WITH VARIABLE
===========================================================

DELIMITER //

CREATE FUNCTION no_of_years(date1 DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE date2 DATE;

    SET date2 = CURRENT_DATE();

    RETURN YEAR(date2) - YEAR(date1);
END //

DELIMITER ;

SELECT no_of_years('2001-06-22');

Example output:
    +-----------------------------+
    | no_of_years('2001-06-22')   |
    +-----------------------------+
    | 25                          |
    +-----------------------------+

===========================================================
5. UDF USING TABLE DATA
===========================================================

CREATE FUNCTION creates a stored function in the database; 
it can be defined inside the same .sql script used to create/test your database objects.

CREATE TABLE FUNC_TABLE (
    emp_id INT PRIMARY KEY,
    fname VARCHAR(50),
    lname VARCHAR(50),
    start_date DATE
);


INSERT INTO FUNC_TABLE VALUES
(1, 'Michael', 'Smith', '2001-06-22'),
(2, 'Susan', 'Barker', '2002-09-12'),
(3, 'Robert', 'Tvler', '2000-02-09'),
(4, 'Susan', 'Hawthorne', '2002-04-24');


Example usage:

SELECT emp_id, fname, lname,
       no_of_years(start_date) AS years
FROM FUNC_TABLE;

The function is executed for each row's start_date.
