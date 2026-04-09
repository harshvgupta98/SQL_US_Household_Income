-- ============================================================
-- US Household Income Project — Data Cleaning
-- Datasets : USHouseholdIncome.csv
--            USHouseholdIncome_Statistics.csv
-- Rows     : ~32,534 (Income) | ~32,527 (Statistics)
-- Author   : (Your Name)
-- ============================================================


-- ============================================================
-- STEP 0: Preview the raw data
-- ============================================================

SELECT * 
FROM us_project.us_household_income;

SELECT * 
FROM us_project.us_householdincome_statistics;


-- ============================================================
-- STEP 1: Fix Column Name (BOM Character)
-- The statistics table imports with a corrupted id column name
-- due to a UTF-8 BOM character. Rename it to clean 'id'.
-- ============================================================

ALTER TABLE us_householdincome_statistics 
RENAME COLUMN `ï»¿id` TO `id`;


-- ============================================================
-- STEP 2: Row Counts
-- Verify how many records exist in each table.
-- ============================================================

SELECT COUNT(id) AS income_row_count
FROM us_project.us_household_income;

SELECT COUNT(id) AS statistics_row_count
FROM us_project.us_householdincome_statistics;


-- ============================================================
-- STEP 3: Remove Duplicate Rows — us_household_income
-- Each id should appear only once.
-- ============================================================

-- 3a. Identify duplicate ids
SELECT id, COUNT(id) AS occurrences
FROM us_household_income
GROUP BY id
HAVING occurrences > 1;


-- 3b. Find the row_ids of duplicate records (keep first, remove rest)
SELECT *
FROM (
    SELECT 
        row_id,
        id,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
    FROM us_household_income
) AS duplicates
WHERE row_num > 1;


-- 3c. ⚠️ Run the SELECT above first to verify rows, THEN run this DELETE
DELETE FROM us_household_income
WHERE row_id IN (
    SELECT row_id
    FROM (
        SELECT 
            row_id,
            id,
            ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
        FROM us_household_income
    ) AS duplicates
    WHERE row_num > 1
);


-- ============================================================
-- STEP 4: Check for Duplicates — us_householdincome_statistics
-- No duplicates found in this table, but flagged for awareness.
-- ============================================================

SELECT id, COUNT(id) AS occurrences
FROM us_householdincome_statistics
GROUP BY id
HAVING occurrences > 1;

-- ℹ️ No DELETE applied here — verify results above before acting


-- ============================================================
-- STEP 5: Fix Inconsistent State Names
-- Some State_Name values have incorrect casing or typos.
-- ============================================================

-- 5a. Review all state names and their counts
SELECT State_Name, COUNT(State_Name) AS occurrences
FROM us_household_income
GROUP BY State_Name
ORDER BY State_Name;

-- 5b. List distinct state names to spot any anomalies
SELECT DISTINCT State_Name
FROM us_household_income
ORDER BY State_Name;


-- 5c. Fix typo: 'georia' → 'Georgia'
UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

-- Verify fix
SELECT DISTINCT State_Name
FROM us_household_income
WHERE State_Name = 'Georgia';


-- 5d. Fix casing: 'alabama' → 'Alabama'
UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

-- Verify fix
SELECT DISTINCT State_Name
FROM us_household_income
WHERE State_Name = 'Alabama';


-- 5e. Verify state abbreviations look correct
SELECT DISTINCT State_ab
FROM us_household_income
ORDER BY State_ab;


-- ============================================================
-- STEP 6: Fill Missing Place Values
-- One row in Autauga County has a blank Place field.
-- ============================================================

-- 6a. Find rows with blank Place
SELECT *
FROM us_household_income
WHERE Place = ''
ORDER BY 1;

-- 6b. Inspect the county to confirm the correct Place value
SELECT *
FROM us_household_income
WHERE County = 'Autauga County'
ORDER BY City;

-- 6c. Fill in the missing Place value
UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
  AND City = 'Vinemont';

-- Verify fix
SELECT *
FROM us_household_income
WHERE County = 'Autauga County'
  AND City = 'Vinemont';


-- ============================================================
-- STEP 7: Fix Inconsistent Type Values
-- 'Boroughs' is a typo — should be 'Borough'.
-- ============================================================

-- 7a. Review all Type values and counts
SELECT Type, COUNT(Type) AS occurrences
FROM us_household_income
GROUP BY Type
ORDER BY Type;

-- 7b. Fix typo: 'Boroughs' → 'Borough'
UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

-- Verify fix
SELECT Type, COUNT(Type) AS occurrences
FROM us_household_income
GROUP BY Type
ORDER BY Type;


-- ============================================================
-- STEP 8: Investigate Zero Land & Water Area Values
-- Rows where ALand or AWater = 0 may indicate missing data.
-- ℹ️ Observation only — no changes applied.
-- ============================================================

-- Rows where AWater is zero or missing
SELECT ALand, AWater
FROM us_household_income
WHERE AWater = 0 
   OR AWater = '' 
   OR AWater IS NULL;

-- Rows where ALand is zero or missing
SELECT ALand, AWater
FROM us_household_income
WHERE ALand = 0 
   OR ALand = '' 
   OR ALand IS NULL;
