# World Life Expectancy Analysis (SQL)

## Overview
This project analyzes global life expectancy trends across countries and years using SQL.
The goal is to demonstrate practical data cleaning, validation, and exploratory analysis
techniques on a real-world dataset with missing values and inconsistencies.

## Business Questions
- How has life expectancy changed over time across countries?
- Which countries have seen the largest improvements or declines?
- Are there observable differences between developed and developing countries?
- How do factors such as GDP and BMI relate to life expectancy?

## Dataset
- One row represents a country-year observation.
- Key fields include country, year, life expectancy, status, GDP, and BMI.
- The dataset contains missing values, duplicate records, and inconsistent entries,
  making it suitable for data cleaning and quality checks.

## Data Cleaning (`sql/cleaning.sql`)
The cleaning process focuses on preparing the data for reliable analysis:
- Removed duplicate country-year records using window functions.
- Standardized and filled missing values in categorical fields (e.g., country status).
- Addressed missing life expectancy values using surrounding-year data where appropriate.
- Ensured numeric fields were in valid ranges for analysis.

## Analysis (`sql/analysis.sql`)
Exploratory analysis was performed to identify patterns and trends:
- Life expectancy trends over time by country.
- Comparisons between developed and developing countries.
- Identification of countries with the largest changes in life expectancy.
- Basic exploration of relationships between life expectancy, GDP, and BMI.

## Key Takeaways
- Life expectancy has generally increased over time, though trends vary by country.
- Developing countries show wider variation and larger improvements in some cases.
- Economic and health-related indicators appear to correlate with life expectancy,
  though relationships differ across regions.

## How to Run
- SQL dialect: MySQL
- Execute `cleaning.sql` first to prepare the data.
- Run `analysis.sql` to reproduce the analysis queries.

## Notes
This project emphasizes clarity, data quality, and reproducibility rather than
advanced modeling. It is intended as a SQL-focused case study.
