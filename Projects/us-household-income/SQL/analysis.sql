/* =========================================
   US Household Income — Exploratory Analysis
   Purpose:
   Explore geographic patterns and income differences
   using both the income and statistics tables.
   ========================================= */


/* 1) Inspect data */
SELECT * 
FROM us_household_income;

SELECT * 
FROM us_household_income_statistics;


/* 2) Geographic size context
   Question: Which states have the most land and water area?
*/

-- Top 10 states by land area
SELECT
  State_Name,
  SUM(ALand) AS total_land,
  SUM(AWater) AS total_water
FROM us_household_income
GROUP BY State_Name
ORDER BY total_land DESC
LIMIT 10;

-- Top 10 states by water area
SELECT
  State_Name,
  SUM(ALand) AS total_land,
  SUM(AWater) AS total_water
FROM us_household_income
GROUP BY State_Name
ORDER BY total_water DESC
LIMIT 10;


/* 3) Join income + stats tables
   Question: What does a joined record look like (excluding Mean=0)?
*/
SELECT
  u.State_Name,
  u.County,
  u.Type,
  us.`Primary`,
  us.Mean,
  us.Median
FROM us_household_income u
INNER JOIN us_household_income_statistics us
  ON u.id = us.id
WHERE us.Mean <> 0;


/* 4) Lowest vs highest income states
   Question: Which states have the lowest and highest household income (avg Mean/Median)?
*/

-- Top 10 lowest income states
SELECT
  u.State_Name,
  ROUND(AVG(us.Mean), 1) AS avg_mean,
  ROUND(AVG(us.Median), 1) AS avg_median
FROM us_household_income u
INNER JOIN us_household_income_statistics us
  ON u.id = us.id
WHERE us.Mean <> 0
GROUP BY u.State_Name
ORDER BY avg_mean
LIMIT 10;

-- Top 10 highest income states
SELECT
  u.State_Name,
  ROUND(AVG(us.Mean), 1) AS avg_mean,
  ROUND(AVG(us.Median), 1) AS avg_median
FROM us_household_income u
INNER JOIN us_household_income_statistics us
  ON u.id = us.id
WHERE us.Mean <> 0
GROUP BY u.State_Name
ORDER BY avg_mean DESC
LIMIT 10;


/* 5) Income patterns by household "Type"
   Question: Which household types tend to have higher incomes?
   Note: Filter to types with enough records to be meaningful.
*/
SELECT
  u.Type,
  COUNT(*) AS type_count,
  ROUND(AVG(us.Mean), 1) AS avg_mean,
  ROUND(AVG(us.Median), 1) AS avg_median
FROM us_household_income u
INNER JOIN us_household_income_statistics us
  ON u.id = us.id
WHERE us.Mean <> 0
GROUP BY u.Type
HAVING COUNT(*) > 100
ORDER BY avg_mean DESC;


/* 6) Highest-income cities by state
   Question: Which city/state combinations show the highest average income?
*/
SELECT
  u.State_Name,
  u.City,
  ROUND(AVG(us.Mean), 1) AS avg_income,
  ROUND(AVG(us.Median), 1) AS avg_median
FROM us_household_income u
JOIN us_household_income_statistics us
  ON u.id = us.id
WHERE us.Mean <> 0
GROUP BY u.State_Name, u.City
ORDER BY avg_income DESC;
