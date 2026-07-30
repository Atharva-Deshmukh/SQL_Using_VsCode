/* 
A User Defined Function (UDF) is one that you create yourself when built-in functions are not enough.

A function:

- Takes input(s) (parameters)
- Does something (logic inside function)
- Returns a single value

                                                Key Points to Remember
                                                ---------------------

- Always use RETURN inside the function (must return 1 value).
- Use DELIMITER // … DELIMITER ; when creating (so MySQL doesn’t get confused by ; inside).
- You need CREATE ROUTINE privilege to create a function.

                                                SIMPLE Syntax:
                                                ---------------

CREATE FUNCTION function_name(parameter datatype, ...)
RETURNS datatype
DETERMINISTIC
BEGIN
   -- some SQL statements
   RETURN some_value;
END */

-- Declaring and defining the function

DELIMITER //
CREATE FUNCTION addNumber(a INT, b INT) 
RETURNS INT
DETERMINISTIC
BEGIN
	RETURN a + b;
END 
//
DELIMITER ;

-- Calling the function
SELECT addNumber(4, 5);  -- OUTPUT: 9

-- The User defined functions are visible in database >> Functions in the left panel

/* Lets take some real life use case:

                                    TABLE USED:
                                    -----------


                        emp_id | fname   | lname      | start_date
                        -------+---------+------------+------------
                        1      | Michael | Smith      | 2001-06-22
                        2      | Susan   | Barker     | 2002-09-12
                        3      | Robert  | Tvler      | 2000-02-09
                        4      | Susan   | Hawthorne  | 2002-04-24


*/

USE mydb;

CREATE TABLE FUNC_TABLE (
    emp_id INT PRIMARY KEY,
    fname VARCHAR(50),
    lname VARCHAR(50),
    start_date DATE
);

INSERT INTO FUNC_TABLE (emp_id, fname, lname, start_date) VALUES
(1, 'Michael', 'Smith', '2001-06-22'),
(2, 'Susan', 'Barker', '2002-09-12'),
(3, 'Robert', 'Tvler', '2000-02-09'),
(4, 'Susan', 'Hawthorne', '2002-04-24');


DELIMITER //

CREATE FUNCTION no_of_years(date1 DATE) 
RETURNS INT
NOT DETERMINISTIC
NO SQL
BEGIN
   DECLARE today DATE; -- declaring variables just like other programming languages
   DECLARE AD_RANDOM_VARIABLE INT(2);
   
   SET AD_RANDOM_VARIABLE = FLOOR(RAND() * (10-5) + 5);  -- Return a random decimal number [5, 10)
   SET today = CURRENT_DATE();   -- get today’s date (Initialising the declared variable)
   RETURN YEAR(today) - YEAR(date1) + AD_RANDOM_VARIABLE;
END //

DELIMITER ;

SELECT emp_id, fname, lname, no_of_years(start_date) AS years
FROM FUNC_TABLE;

/* 
                                    What is DELIMITER and //?
                                    -------------------------

In MySQL, by default, every SQL statement ends with ;

But when you create a function or procedure, the body itself contains ;

Ex:

BEGIN
   RETURN a + b;
END


Here we have multiple ; — MySQL will get confused and think the function ended early.

👉 Solution: Change the "end of statement" marker temporarily using DELIMITER.

                            DELIMITER //

                            CREATE FUNCTION add_numbers(a INT, b INT)
                            RETURNS INT
                            DETERMINISTIC
                            BEGIN
                            RETURN a + b;
                            END //

                            DELIMITER ;


Here:

We told MySQL: "Don’t treat ; as the end of the statement, treat // as the end."
That’s why after END //, MySQL knows the function is finished.

Then we switch back with DELIMITER ;.

✅ You can use anything other than //, like $$, !!, ###, etc.

Ex:

                                    DELIMITER $$

                                    CREATE FUNCTION square_num(n INT)
                                    RETURNS INT
                                    DETERMINISTIC
                                    BEGIN
                                    RETURN n * n;
                                    END $$

                                    DELIMITER ;


                        USES OF VARIOUS KEYWORDS INSIDE UDF:
                        ------------------------------------

These are characteristics you must specify when creating a function.

🔹 DETERMINISTIC -> For the same input, the function always gives the same output.
    Ex: add_numbers(10, 20) will always return 30.
    Opposite is NOT DETERMINISTIC, e.g., if function uses RAND() or NOW(), results change each time.

🔹 NO SQL -> The function does not read or modify any database tables.

    Ex: add_numbers(a, b) just does math, doesn’t touch tables → NO SQL.

🔹 READS SQL DATA -> The function reads data from tables, but doesn’t change them.

    Ex: Your no_of_years(start_date) function reads CURRENT_DATE() (system value) or could read 
    from a table, but it doesn’t insert/update/delete anything.

👉 Other related ones:

    MODIFIES SQL DATA → If it changes data (not allowed in functions, only in procedures).

    CONTAINS SQL → If it has SQL statements but doesn’t read/write data. */

-- Another example of UDF

DELIMITER //

CREATE FUNCTION no_of_years(date1 date) RETURNS int DETERMINISTIC
BEGIN
 DECLARE date2 DATE;
  Select current_date()into date2;
  RETURN year(date2)-year(date1);
END 

//

DELIMITER ;