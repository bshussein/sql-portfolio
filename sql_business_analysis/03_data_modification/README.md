# 03 – Data Modification (DML)

This folder contains examples of SQL data modification operations (INSERT, UPDATE,
DELETE) performed against a realistic Accounts Payable (AP) database.

The focus is on **safely modifying data while respecting business rules, foreign
key constraints, and data integrity**, which is critical in production databases
and analytical systems.

---

## Business Context

In real business environments, analysts and backend systems often need to:
- Add new reference data (such as payment terms)
- Insert transactional records (invoices and line items)
- Update records based on changing business logic
- Remove data without breaking referential integrity

The queries in this folder simulate these scenarios using an AP database that
includes vendors, invoices, payment terms, and line items.

---

## File

- **terms_and_invoices_dml.sql**  
  Demonstrates a sequence of data modification operations, including:
  - Inserting and updating payment terms
  - Inserting invoices and related line items
  - Using `LAST_INSERT_ID()` to correctly link dependent rows
  - Updating records based on subquery-driven business rules
  - Deleting records in the correct order to avoid foreign key violations

---

## Skills Demonstrated

- INSERT, UPDATE, and DELETE statements
- Managing parent–child table relationships
- Using `LAST_INSERT_ID()` for related inserts
- Subqueries for conditional updates
- Understanding and handling foreign key constraints
- Applying business rules to data modifications

These patterns reflect real-world database interactions where data changes must be
intentional, consistent, and safe for downstream reporting and analysis.
