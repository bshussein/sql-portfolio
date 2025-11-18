-- =============================================================
-- File: membership_schema_and_indexes.sql
-- Description:
--   Database design and maintenance tasks:
--     * Creating an EX membership database
--     * Defining members, committees, and junction tables
--     * Adding primary keys and AUTO_INCREMENT columns
--     * Adding indexes and unique constraints
--     * Altering tables to support new business requirements
-- =============================================================

-- Exercise 1: Add an Index to the Vendors Table
-- Index: create a structure for a column (vendor_zip_code) for faster lookup 
USE AP;

CREATE INDEX idx_zip_code
ON Vendors(vendor_zip_code);

-- Exercise 2: Create the EX Database
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    address VARCHAR(100),
    city VARCHAR(50),
    state CHAR(2),
    phone VARCHAR(15)
);

CREATE TABLE committees (
    committee_id INT AUTO_INCREMENT PRIMARY KEY,
    committee_name VARCHAR(100) NOT NULL
);

-- Link members to committees using a composite primary key (member_id + committee_id).
CREATE TABLE members_committees (
    member_id INT NOT NULL,
    committee_id INT NOT NULL,
    PRIMARY KEY (member_id, committee_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (committee_id) REFERENCES committees(committee_id)
);

-- Exercise 3: Insert Data into Tables
-- Insert rows into the `members` table
INSERT INTO members (first_name, last_name, address, city, state, phone)
VALUES 
('Cristiano', 'Ronaldo', '123 Cogenbury Cir', 'Columbus', 'OH', '614-123-4567'), 
('Ben', 'Blanco', '456 Lone Star Rd', 'Dallas', 'TX', '972-987-6543');           

-- Insert rows into the `committees` table
INSERT INTO committees (committee_name)
VALUES 
('Budget'),
('Agriculture');

-- Insert rows into the `members_committees` table
-- Tying members to the new committees
INSERT INTO members_committees (member_id, committee_id)
VALUES 
(1, 1),  -- Cristiano Ronaldo in Budget
(1, 2),  -- Cristiano Ronaldo in Agriculture
(2, 1),  -- Ben Blanco in Budget
(2, 2);  -- Ben Blanco in Agriculture

-- Exercise 4: Alter the Members Table
ALTER TABLE members
ADD COLUMN annual_dues DECIMAL(5, 2) DEFAULT 52.50, -- Adds the `annual_dues` column with a default value
ADD COLUMN payment_date DATE;

DESCRIBE members;

-- Exercise 5: Modify the Committees Table
-- Add a unique constraint to the `committee_name` column (duplicate committee names)
ALTER TABLE committees
ADD CONSTRAINT unique_committee_name UNIQUE (committee_name);

-- Testing the unique constraint
INSERT INTO committees (committee_name)
VALUES ('Budget');  -- Should fail because 'Budget' already exists


      
