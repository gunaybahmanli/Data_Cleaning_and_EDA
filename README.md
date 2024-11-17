This project involves cleaning and analyzing a dataset of global layoffs to uncover insights about trends, industries, and companies affected by workforce reductions. Key tasks include removing duplicates, standardizing data formats, handling missing values, and performing exploratory data analysis (EDA) to identify significant patterns and trends.

# Layoffs Data Cleaning and Analysis Project

## Overview
This project focuses on analyzing a dataset of global layoffs (`world_layoffs`) to uncover trends and insights about workforce reductions. The project leverages SQL for data cleaning, transformation, and exploratory data analysis (EDA).

## Objectives
1. Clean and prepare the dataset for analysis:
   - Remove duplicates.
   - Standardize data formats (e.g., trim white spaces, resolve inconsistent values).
   - Handle null and blank values.
   - Drop unnecessary columns and rows.

2. Conduct exploratory data analysis:
   - Identify companies and locations most affected by layoffs.
   - Analyze layoffs by industry, stage, and country.
   - Investigate layoffs by year and rolling monthly totals.

## Data Cleaning Steps
1. **Duplicate Removal**: Identified and removed duplicate rows based on key attributes like `company`, `location`, and `date`.
2. **Data Standardization**:
   - Trimmed whitespace in text columns.
   - Resolved inconsistencies in fields like `industry` and `country`.
3. **Handling Null Values**:
   - Filled missing `industry` values using matching company data.
   - Removed rows with missing critical fields like `total_laid_off`.
4. **Dropping Unnecessary Columns**: Removed helper columns (e.g., `row_num`) after cleaning.

## Exploratory Data Analysis
1. **Trends by Company and Industry**:
   - Identified companies with the largest layoffs.
   - Analyzed total layoffs by industry and company stages.
2. **Geographic Analysis**:
   - Layoffs by country and location.
3. **Temporal Trends**:
   - Layoffs by year and rolling monthly totals.
4. **Percentage Analysis**:
   - Companies with 100% workforce layoffs.

## Key Insights
- Industries most affected by layoffs.
- Geographic regions with the highest layoff counts.
- Temporal trends in layoffs over time.
- Companies with significant layoff events.

## Tools Used
- **SQL Server Management Studio (SSMS)** for data cleaning and analysis.
