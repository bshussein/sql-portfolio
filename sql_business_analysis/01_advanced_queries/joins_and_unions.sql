-- =============================================================
-- File: joins_and_unions.sql
-- Description:
--   Multi-table queries using INNER JOIN, OUTER JOIN, and UNION
--   against the AP database.
--   Includes:
--     * Vendor + invoice detail joins
--     * Balance calculations
--     * Example use of UNION 
-- =============================================================

-- Exercise 1: Inner join Vendors and Invoices to return all columns.

SELECT *
FROM Vendors v
INNER JOIN Invoices i
ON v.vendor_id = i.vendor_id;

-- Exercise 2: Retrieve vendor and invoice details for non-zero balances, sorted by vendor name.

SELECT v.vendor_name,
       i.invoice_number,
       i.invoice_date,
       (i.invoice_total - (i.payment_total + i.credit_total)) AS balance_due
FROM Vendors v
INNER JOIN Invoices i
ON v.vendor_id = i.vendor_id
WHERE (i.invoice_total - (i.payment_total + i.credit_total)) > 0
ORDER BY v.vendor_name ASC;

-- Exercise 3: Join Vendors and General_Ledger_Accounts to show vendor name, default account, and description, sorted by account description.

SELECT v.vendor_name,
       v.default_account_number AS default_account,
       g.account_description AS description
FROM Vendors v
INNER JOIN General_Ledger_Accounts g
ON v.default_account_number = g.account_number
ORDER BY g.account_description ASC, v.vendor_name ASC;

-- Exercise 4: Join Vendors, Invoices, and Invoice_Line_Items to retrieve vendor, invoice, and line item details, sorted by multiple columns.

SELECT v.vendor_name,
       i.invoice_date,
       i.invoice_number,
       il.invoice_sequence AS li_sequence,
       il.line_item_amount AS li_amount
FROM Vendors v
INNER JOIN Invoices i
ON v.vendor_id = i.vendor_id
INNER JOIN Invoice_Line_Items il
ON i.invoice_id = il.invoice_id
ORDER BY v.vendor_name ASC, i.invoice_date ASC, i.invoice_number ASC, il.invoice_sequence ASC;

-- Exercise 5: Self-join Vendors to find vendors with the same last name but different IDs, sorted by last name.

SELECT v1.vendor_id,
       v1.vendor_name,
       CONCAT(v1.vendor_contact_first_name, ' ', v1.vendor_contact_last_name) AS contact_name
FROM Vendors v1
INNER JOIN Vendors v2
ON v1.vendor_contact_last_name = v2.vendor_contact_last_name
AND v1.vendor_id != v2.vendor_id
ORDER BY v1.vendor_contact_last_name ASC;

-- Exercise 6: Outer join General_Ledger_Accounts to find accounts not used in Invoice_Line_Items, sorted by account number.

SELECT g.account_number,
       g.account_description
FROM General_Ledger_Accounts g
LEFT JOIN Invoice_Line_Items i
ON g.account_number = i.account_number
WHERE i.invoice_id IS NULL
ORDER BY g.account_number ASC;

-- Exercise 7: Use UNION to combine vendors inside and outside California, labeling states, sorted by vendor name.

SELECT vendor_name, 'CA' AS vendor_state
FROM Vendors
WHERE vendor_state = 'CA'
UNION
SELECT vendor_name, 'Outside CA' AS vendor_state
FROM Vendors
WHERE vendor_state != 'CA'
ORDER BY vendor_name ASC;
