# 02 – Database Design

This folder contains relational database schemas and entity-relationship (ER)
models designed using MySQL Workbench. The focus is on **structuring data in a way
that supports accurate querying, reporting, and long-term data integrity**.

Rather than treating SQL only as query writing, this section demonstrates how
thoughtful database design enables reliable analytics and consistent business
logic.

---

## Business Context

The schemas in this folder model realistic business scenarios involving:
- Members and memberships
- Clearly defined entities and relationships
- Constraints that prevent invalid or inconsistent data

The designs emphasize normalization, proper key relationships, and indexing to
ensure that analytical queries run correctly and efficiently.

---

## Files

- **membership_schema_and_indexes.sql**  
  Defines tables, primary keys, foreign keys, and indexes for a membership-based
  database. Demonstrates how constraints and indexing support both data integrity
  and query performance.

- **eer*_forward_engineering.sql**  
  Forward-engineered SQL scripts generated from ER models in MySQL Workbench,
  showing how conceptual designs translate into physical database schemas.

- **eer*_erd.png**  
  Exported ER diagram images visualizing entities, attributes, and relationships
  within the database.

---

## Skills Demonstrated

- Relational schema design
- ER modeling
- Table normalization
- Primary and foreign key constraints
- Index creation
- Translating ER diagrams into SQL schemas

These design patterns are foundational for analytics, reporting, and backend
systems that rely on clean and well-structured data.
