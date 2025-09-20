/* 
Indexes in SQL
---------------
An index in SQL is like an index in a book.

Imagine you have a huge book (your database table).
If you want to find the word "apple", without an index you’d have to read every page
this is called a full table scan (slow).
If the book has an index at the back, you jump directly to the right page
that’s what a database index does (fast lookup).

Data structures used: B-Tree, Hash

Indexes help the engine to search rows faster for Filter and join like operations.

Automatically indexed:
----------------------

- PRIMARY KEY → unique index
- UNIQUE KEY → unique index
- FOREIGN KEY → index (if not exists)
- AUTO_INCREMENT → needs index

Not automatically indexed:
--------------------------

- Normal columns
- CHECK, DEFAULT, NOT NULL


WORKING OF INDEXES:
-------------------

                                            Case 1: Without Index

Query => SELECT UserName FROM Users WHERE RollNumber = 14;


👉 MySQL will do a full table scan:

Start from the first row.
Check each row’s RollNumber.
If matches = return it.
Keep going (because there could be multiple rows with RollNumber = 14).

⚡ Complexity: O(n) → time grows with table size.

                                            Case 2: With Index

Query => CREATE INDEX idx_rollnumber ON Users(RollNumber);

Now the table has a separate index structure (usually a B-Tree).

👉 When you run:

SELECT UserName FROM Users WHERE RollNumber = 14;


SQL engine does not jump magically to the row.
Instead, it goes into the index (tree) → which is sorted by RollNumber.
It navigates the tree quickly (like a binary search) until it finds 14.
Once found, it uses a pointer from the index to fetch the actual row in the table.

⚡ Complexity: O(log n) → very fast, even with millions of rows.


Note: Updating a table with indexes takes more time than updating a table without 
(because the indexes also need an update). So, only create indexes on columns that will be 
frequently searched against.


Trade-offs of Indexes
----------------------

- Indexes are not “free.”
- They speed up reads but make writes (INSERT/UPDATE/DELETE) slower, because MySQL has to also 
   update the index.
- They take extra storage space.
- That’s why enterprises carefully decide which columns need indexes 
  (typically those used in WHERE, JOIN, ORDER BY a lot).


                                      CONSIDER THIS TABLE
                                      -------------------

                            +--------+---------+--------+------------+
                            | UserID | UserName| Sex    | RollNumber |
                            +--------+---------+--------+------------+
                            |      1 | John    | Male   |         11 |
                            |      2 | Emma    | Female |        122 |
                            |      3 | Ravi    | Other  |         13 |
                            |      4 | Raj     | Female |         14 |
                            |      5 | Yash    | Male   |         97 |
                            |      6 | Komal   | Female |        167 |
                            +--------+---------+--------+------------+ */

/* To get all the indexes */
SHOW INDEXES FROM LARGE_USERS;  -- FROM <table_name>

/* OUTPUT:
#   Table	        Non_unique	    Key_name	Seq_in_index	Column_name		Index_type	
    large_users	        0	        PRIMARY	        1	            UserID	     BTREE */


/* Create an index on Single column */
CREATE INDEX SEX_INDEX ON large_users(Sex);
SHOW INDEXES FROM LARGE_USERS;

/* OUTPUT:

--                 unique hai ya nahi
/* OUTPUT:
#   Table	        Non_unique	    Key_name	Seq_in_index	Column_name		Index_type	
    large_users	        0	        PRIMARY	        1	            UserID	     BTREE 
    large_users	        1	        SEX_INDEX	     1	             Sex	     BTREE */

/* Similarly multi-column index can be created */
CREATE INDEX idx_name_roll ON large_users (UserName, RollNumber);

/* UNIQUE INDEXES */

-- Error is throwsn if duplicate values are found while creating a unique index.
-- Similary, while inserting duplicate values in a column with unique index, error will be thrown.
CREATE UNIQUE INDEX RollIndex ON LARGE_USERS(RollNumber);
-- Error: Error Code: 1062. Duplicate entry '97' for key 'large_users.RollIndex'

/* Dropping/Removing an index */
DROP INDEX RollIndex ON LARGE_USERS;

/* Rebuilding an index 
-----------------------

Over time, as data is inserted, updated, or deleted, indexes can become fragmented (scattered across disk pages).

A table (and its indexes) are stored on disk pages (blocks of fixed size, e.g., 16KB in InnoDB).
When you insert rows in order, the index pages stay nicely packed.
But when you delete, update, or insert values in the middle of existing ranges, MySQL may:
Leave empty space (from deleted rows).
Split index pages (like splitting a phone book page into two).
Scatter related entries across multiple disk pages.
This is called index fragmentation (or page fragmentation).

Impact on the index

The index itself is still valid and works correctly
But Queries may need to read more disk pages to traverse the B-Tree index.
Disk I/O increases, cache efficiency drops.
So lookups become slower, especially on large tables.

After rebuilding the index

The B-Tree is reorganized into tightly packed, ordered pages.
Fewer disk pages to scan → faster lookups, less I/O.
But again: no changes to your actual data, just the physical layout of index pages.

Analogy:
Think of the index as a phone book.

Fragmented = names are correct but scattered across random, half-empty pages → you still find the 
             person, but you flip more pages.
Rebuilt = names are re-copied into clean, continuous pages → fewer flips, faster search. */

ALTER TABLE LARGE_USERS ENGINE=InnoDB; -- Rebuilds the table and its indexes in MySQL

/* InnoDB is the default storage engine in MySQL (since MySQL 5.5).

Why ALTER TABLE TableName ENGINE=InnoDB; is used?

Running this command rebuilds the entire table + indexes.

Effectively, it:

Creates a temporary copy of the table in InnoDB.
Drops the old table.
Swaps the new one in place.
Result → table and indexes are defragmented & optimized. */
