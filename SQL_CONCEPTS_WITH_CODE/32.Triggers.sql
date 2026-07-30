/* What is a Trigger in MySQL?
------------------------------

A trigger is a special kind of stored logic in a database that automatically runs (fires) 
when a certain event happens on a table. You don’t call it manually — it just runs on its 
own when triggered by:
- INSERT
- UPDATE
- DELETE

Think of a trigger like:
“Whenever someone adds a new row to the orders table, send an alert or log that change in another table.”

To run a MySQL trigger, the user must have admin/superuser privileges.

As per the SQL standard, triggers are usually divided into two categories −

Row-level Trigger: 
Triggers that are only executed when each row is either inserted, updated or deleted in a 
database table. MySQL only supports these type of triggers.

Statement-level Trigger: 
Triggers like these are executed on the transaction level, once, no matter how many rows 
are modified in a table. MySQL does not support these trype of triggers.


                                        Another concept to know
                                        -----------------------

In MySQL triggers, the NEW and OLD pseudo-tables give you direct access to the row that 
is being inserted, updated, or deleted.
They are not fixed objects with a predefined list of “properties”—instead, they expose 
the columns of the table the trigger is defined on.
They are only used with triggers

Usage by Trigger Type

Trigger Type     | Accessible Pseudo-Tables | Typical Usage
-----------------|---------------------------|---------------------------------------------------
BEFORE INSERT     | NEW only                 | Set defaults, validate or modify input.
AFTER INSERT      | NEW only                 | Logging, cascading inserts.
BEFORE UPDATE     | OLD, NEW                 | Compare old vs new values, enforce rules.
AFTER UPDATE      | OLD, NEW                 | Audit changes, update related tables.
BEFORE DELETE     | OLD only                 | Archive data, enforce constraints.
AFTER DELETE      | OLD only                 | Log deletions, clean up related data.

THOUGHT PROCESS TO REMEMBER WHEN TO USE WHAT:

INSERT:
- When we insert something => we always keep the track of the new thing being inserted
- hence for both before and after insert, new only is used.

UPDATE:
- while updating, we need to keep track of old value/original value and new value
- hence, we use both old and new here

DELETE:
- We only need to keep track of original value while deleting.
- Hence, only old is used.


 There are 6 different types of triggers in MySQL:   */

USE mydb;

-- This will be our main table to demonstrate all 6 trigger types. 
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(100),
    salary DECIMAL(10,2),
    created_at DATETIME,
    updated_at DATETIME
);

/* (for logging)
We’ll use this to demonstrate AFTER INSERT, AFTER UPDATE, and AFTER DELETE. */
CREATE TABLE employee_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    action VARCHAR(255),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

/* (for archiving before delete)
We’ll use this to demonstrate BEFORE DELETE. */
CREATE TABLE deleted_employees (
    id INT,
    name VARCHAR(100),
    department VARCHAR(100),
    salary DECIMAL(10,2),
    deleted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


/* 1. BEFORE INSERT Trigger
Goal: Automatically set created_at before inserting a new employee. */

DELIMITER //

CREATE TRIGGER trg_before_insert_employees
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    SET NEW.created_at = NOW();
END;
//

DELIMITER ;

/* 2. AFTER INSERT Trigger
   Goal: Log the insert action in employee_log. */

DELIMITER //

CREATE TRIGGER trg_after_insert_employees
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_log (emp_id, action)
    VALUES (NEW.id, CONCAT('Inserted: ', NEW.name));
END;
//

DELIMITER ;

/* 3. BEFORE UPDATE Trigger
   Goal: Update the updated_at column every time the row is updated. */

DELIMITER //

CREATE TRIGGER trg_before_update_employees
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END;
//

DELIMITER ;

/* 4. AFTER UPDATE Trigger
   Goal: Log that an update occurred. */

DELIMITER //

CREATE TRIGGER trg_after_update_employees
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_log (emp_id, action)
    VALUES (NEW.id, CONCAT('Updated: ', NEW.name));
END;
//

DELIMITER ;

/* 5. BEFORE DELETE Trigger
   Goal: Archive the employee data before deletion. */

DELIMITER //

CREATE TRIGGER trg_before_delete_employees
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO deleted_employees (id, name, department, salary)
    VALUES (OLD.id, OLD.name, OLD.department, OLD.salary);
END;
//

DELIMITER ;

/* 6. AFTER DELETE Trigger
   Goal: Log that the employee was deleted. */

DELIMITER //

CREATE TRIGGER trg_after_delete_employees
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_log (emp_id, action)
    VALUES (OLD.id, CONCAT('Deleted: ', OLD.name));
END;
//

DELIMITER ;
