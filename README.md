# 🏠 US Household Income — SQL Project

A complete SQL project covering data cleaning and exploratory data analysis (EDA) on a real-world dataset containing household income statistics across all US states and Puerto Rico.

---

## 📁 Project Structure

```
us-household-income/
│
├── USHouseholdIncome.csv                    # Raw geographic dataset
├── USHouseholdIncome_Statistics.csv         # Raw income statistics dataset
├── us_household_income_cleaning.sql         # Part 1: Data Cleaning
└── us_household_income_eda.sql              # Part 2: Exploratory Data Analysis
```

---

## 📊 Dataset Overview

### USHouseholdIncome.csv
**Rows:** ~32,534 | **Coverage:** All US States + Puerto Rico

| Column | Description |
|---|---|
| `row_id` | Unique row identifier |
| `id` | Location identifier (joins to statistics table) |
| `State_Code` | Numeric state code |
| `State_Name` | Full state name |
| `State_ab` | State abbreviation |
| `County` | County name |
| `City` | City name |
| `Place` | Named place / census designated area |
| `Type` | Location type (City, Town, Track, Borough, CDP, etc.) |
| `Primary` | Primary classification |
| `Zip_Code` | ZIP code |
| `Area_Code` | Phone area code |
| `ALand` | Land area (sq metres) |
| `AWater` | Water area (sq metres) |
| `Lat` | Latitude |
| `Lon` | Longitude |

### USHouseholdIncome_Statistics.csv
**Rows:** ~32,527

| Column | Description |
|---|---|
| `id` | Location identifier (joins to income table) |
| `State_Name` | Full state name |
| `Mean` | Mean household income (USD) |
| `Median` | Median household income (USD) |
| `Stdev` | Standard deviation of household income |
| `sum_w` | Sample weight |

---

## 🧹 Part 1: Data Cleaning

**File:** `us_household_income_cleaning.sql`

### Step 1 — Fix Column Name (BOM Character)
The statistics CSV imports with a corrupted `id` column name (`ï»¿id`) due to a UTF-8 Byte Order Mark. Fixed using `ALTER TABLE ... RENAME COLUMN`.

### Step 2 — Row Counts
Verified record counts in both tables to understand data volume before cleaning.

### Step 3 — Remove Duplicate Rows
Some `id` values appeared more than once in `us_household_income`. Used `ROW_NUMBER()` window function to identify and delete duplicates, keeping only the first occurrence.

### Step 4 — Check Statistics Table for Duplicates
Ran the same duplicate check on `us_householdincome_statistics` — flagged for awareness with no changes needed.

### Step 5 — Fix Inconsistent State Names
Two `State_Name` values had errors: `'georia'` (typo for Georgia) and `'alabama'` (incorrect lowercase). Both fixed with targeted `UPDATE` statements and verified afterward.

### Step 6 — Fill Missing Place Values
One row in Autauga County had a blank `Place` field. Confirmed the correct value by inspecting surrounding rows and filled it with `'Autaugaville'`.

### Step 7 — Fix Inconsistent Type Values
The value `'Boroughs'` was a typo — corrected to `'Borough'` to match the standard type values used throughout the dataset.

### Step 8 — Investigate Zero Land & Water Areas
Identified rows where `ALand` or `AWater` equals zero or is null. Flagged as observation-only — no changes applied, as zero water area is valid for inland locations.

---

## 🔍 Part 2: Exploratory Data Analysis

**File:** `us_household_income_eda.sql`

### Step 1 — Land & Water Area by State
Identified the top 10 states by total land area and top 10 by total water area using `SUM()` aggregations.

### Step 2 — Join Income + Geography Tables
Combined both tables using an `INNER JOIN` on `id`, filtering out rows where `Mean = 0` to ensure only valid income data is analysed.

### Step 3 — Average Income by State
Ranked all states by average mean and median household income, identifying both the top 10 highest and bottom 10 lowest earning states.

### Step 4 — Income by Location Type
Compared average mean and median income across location types (City, Town, Track, Borough, CDP, etc.). Applied a `HAVING COUNT > 100` filter to ensure statistical reliability by excluding rare types.

### Step 5 — Income by City
Identified the highest earning cities across the US, ranked by average median household income, with state context included.

---

## 🛠️ How to Run

1. Create a schema called `us_project` in your MySQL database
2. Import `USHouseholdIncome.csv` as table `us_household_income`
3. Import `USHouseholdIncome_Statistics.csv` as table `us_householdincome_statistics`
4. Run `us_household_income_cleaning.sql` first to clean the data
5. Run `us_household_income_eda.sql` to explore the cleaned data

> ⚠️ Always run the verification `SELECT` before each destructive operation (`DELETE` / `UPDATE`) in the cleaning script

---

## 💡 Key SQL Concepts Used

| Concept | Used In |
|---|---|
| `ALTER TABLE ... RENAME COLUMN` | Fixing BOM-corrupted column name |
| `ROW_NUMBER()` window function | Duplicate detection and removal |
| `GROUP BY` + `HAVING` | Aggregations and filtering by group size |
| Targeted `UPDATE` statements | Fixing state names, place, and type values |
| `INNER JOIN` across two tables | Combining geography and income data |
| `ROUND(AVG(...))` | Computing clean average income figures |
| Named column aliases | Readable output headers throughout |
| `ORDER BY` with named aliases | Reliable, readable sorting |
