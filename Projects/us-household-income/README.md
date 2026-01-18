# US Household Income Analysis (SQL)

## Overview
This project analyzes U.S. household income data to explore geographic and demographic
patterns across states, counties, and cities. The focus is on cleaning inconsistent
records, validating joins between related tables, and identifying income trends
using SQL.

## Business Questions
- How does household income vary across U.S. states?
- Which states have the lowest and highest average household income?
- Are there income differences across different household or regional types?
- Which cities show the highest average household income within each state?

## Dataset
- The project uses two related tables:
  - `us_household_income`: geographic and classification data
  - `us_household_income_statistics`: income metrics (mean and median)
- Records are linked using a shared `id` field.
- The dataset contains inconsistencies such as duplicates, spelling variations,
  and missing values that require cleaning.

## Data Cleaning (`sql/cleaning.sql`)
Key cleaning steps include:
- Removing duplicate records based on unique identifiers.
- Standardizing state name spelling and categorical values.
- Filling missing location information where possible.
- Reviewing land and water area fields for missing or zero values.

## Data Validation (`sql/quality_checks.sql`)
Quality checks are used to verify that cleaning was successful:
- Confirming no remaining duplicate IDs.
- Checking for missing or inconsistent geographic fields.
- Verifying join coverage between income and statistics tables.
- Reviewing invalid or zero income values.

## Analysis (`sql/analysis.sql`)
Exploratory analysis focuses on:
- Geographic context using land and water area by state.
- Average household income comparisons across states.
- Income differences by household or regional type.
- Identifying high-income city and state combinations.

## Key Takeaways
- Household income varies significantly across U.S. states and regions.
- Clear differences emerge between lower- and higher-income states when
  averaging mean and median income.
- Income patterns differ across household or regional classifications,
  with some types consistently showing higher averages.
- City-level analysis highlights localized income concentration.

## Data Source
This project uses a publicly available U.S. household income dataset.
The raw data is included in the `data/` folder for transparency and reproducibility.
All transformations and analysis are performed in SQL.

## How to Run
- SQL dialect: MySQL
- Load the raw data into tables named:
  - `us_household_income`
  - `us_household_income_statistics`
- Execute `cleaning.sql`, then `quality_checks.sql`, followed by `analysis.sql`.

## Notes
This project emphasizes data cleaning, validation, and exploratory analysis rather than predictive modeling.
