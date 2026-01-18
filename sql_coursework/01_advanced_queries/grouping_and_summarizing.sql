
-- =============================================================
-- File: grouping_and_summarizing.sql
-- Description:
--   Aggregation and GROUP BY queries on the AP database.
--   Includes:
--     * Total invoiced amounts per vendor
--     * Total payments by vendor
--     * Summaries by various business dimensions
-- =============================================================

-- Retrieve the total invoiced amount for each vendor.
SELECT 
    vendor_id, 
    SUM(invoice_total) AS total_invoiced
FROM Invoices
GROUP BY vendor_id;

-- Retrieve the total payment amount for each vendor, sorted in descending order.
SELECT 
    v.vendor_name AS 'Vendor Name',
    SUM(i.payment_total) AS 'Total Payments'
FROM Vendors v
JOIN Invoices i 
    ON v.vendor_id = i.vendor_id
GROUP BY v.vendor_name
ORDER BY 'Total Payments' DESC;

-- Retrieve vendor details, count of invoices, and total invoiced amounts.
SELECT 
    v.vendor_name, 
    COUNT(i.invoice_id) AS invoice_count, 
    SUM(i.invoice_total) AS total_invoiced
FROM Vendors v
JOIN Invoices i 
    ON v.vendor_id = i.vendor_id
GROUP BY v.vendor_name
ORDER BY invoice_count DESC;

-- Exercise 4: Accounts with Multiple Line Items
-- Retrieve accounts with more than one line item and their total amounts.
SELECT 
    g.account_description,
    COUNT(l.invoice_sequence) AS line_item_count, 
    SUM(l.line_item_amount) AS total_amount
FROM General_Ledger_Accounts g
JOIN invoice_line_items l 
    ON g.account_number = l.account_number
GROUP BY g.account_description
HAVING line_item_count > 1
ORDER BY total_amount DESC;

-- Retrieve accounts and their line item details for invoices within a specific date range.
SELECT 
    g.account_description,
    COUNT(l.invoice_sequence) AS line_item_count, 
    SUM(l.line_item_amount) AS total_amount
FROM General_Ledger_Accounts g
JOIN invoice_line_items l 
    ON g.account_number = l.account_number
JOIN Invoices i 
    ON l.invoice_id = i.invoice_id
WHERE i.invoice_date BETWEEN '2018-04-01' AND '2018-06-30'
GROUP BY g.account_description 
HAVING line_item_count > 1
ORDER BY total_amount DESC;

-- Retrieve the total line item amount for each account, including a grand total row.
SELECT 
    l.account_number,
    SUM(l.line_item_amount) AS total_amount
FROM invoice_line_items l
GROUP BY l.account_number WITH ROLLUP;

-- Exercise 7: Vendors Paid from Multiple Accounts
-- Find vendors who were paid from more than one account.
SELECT 
    v.vendor_name,
    COUNT(DISTINCT l.account_number) AS account_count
FROM Vendors v
JOIN Invoices i 
    ON v.vendor_id = i.vendor_id 
JOIN invoice_line_items l 
    ON l.invoice_id = i.invoice_id
GROUP BY v.vendor_name
HAVING account_count > 1;

-- Retrieve the last payment date and total balance due for each combination of terms and vendors.
-- Add summary rows for each terms_id and a grand total row.
SELECT 
    IF(GROUPING(terms_id), 'All Terms', terms_id) AS terms_id,
    IF(GROUPING(vendor_id), 'All Vendors', vendor_id) AS vendor_id,
    MAX(payment_date) AS last_payment_date,
    SUM(invoice_total - payment_total - credit_total) AS total_balance_due
FROM Invoices
GROUP BY terms_id, vendor_id WITH ROLLUP;
