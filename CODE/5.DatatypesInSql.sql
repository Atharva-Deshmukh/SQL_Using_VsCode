CREATE TABLE IF NOT EXISTS Persons (
    PersonID INT(12) NOT NULL,        -- Numeric
    FirstName VARCHAR(255),           -- String
    LastName VARCHAR(255),            -- String
    Address VARCHAR(255),             -- String
    City VARCHAR(255),                -- String

    -- Numeric Data Types
    Age TINYINT(3),                   -- -128 to 127 (signed), small numbers
    Salary DECIMAL(10,2),             -- Fixed-point with precision
    Score FLOAT(7,3),                 -- Approx floating-point
    BigNumber BIGINT(20),             -- Large integers

    -- String Data Types
    NickName CHAR(50),                -- Fixed-length string (Memory allocation is static, hence wasted if not fully used)
    Email VARCHAR(320),               -- Variable-length string (up to 320 chars for email standard)
    Bio TEXT,                         -- Large text up to 65,535 chars

    -- Boolean
    IsActive BOOLEAN,                 -- Stored as TINYINT(1) (0 = false, 1 = true)

    -- Date/Time Data Types
    BirthDate DATE,                   -- YYYY-MM-DD
    CreatedAt DATETIME,               -- YYYY-MM-DD HH:MM:SS
    UpdatedAt TIMESTAMP,              -- Auto-updated timestamp
    EventTime TIME,                   -- HH:MM:SS
    YearOfJoin YEAR(4),               -- Year format YYYY

    -- BLOB Data Types
    ProfilePic BLOB,                  -- Up to 65 KB binary
    LargeData MEDIUMBLOB,             -- Up to 16 MB binary
    HugeFile LONGBLOB                 -- Up to 4 GB binary  -- For storing images and videos
);

/*
Technically possible, but not recommended for large files to be stored in MySQL DB.

Best practice:

Store the file on disk / cloud storage (like S3, Azure Blob, Google Cloud Storage).
Store only the file path or URL in MySQL.

This avoids database bloat and improves performance.


Use BLOB/LONGBLOB if you really want to store files inside MySQL.
For scalable apps, store files externally and keep only metadata + file path in MySQL.
*/