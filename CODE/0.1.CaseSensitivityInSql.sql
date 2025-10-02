/* Case sensitivity depends on: Operating System

MySQL setting lower_case_table_names

🔹 On Windows:

File system is case-insensitive
Table names are not case-sensitive by default

Example:

SELECT * FROM Employees;
SELECT * FROM employees;


✅ Both will work the same

🔹 On Linux:

File system is case-sensitive
Table names are case-sensitive by default

Example:

SELECT * FROM Employees; -- ❌ Might fail
SELECT * FROM employees; -- ✅ Only works if table name is lowercase


⚠️ Column names and aliases are always case-insensitive on all OSes.

Case sensitivity in data comparisons (like WHERE name = 'Alice') is controlled by collation — not OS.

                                        What is Collation in MySQL?
                                        --------------------------

A collation in MySQL defines:

How text is compared
Sorting rules
Case sensitivity
 
💡 Collation = Character set + Rules

Example: utf8_general_ci

utf8 → Character set
general → Language-specific rules
ci → Case-insensitive

| Suffix | Meaning          | Case-Sensitive? |
|--------|------------------|-----------------|
| `_ci`  | Case-insensitive | ❌ No           |
| `_cs`  | Case-sensitive   | ✅ Yes          |
| `_bin` | Binary (strict)  | ✅ Yes          |

-- How to Check Collation of a Table Column:
SHOW FULL COLUMNS FROM emp;

/*  OUTPUT:

#   Field	    Type	        Collation	
---------------------------------------------
    emp_no	    int		        null
    name	    varchar(50)	    utf8mb4_0900_ai_ci
    sal	        decimal(10,2)	null	
    age	        int		        null

How to Set Collation for a Column:
ALTER TABLE your_table
MODIFY name VARCHAR(100) COLLATE utf8_general_cs;

CREATE TABLE test_cs (
  name VARCHAR(50) COLLATE utf8_general_cs
);

SELECT * FROM test_cs WHERE name = 'alice';  -- Only matches exact case "alice"

CREATE TABLE test (
  name VARCHAR(50) COLLATE utf8_general_ci
);

SELECT * FROM test WHERE name = 'alice';  -- Matches "Alice", "ALICE", etc.

*/