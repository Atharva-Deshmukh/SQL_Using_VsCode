/**********************************************************************
                    Case Sensitivity in MySQL
**********************************************************************

Case sensitivity depends on:
1. Operating System
2. MySQL setting
3. Collation (for text comparisons)

----------------------------------------------------------------------
Table Names
----------------------------------------------------------------------

Windows --> Case-insensitive

SELECT * FROM Employees;
SELECT * FROM employees;                          ✔ Both work

Linux --> Case-sensitive (default)

SELECT * FROM Employees;   -- May fail
SELECT * FROM employees;   -- Works if table name is lowercase

Note:
- Column names and aliases are always case-insensitive.

----------------------------------------------------------------------
Collation
----------------------------------------------------------------------

- A set of rules that determines how text is compared and sorted.
- The query doesn't specify the collation because the collation is already attached 
  to the column (or database/table), not to the query.

CREATE TABLE emp (
    name VARCHAR(50) COLLATE utf8_general_ci
);

Here, the name column has the collation utf8_general_ci.

When we now run --> SELECT * FROM emp WHERE name = 'alice';

Alice  == alice   ✓
ALICE  == alice   ✓
alice  == alice   ✓
Bob    == alice   ✗

Format:
  <Character Set>_<Rules>_<Suffix>

Example:
  utf8_general_ci

  utf8     → Character set
  general  → Comparison rules
  ci       → Case-insensitive

Common Suffixes:

  _ci   → Case-insensitive
  _cs   → Case-sensitive
  _bin  → Binary (strict)

**********************************************************************/