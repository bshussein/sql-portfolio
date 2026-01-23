# 01 – Advanced Queries

This folder contains analytical SQL queries written against an Accounts Payable
(AP) sample database. The queries focus on answering common **business and
financial analysis questions** using core SQL patterns.

Rather than treating SQL as isolated syntax, these examples demonstrate how
joins, aggregation, and subqueries are used to summarize spending, analyze vendor
activity, and understand account-level behavior.

---

## Business Context

The AP database models a realistic business scenario involving:
- Vendors
- Invoices and payments
- Line items and general ledger accounts
- Payment terms and balances due

The queries in this folder simulate questions an analyst might ask when reviewing
vendor spend, payment behavior, or accounting complexity.

---

## Key Questions Explored

- Which vendors receive the highest total payments?
- How many invoices does each vendor generate?
- Which accounts drive the largest expenses?
- Which vendors are paid from multiple accounts?
- How do invoice totals, payments, and balances aggregate across dimensions?

---

## Files

- **joins_and_unions.sql**  
  Multi-table queries using JOINs (and UNION where applicable) to combine vendor,
  invoice, and account data for analysis.

- **grouping_and_summarizing.sql**  
  Aggregation and GROUP BY queries that summarize financial activity, including
  vendor totals, account-level rollups, and summary rows.

- **subqueries.sql**  
  Examples of using subqueries for filtering and comparison, illustrating
  alternative ways to answer analytical questions without direct joins.

Each file includes comments and exercise labels from its original coursework
context, but has been retained here because the queries reflect **real SQL
patterns commonly used in analyst roles**.

---

## Skills Demonstrated

- INNER and OUTER JOINs
- GROUP BY and aggregate functions
- HAVING vs WHERE
- Subqueries for filtering and comparison
- Rollups and summary reporting

These patterns form the foundation of SQL-based reporting and analysis in
business environments.
