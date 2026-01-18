/* =========================================
   US Household Income — Data Cleaning
   Tables:
     - us_household_income
     - us_household_income_statistics
   ========================================= */


/* 1) Quick inspection */
SELECT * FROM US_project.us_household_income;
SELECT * FROM US_project.us_household_income_statistics;


/* 2) Row counts (basic sanity check) */
SELECT COUNT(id) AS income_row_count
FROM US_project.us_household_income;

SELECT COUNT(id) AS stats_row_count
FROM US_project.us_household_income_statistics;


/* 3) Remove duplicate IDs in us_household_income */

-- Find duplicates
SELECT id, COUNT(*) AS id_count
FROM US_project.us_household_income
GROUP BY id
HAVING COUNT(*) > 1;

-- Delete duplicates (keep first row per id)
DELETE FROM US_project.us_household_income
WHERE row_id IN (
  SELECT row_id
  FROM (
    SELECT
      row_id,
      id,
      ROW_NUMBER() OVER (PARTITION BY id ORDER BY row_id) AS row_num
    FROM US_project.us_household_income
  ) d
  WHERE row_num > 1
);


/* 4) Check duplicates in statistics table (no delete shown yet) */
SELECT id, COUNT(*) AS id_count
FROM US_project.us_household_income_statistics
GROUP BY id
HAVING COUNT(*) > 1;


/* 5) Standardize State_Name */
SELECT DISTINCT State_Name
FROM US_project.us_household_income
ORDER BY State_Name;

UPDATE US_project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE US_project.us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';


/* 6) Fix missing Place (specific known issue in your dataset) */
SELECT *
FROM US_project.us_household_income
WHERE Place = ''
ORDER BY State_Name;

UPDATE US_project.us_household_income
SET Place = 'Autauga County'
WHERE County = 'Autauga County'
  AND City = 'Vinemont'
  AND Place = '';


/* 7) Standardize Type values */
SELECT Type, COUNT(*) AS type_count
FROM US_project.us_household_income
GROUP BY Type
ORDER BY type_count DESC;

UPDATE US_project.us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';


/* 8) Check land/water fields (possible missing/zero values) */
SELECT ALand, AWater
FROM US_project.us_household_income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL)
  AND (ALand = 0 OR ALand = '' OR ALand IS NULL);

SELECT ALand, AWater
FROM US_project.us_household_income
WHERE (ALand = 0 OR ALand = '' OR ALand IS NULL);
