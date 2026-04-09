-- ============================================================
-- US Household Income Project — Exploratory Data Analysis
-- Datasets : USHouseholdIncome.csv
--            USHouseholdIncome_Statistics.csv
-- Rows     : ~32,534 (Income) | ~32,527 (Statistics)
-- Author   : (Your Name)
-- ============================================================


-- ============================================================
-- STEP 0: Preview the cleaned data
-- ============================================================

SELECT * 
FROM us_project.us_household_income;

SELECT * 
FROM us_project.us_householdincome_statistics;


-- ============================================================
-- STEP 1: Land & Water Area by State
-- Identifies which states have the most land and water area.
-- ============================================================

-- Top 10 states by total land area
SELECT 
    State_Name, 
    SUM(ALand)  AS Total_Land,
    SUM(AWater) AS Total_Water
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY Total_Land DESC
LIMIT 10;


-- Top 10 states by total water area
SELECT 
    State_Name, 
    SUM(ALand)  AS Total_Land,
    SUM(AWater) AS Total_Water
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY Total_Water DESC
LIMIT 10;


-- ============================================================
-- STEP 2: Join Income + Geography Tables
-- Combines both tables on id to enable income analysis
-- alongside geographic data. Excludes rows where Mean = 0.
-- ============================================================

SELECT 
    u.State_Name, 
    County, 
    Type, 
    `Primary`, 
    Mean, 
    Median 
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_householdincome_statistics AS us
    ON u.id = us.id
WHERE Mean <> 0;


-- ============================================================
-- STEP 3: Average Mean & Median Income by State
-- Ranks states from lowest to highest and highest to lowest
-- by both mean and median household income.
-- ============================================================

-- Bottom 10 states by average Mean income
SELECT 
    u.State_Name, 
    ROUND(AVG(Mean), 1)   AS Avg_Mean_Income,
    ROUND(AVG(Median), 1) AS Avg_Median_Income
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_householdincome_statistics AS us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY Avg_Mean_Income ASC
LIMIT 10;


-- Top 10 states by average Mean income
SELECT 
    u.State_Name, 
    ROUND(AVG(Mean), 1)   AS Avg_Mean_Income,
    ROUND(AVG(Median), 1) AS Avg_Median_Income
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_householdincome_statistics AS us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY Avg_Mean_Income DESC
LIMIT 10;


-- Top 10 states by average Median income
SELECT 
    u.State_Name, 
    ROUND(AVG(Mean), 1)   AS Avg_Mean_Income,
    ROUND(AVG(Median), 1) AS Avg_Median_Income
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_householdincome_statistics AS us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY Avg_Median_Income DESC
LIMIT 10;


-- Bottom 10 states by average Median income
SELECT 
    u.State_Name, 
    ROUND(AVG(Mean), 1)   AS Avg_Mean_Income,
    ROUND(AVG(Median), 1) AS Avg_Median_Income
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_householdincome_statistics AS us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY Avg_Median_Income ASC
LIMIT 10;


-- ============================================================
-- STEP 4: Income by Location Type
-- Compares average income across different location types
-- (City, Town, Track, Borough, CDP, etc.)
-- Only includes types with more than 100 records for
-- statistical reliability.
-- ============================================================

SELECT 
    Type, 
    COUNT(Type)           AS Type_Count,
    ROUND(AVG(Mean), 1)   AS Avg_Mean_Income,
    ROUND(AVG(Median), 1) AS Avg_Median_Income
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_householdincome_statistics AS us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY Type
HAVING Type_Count > 100
ORDER BY Avg_Mean_Income DESC
LIMIT 20;


-- ============================================================
-- STEP 5: Income by City
-- Identifies the highest earning cities across the US
-- by average median household income.
-- ============================================================

SELECT 
    u.State_Name, 
    City, 
    ROUND(AVG(Mean), 1)   AS Avg_Mean_Income,
    ROUND(AVG(Median), 1) AS Avg_Median_Income
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_householdincome_statistics AS us
    ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY Avg_Median_Income DESC;
