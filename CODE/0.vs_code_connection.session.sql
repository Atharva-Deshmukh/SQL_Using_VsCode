-- Use the schema
USE vs_code_db;

-- Create a table for programming languages
CREATE TABLE ProgrammingLanguages (
    lang_id INT PRIMARY KEY,
    language_name VARCHAR(50),
    designed_by VARCHAR(50),
    first_release_year INT
);

-- Insert 2 rows of data
INSERT INTO ProgrammingLanguages (lang_id, language_name, designed_by, first_release_year) VALUES
(1, 'Python', 'Guido van Rossum', 1991),
(2, 'JavaScript', 'Brendan Eich', 1995);

-- View the data
SELECT * FROM ProgrammingLanguages;