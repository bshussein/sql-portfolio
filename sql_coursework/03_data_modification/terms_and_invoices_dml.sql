-- =============================================================
-- File: terms_and_invoices_dml.sql
-- Description:
--   Data modification statements on the AP database, including:
--     * INSERT into terms and invoices
--     * UPDATE to adjust terms and invoice totals
--     * DELETE of sample rows
--     * Use of LAST_INSERT_ID() for related inserts
-- =============================================================

-- Exercise 1: Add a row to the Terms table (INSERT statement)
-- terms_id is a primary key (duplicate values are not allowed).

INSERT INTO Terms (terms_id, terms_description, terms_due_days)
VALUES (6, 'Net due 120 days', 120);

-- Exercise 2: Update the newly added row by changing the description and due days
UPDATE Terms
SET terms_description = 'Net due 125 days',
    terms_due_days = 125
WHERE terms_id = 6;

-- Exercise 3: Delete the newly added row from the Terms table
-- Note: Deleting a parent row with foreign key dependencies fails unless child rows are removed first or cascading is enabled.

DELETE FROM Terms
WHERE terms_id = 6;

-- Exercise 4: Add a new row to the Invoices table without specifying column names
	-- Number of values must match the table's columns when omitting column names
	-- NULL for auto-increment columns (ex: invoice_id)
	-- Omitting column names can break if the table structure changes (ex: columns are added/reordered)

DESCRIBE invoices;

INSERT INTO Invoices
VALUES (NULL, 32, 'AX-014-027', '2018-08-01', 434.58, 0.00, 0.00, 2, '2018-08-31', NULL);

-- Exercise 5: Add two new rows to the Invoice_Line_Items table for the invoice from Exercise 4
-- LAST_INSERT_ID(): link line items to the latest invoice and ensure each has a sequence, account, amount, and description.

INSERT INTO Invoice_Line_Items (invoice_id, invoice_sequence, account_number, line_item_amount, line_item_description)
VALUES 
(LAST_INSERT_ID(), 1, 160, 180.23, 'Hard drive'),
(LAST_INSERT_ID(), 2, 527, 254.35, 'Exchange Server update');

-- Exercise 6: Update the invoice added in Exercise 4 to change credit_total and payment_total
	-- Update credit_total to 10% of invoice_total
	-- Update payment_total to the remaining 90% of invoice_total
UPDATE Invoices
SET credit_total = invoice_total * 0.10,
    payment_total = invoice_total - (invoice_total * 0.10)
WHERE invoice_id = LAST_INSERT_ID();

-- Exercise 7: Update the Vendors table to change the default_account_number for vendor ID 44
UPDATE Vendors
SET default_account_number = 403
WHERE vendor_id = 44;

-- Exercise 8: Update all invoices for vendors with default terms ID of 2
	-- Subquery: find all vendor_id values with default_terms_id = 2
    -- Only updates invoices that belong to those vendor_id values
UPDATE Invoices
SET terms_id = 2
WHERE vendor_id IN (
    SELECT vendor_id
    FROM Vendors
    WHERE default_terms_id = 2
);

-- Exercise 9: Delete the invoice and its related line items added in Exercise 4
-- Step 1: Remove line items associated with the invoice (to avoid foreign key issue)
DELETE FROM Invoice_Line_Items
WHERE invoice_id = LAST_INSERT_ID();

-- Step 2: Remove the invoice from the Invoices table
DELETE FROM Invoices
WHERE invoice_id = LAST_INSERT_ID();
