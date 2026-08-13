/*
===========================================================
INDEX → Helps DB find rows faster.
===========================================================

NO INDEX  → possible FULL TABLE SCAN
INDEX     → lookup through index structure

Common:
→ B-Tree
→ Hash (DB/engine dependent)

===========================================================
1. AUTOMATIC INDEXES
===========================================================

PRIMARY KEY
→ UNIQUE index automatically created.

UNIQUE
→ UNIQUE index automatically created.

FOREIGN KEY
→ In MySQL/InnoDB, suitable index is required and may be
  created automatically if missing.

===========================================================
2. BASIC INDEX — WITH vs WITHOUT INDEX
===========================================================

Consider:

  +--------+----------+--------+------------+
  | UserID | UserName | Sex    | RollNumber |
  +--------+----------+--------+------------+
  | 1      | John     | Male   | 11         |
  | 2      | Emma     | Female | 122        |
  | 3      | Ravi     | Other  | 13         |
  | 4      | Raj      | Female | 14         |
  | 5      | Yash     | Male   | 97         |
  | 6      | Komal    | Female | 167        |
  +--------+----------+--------+------------+


WITHOUT INDEX:

  SELECT UserName FROM Users WHERE RollNumber = 14;

  Possible execution:

  Row 1 → RollNumber = 11?  ❌
  Row 2 → RollNumber = 122? ❌
  Row 3 → RollNumber = 13?  ❌
  Row 4 → RollNumber = 14?  ✅
  ...

  → FULL TABLE SCAN
  → Roughly O(n)


WITH INDEX:

  CREATE INDEX idx_roll ON Users(RollNumber);

Conceptually some lookup data structure like the below one is created - not in reality though

INDEX: idx_roll

RollNumber       → row reference
---------------------------------
11               → row 1
13               → row 3
14               → row 4
97               → row 5
122              → row 2
167              → row 6

SELECT UserName FROM Users WHERE RollNumber = 14;

Execution:

  Query
    ↓
  Index
    ↓
  Find 14
    ↓
  Locate row
    ↓
  Fetch UserName
    ↓
  Raj

Output:

+----------+
| UserName |
+----------+
| Raj      |
+----------+

IMPORTANT:

→ The index is a separate lookup structure.
→ It does NOT replace the table.
→ B-Tree is commonly used in MySQL/InnoDB.
→ The actual execution plan is decided by the optimizer.

===========================================================
3. VIEW INDEXES
===========================================================

SHOW INDEXES FROM Users;

Example:

+-------+------------+----------+-------------+
| Table | Non_unique | Key_name | Column_name |
+-------+------------+----------+-------------+
| Users | 0          | PRIMARY  | UserID      |
| Users | 1          | idx_roll | RollNumber  |
+-------+------------+----------+-------------+

Non_unique:
0 → UNIQUE
1 → Non-unique

===========================================================
4. SINGLE-COLUMN INDEX
===========================================================

CREATE INDEX idx_sex ON Users(Sex);

Useful for queries such as:

SELECT * FROM Users WHERE Sex = 'Female';

===========================================================
5. COMPOSITE INDEX
===========================================================

CREATE INDEX idx_name_roll ON Users(UserName, RollNumber);

COLUMN ORDER MATTERS.

INDEX(UserName, RollNumber)

→ UserName              ✓
→ UserName + RollNumber ✓
→ RollNumber alone      ✗ generally not effective

===========================================================
6. UNIQUE INDEX
===========================================================

CREATE UNIQUE INDEX idx_roll ON Users(RollNumber);

If existing data contains duplicates:

  +------------+
  | RollNumber |
  +------------+
  | 97         |
  | 97         |
  +------------+

→ CREATE UNIQUE INDEX fails.
→ Existing non-NULL values must already be unique.

After successfully creating the UNIQUE INDEX:

INSERT INTO Users(...) 
VALUES (..., 97);                    → Fails because 97 already exists.

INSERT INTO Users(...)
VALUES (..., 100);                   → Succeeds.


IMPORTANT:
→ UNIQUE INDEX prevents duplicate non-NULL values.
→ In MySQL, multiple NULL values are allowed.

===========================================================
7. DROP INDEX
===========================================================

DROP INDEX idx_roll ON Users;

→ Removes index.
→ Does NOT remove table/data.

===========================================================
8. INDEX TRADE-OFF
===========================================================

READS   → usually faster
WRITES  → usually slower
STORAGE → increases

INSERT / UPDATE / DELETE
        ↓
Table changes
        ↓
Index also maintained

Therefore:
→ Don't index every column.
→ Prefer frequently used WHERE / JOIN / ORDER BY columns.

===========================================================
9. INDEX FRAGMENTATION / REBUILD
===========================================================

- Initially, the index is usually nicely organised.
- Now rows are deleted/inserted/updated with time
- The database has to modify the index too.
- Over time, index pages can become less efficiently organized BUT The index is still correct
- But the physical organization may require more page access / I/O than an efficiently packed structure.

SOLUTION:

  REBUILD = physically reorganizing an existing index so its internal storage 
            structure is recreated/optimized.

            It does not change what data the table logically contains.

===========================================================
10. EXPLAIN
===========================================================

EXPLAIN
→ Shows the query execution plan.

Example: EXPLAIN SELECT * FROM Users WHERE RollNumber = 14;

Use it to check:
→ Whether an index is being considered/used
→ How DB plans to access the data
