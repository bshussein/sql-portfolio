/* =========================================
   World Life Expectancy — Data Cleaning
   ========================================= */


/* 1) Inspect raw data */
SELECT *
FROM world_life_expectancy;


/* 2) Remove duplicate Country + Year records */

-- Identify duplicates
SELECT
  Country,
  Year,
  COUNT(*) AS row_count
FROM world_life_expectancy
GROUP BY Country, Year
HAVING COUNT(*) > 1;

-- Delete duplicates using ROW_NUMBER
DELETE FROM world_life_expectancy
WHERE Row_ID IN (
  SELECT Row_ID
  FROM (
    SELECT
      Row_ID,
      ROW_NUMBER() OVER (
        PARTITION BY Country, Year
        ORDER BY Row_ID
      ) AS row_num
    FROM world_life_expectancy
  ) t
  WHERE row_num > 1
);


/* 3) Fill missing Status values */

-- Fill blank Status based on existing country values
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
  ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
  AND t2.Status = 'Developing';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
  ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
  AND t2.Status = 'Developed';


/* 4) Fill missing Lifeexpectancy values */

-- Interpolate using previous and next year values
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
  ON t1.Country = t2.Country
 AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
  ON t1.Country = t3.Country
 AND t1.Year = t3.Year + 1
SET t1.`Lifeexpectancy` =
  ROUND((t2.`Lifeexpectancy` + t3.`Lifeexpectancy`) / 2, 1)
WHERE t1.`Lifeexpectancy` = '';


/* 5) Final check */
SELECT *
FROM world_life_expectancy;
