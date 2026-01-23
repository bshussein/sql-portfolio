-- =============================================================
-- File: subqueries.sql
-- Description:
--   Examples of using subqueries instead of joins and for
--   filtering, comparisons to aggregates, and existence checks.
--   Includes:
--     * IN subqueries
--     * Comparisons to AVG()
--     * Searching with correlated subqueries
-- =============================================================

-- subqueries can be easier to read (two step subquery first then main query use results)
-- JOIN can be more efficent for large datasets(combine tables in single step)
SELECT DISTINCT vendor_name
FROM Vendors
WHERE vendor_id IN (
    SELECT vendor_id 
    FROM Invoices
)
ORDER BY vendor_name;

-- Invoices with Payment Totals Greater Than the Average
SELECT 
	invoice_number,
    invoice_total
FROM Invoices
WHERE payment_total > (
	SELECT AVG(payment_total)
    FROM Invoices
)
ORDER BY invoice_total DESC;

-- Get accounts from General_Ledger_Accounts that are not referenced in Invoice_Line_Items.
SELECT 
    account_number, 
    account_description
FROM General_Ledger_Accounts g
WHERE NOT EXISTS (
    -- Subquery checks for matching rows only (not retriving data) (SELECT 1 is a placeholder).
    SELECT 1
    FROM Invoice_Line_Items l
    WHERE g.account_number = l.account_number
)
ORDER BY account_number;

-- Return more than one line
	-- subquery: identifies invoices with more than one line item.
    -- link vendor and invoice_line_items by joining invoices as well
    -- Main query:Retrieves the line item details for those invoices and includes the vendor name.
SELECT
	v.vendor_name,
    l.invoice_id, 
    l.invoice_sequence,
    l.line_item_amount
FROM invoice_line_items l
JOIN Invoices i ON l.invoice_id = i.invoice_id
JOIN Vendors v ON i.vendor_id = v.vendor_id
WHERE l.invoice_id IN (
	SELECT invoice_id 
    FROM invoice_line_items
    GROUP BY invoice_id
    HAVING COUNT(invoice_sequence) > 1
)
ORDER BY v.vendor_name, l.invoice_id, l.invoice_sequence;


-- Find the largest unpaid invoice for each vendor (subquery)
SELECT 
    vendor_id,
    MAX(invoice_total - payment_total - credit_total) AS largest_unpaid_invoice
FROM Invoices
WHERE (invoice_total - payment_total - credit_total) > 0
GROUP BY vendor_id
ORDER BY largest_unpaid_invoice DESC;

-- Main query: Return the sum of the largest unpaid invoices
SELECT 
    SUM(largest_unpaid_invoice) AS total_largest_unpaid_invoice
FROM (
    SELECT 
        vendor_id,
        MAX(invoice_total - payment_total - credit_total) AS largest_unpaid_invoice
    FROM Invoices
    GROUP BY vendor_id
) AS subquery; -- FROM clause requires an alias because it treats a subquery as a temporary table

-- Vendor's located in unique cities and states 
SELECT 
	vendor_name,
    vendor_city,
    vendor_state 
FROM vendors v1
WHERE NOT EXISTS ( 
	SELECT 1
    FROM vendors v2 
    WHERE v1.vendor_city = v2.vendor_city
    AND v1.vendor_state = v2.vendor_state
    AND v1.vendor_id <> v2.vendor_id -- different vendor within same city and state
)
ORDER BY vendor_state, vendor_city;

-- Find vendor's oldest invoice (Correlated Subquery)
	-- Correlated subquery: A subquery that refers to a column from the main query. (calculating each row in the main query) 
SELECT * FROM vendors;
SELECT 
	v.vendor_name,
    i.invoice_number,
    i.invoice_date,
    i.invoice_total
FROM invoices i
JOIN vendors v ON v.vendor_id = i.vendor_id
-- oldest invoice date (MIN(invoice_date)) for each vendor
WHERE i.invoice_date = (
	SELECT MIN(i2.invoice_date)
    FROM invoices i2
    WHERE i2.vendor_id = i.vendor_id -- Correlation to the outer query
)
ORDER BY v.vendor_name;

-- Rewrite previous query using an Inline View

-- Inline view acts like a temporary table, precomputing results (earliest invoice date).
-- It is more efficient than correlated subqueries because it calculates values only once.
SELECT 
    v.vendor_name, 
    i.invoice_number, 
    i.invoice_date, 
    i.invoice_total
FROM Vendors v
JOIN Invoices i ON v.vendor_id = i.vendor_id
JOIN (
    -- Inline view: Precomputes the earliest invoice date for each vendor
    SELECT 
        vendor_id, 
        MIN(invoice_date) AS earliest_date
    FROM Invoices
    GROUP BY vendor_id
) oldest_invoices 
ON i.vendor_id = oldest_invoices.vendor_id
AND i.invoice_date = oldest_invoices.earliest_date
ORDER BY v.vendor_name;


-- CTE (Common Table Expression): Creates a reusable temporary table starting from the WITH clause.
-- The CTE calculates the largest unpaid invoice for each vendor, which is then used in the main query.
WITH LargestUnpaid AS (
    SELECT 
        vendor_id,  
        MAX(invoice_total - payment_total - credit_total) AS largest_unpaid_invoice  
    FROM Invoices
    WHERE (invoice_total - payment_total - credit_total) > 0
    GROUP BY vendor_id
)
-- Main query to sum the largest unpaid invoices
SELECT 
    SUM(largest_unpaid_invoice) AS total_largest_unpaid_invoices
FROM LargestUnpaid;


    
