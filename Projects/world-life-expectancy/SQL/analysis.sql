/* =====================================================
   World Life Expectancy — Exploratory Data Analysis
   Purpose:
   Explore global trends in life expectancy and examine
   how economic and health indicators relate to outcomes.
   ===================================================== */


/* -----------------------------------------------------
   1) Initial data check
   Purpose: Confirm the cleaned dataset before analysis.
   ----------------------------------------------------- */
SELECT *
FROM world_life_expectancy;


/* -----------------------------------------------------
   2) Life expectancy change by country
   Purpose:
   Identify countries with the largest overall changes
   in life expectancy across the observed time period.
   ----------------------------------------------------- */
SELECT
  Country,
  MIN(Lifeexpectancy) AS min_lifeexp,
  MAX(Lifeexpectancy) AS max_lifeexp,
  ROUND(MAX(Lifeexpectancy) - MIN(Lifeexpectancy), 1) AS life_increase_15_years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(Lifeexpectancy) <> 0
   AND MAX(Lifeexpectancy) <> 0
ORDER BY life_increase_15_years DESC;


/* -----------------------------------------------------
   3) Global life expectancy trend over time
   Purpose:
   Observe how average life expectancy has changed
   globally on a year-by-year basis.
   ----------------------------------------------------- */
SELECT
  Year,
  ROUND(AVG(Lifeexpectancy), 2) AS avg_life_expectancy
FROM world_life_expectancy
WHERE Lifeexpectancy <> 0
GROUP BY Year
ORDER BY Year;


/* -----------------------------------------------------
   4) Life expectancy and GDP by country
   Purpose:
   Compare average life expectancy with economic output
   to identify broad economic-health patterns.
   ----------------------------------------------------- */
SELECT
  Country,
  ROUND(AVG(Lifeexpectancy), 1) AS life_exp,
  ROUND(AVG(GDP), 1) AS avg_gdp
FROM world_life_expectancy
GROUP BY Country
HAVING life_exp > 0
   AND avg_gdp > 0
ORDER BY avg_gdp DESC;


/* -----------------------------------------------------
   5) High vs low GDP comparison
   Purpose:
   Compare life expectancy outcomes between countries
   with higher and lower GDP levels.
   ----------------------------------------------------- */
SELECT
  SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS high_gdp_count,
  ROUND(AVG(CASE WHEN GDP >= 1500 THEN Lifeexpectancy END), 2) AS high_gdp_life_exp,
  SUM(CASE WHEN GDP < 1500 THEN 1 ELSE 0 END) AS low_gdp_count,
  ROUND(AVG(CASE WHEN GDP < 1500 THEN Lifeexpectancy END), 2) AS low_gdp_life_exp
FROM world_life_expectancy;


/* -----------------------------------------------------
   6) Life expectancy by development status
   Purpose:
   Examine differences in life expectancy between
   developed and developing countries.
   ----------------------------------------------------- */
SELECT
  Status,
  COUNT(DISTINCT Country) AS country_count,
  ROUND(AVG(Lifeexpectancy), 1) AS avg_life_expectancy
FROM world_life_expectancy
GROUP BY Status;


/* -----------------------------------------------------
   7) BMI and life expectancy relationship
   Purpose:
   Explore how average BMI correlates with life
   expectancy at the country level.
   ----------------------------------------------------- */
SELECT
  Country,
  ROUND(AVG(Lifeexpectancy), 1) AS life_exp,
  ROUND(AVG(BMI), 1) AS avg_bmi
FROM world_life_expectancy
GROUP BY Country
HAVING life_exp > 0
   AND avg_bmi > 0
ORDER BY avg_bmi DESC;


/* -----------------------------------------------------
   8) Rolling adult mortality example
   Purpose:
   Demonstrate use of window functions to track
   cumulative adult mortality over time.
   ----------------------------------------------------- */
SELECT
  Country,
  Year,
  Lifeexpectancy,
  AdultMortality,
  SUM(AdultMortality) OVER (
    PARTITION BY Country
    ORDER BY Year
  ) AS rolling_mortality
FROM world_life_expectancy
WHERE Country LIKE '%United%';
