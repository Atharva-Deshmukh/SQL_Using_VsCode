-- Create a new database named 'myDB'
CREATE DATABASE myDB;

-- Drop the database named 'myDB'
DROP DATABASE myDB;

-- Create DB only if it does not exist
CREATE DATABASE IF NOT EXISTS myDB;

-- It shows system schemas along with the DBs we created
SHOW DATABASES;

-- ---------------------------------------------------------------
-- SCHEMA = DATABASE in MySQL

CREATE SCHEMA IF NOT EXISTS myDB;
DROP SCHEMA myDB;
SHOW SCHEMAS;