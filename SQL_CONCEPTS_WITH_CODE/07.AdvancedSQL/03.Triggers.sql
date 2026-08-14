/*
======================================================================================
TRIGGERS → Stored logic that automatically executes when an event occurs on a table.
======================================================================================

Events:
→ INSERT
→ UPDATE
→ DELETE

You do NOT call a trigger manually.

===========================================================
MYSQL TRIGGER TYPES
===========================================================

                INSERT      UPDATE      DELETE

BEFORE          NEW         OLD+NEW     OLD

AFTER           NEW         OLD+NEW     OLD


MySQL:
→ Supports ROW-LEVEL triggers
→ Does NOT support STATEMENT-LEVEL triggers


===========================================================
NEW vs OLD
===========================================================

NEW
→ New row value

OLD
→ Existing/original row value


===========================================================
1. BEFORE INSERT
===========================================================

Runs before a row is inserted.

Use:
→ Set/modify values
→ Validate input


Example:

DELIMITER //

CREATE TRIGGER trg_before_insert_employees
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    SET NEW.created_at = NOW();
END //

DELIMITER ;


INSERT
   ↓
BEFORE INSERT
   ↓
NEW.created_at = NOW()
   ↓
Row inserted


===========================================================
2. AFTER INSERT
===========================================================

Runs after a row is inserted.

Use:
→ Logging
→ Related actions


DELIMITER //

CREATE TRIGGER trg_after_insert_employees
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_log (emp_id, action)
    VALUES (NEW.id, CONCAT('Inserted: ', NEW.name));
END //

DELIMITER ;


===========================================================
3. BEFORE UPDATE
===========================================================

Runs before a row is updated.

Use:
→ Modify/validate new values


DELIMITER //

CREATE TRIGGER trg_before_update_employees
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END //

DELIMITER ;


Here:

OLD → existing row
NEW → updated row


===========================================================
4. AFTER UPDATE
===========================================================

Runs after a row is updated.

Use:
→ Audit/log changes


DELIMITER //

CREATE TRIGGER trg_after_update_employees
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_log (emp_id, action)
    VALUES (NEW.id, CONCAT('Updated: ', NEW.name));
END //

DELIMITER ;


===========================================================
5. BEFORE DELETE
===========================================================

Runs before a row is deleted.

Use:
→ Archive data
→ Perform validation/action before deletion


DELIMITER //

CREATE TRIGGER trg_before_delete_employees
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO deleted_employees
        (id, name, department, salary)
    VALUES
        (OLD.id, OLD.name, OLD.department, OLD.salary);
END //

DELIMITER ;


DELETE
   ↓
BEFORE DELETE
   ↓
Copy OLD row to archive
   ↓
Row deleted


===========================================================
6. AFTER DELETE
===========================================================

Runs after a row is deleted.

Use:
→ Logging
→ Cleanup/related actions


DELIMITER //

CREATE TRIGGER trg_after_delete_employees
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_log (emp_id, action)
    VALUES (OLD.id, CONCAT('Deleted: ', OLD.name));
END //

DELIMITER ;


===========================================================
QUICK REVISION TABLE
===========================================================

+---------------+------------+------------------------+
| Trigger       | Values     | Common Use             |
+---------------+------------+------------------------+
| BEFORE INSERT | NEW        | Set/validate values    |
| AFTER INSERT  | NEW        | Logging                |
| BEFORE UPDATE | OLD + NEW  | Validate/modify        |
| AFTER UPDATE  | OLD + NEW  | Audit/logging          |
| BEFORE DELETE | OLD        | Archive/validate       |
| AFTER DELETE  | OLD        | Logging/cleanup        |
+---------------+------------+------------------------+
*/