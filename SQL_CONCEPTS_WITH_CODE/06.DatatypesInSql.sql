CREATE TABLE IF NOT EXISTS Persons (
    PersonID INT(12) NOT NULL,        -- Numeric
    PersonID INT(12) UNSIGNED,        -- Restrict negative values
    FirstName VARCHAR(255),           -- String
    Priority ENUM('Low','Medium','High') -- Stores one value from a predefined list.

    -- Numeric Data Types
    Age TINYINT(3),                   -- -128 to 127 (signed), small numbers
    Salary DECIMAL(10,2),             -- Fixed-point with precision
    Score FLOAT(7,3),                 -- Approx floating-point
    BigNumber BIGINT(20),             -- Large integers

    -- String Data Types
    NickName CHAR(50),                -- Fixed-length string (Memory allocation is static, hence wasted if not fully used)
    Email VARCHAR(320),               -- Variable-length string (up to 320 chars for email standard)
    Bio TEXT,                         -- Large text up to 65k characters

    -- Boolean
    IsActive BOOLEAN,                 -- Stored as TINYINT(1) (0 = false, 1 = true)

    -- Date/Time Data Types
    BirthDate DATE,                   -- YYYY-MM-DD
    EventTime TIME,                   -- HH:MM:SS
    CreatedAt DATETIME,               -- YYYY-MM-DD HH:MM:SS
    UpdatedAt TIMESTAMP,              -- Auto-updated timestamp
    YearOfJoin YEAR(4),               -- Year format YYYY

    -- BLOB Data Types
    ProfilePic BLOB,                  -- Up to 65 KB binary  -- For storing images and videos
);