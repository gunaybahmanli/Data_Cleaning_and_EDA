use world_layoffs;
select * from layoffs;

-- Data Cleaning

/* 1. Remove Duplicates
   2. Standardize the Data
   3. Null or blank values
   4. Remove any columns
*/

SELECT * INTO layoffs_cleaned
FROM layoffs
WHERE 1 = 0;

SELECT * FROM layoffs_cleaned;

INSERT layoffs_cleaned
SELECT * FROM layoffs;


-- IDENTIFYING AND REMOVING DUPLICATES

SELECT *,  
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, [date], stage, 
country, funds_raised_millions ORDER BY [date]) AS row_num
FROM layoffs_cleaned;


WITH duplicates_cte AS
(SELECT *,  
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, [date], stage, 
country, funds_raised_millions ORDER BY [date]) AS row_num
FROM layoffs_cleaned
)
SELECT * FROM duplicates_cte WHERE row_num > 1;


SELECT * INTO layoffs_cleaned2
FROM layoffs_cleaned
WHERE 1 = 0;

ALTER TABLE layoffs_cleaned2
ADD row_num INT;

INSERT INTO layoffs_cleaned2 (company, location, industry, total_laid_off, percentage_laid_off, 
[date], stage, country, funds_raised_millions, row_num)
SELECT company, location, industry, total_laid_off, percentage_laid_off, 
[date], stage, country, funds_raised_millions,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, [date], stage, 
country, funds_raised_millions 
 ORDER BY [date]
) AS row_num
FROM layoffs_cleaned;

DELETE FROM layoffs_cleaned2 WHERE row_num > 1;


-- STANDARDIZING DATA

-- 1. Removing white spaces in company column

SELECT company, TRIM(company) FROM layoffs_cleaned2;

UPDATE layoffs_cleaned2 SET company = TRIM(company);


-- 2. Matching fields with different spellings in the columnS

SELECT DISTINCT(industry) FROM layoffs_cleaned2 ORDER BY 1;

SELECT * FROM layoffs_cleaned2 WHERE industry LIKE 'Crypto%';

UPDATE layoffs_cleaned2 SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT(country) FROM layoffs_cleaned2 ORDER BY 1;

SELECT * FROM layoffs_cleaned2 WHERE country LIKE 'United States%' ORDER BY 1;

UPDATE layoffs_cleaned2
SET country = RTRIM(TRIM(TRAILING '.' FROM country))
WHERE country LIKE 'United States.%';


-- HANDLING NULL AND BLANK VALUES

SELECT * FROM layoffs_cleaned2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_cleaned2
WHERE industry IS NULL
OR industry =' ' ;

SELECT * FROM layoffs_cleaned2
WHERE company = 'Bally''s Interactive';

SELECT * FROM layoffs_cleaned2 t1
JOIN layoffs_cleaned2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = ' ')
AND t2.industry IS NOT NULL;

UPDATE t1
SET t1.industry = t2.industry
FROM layoffs_cleaned2 t1
INNER JOIN layoffs_cleaned2 t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL OR LTRIM(RTRIM(t1.industry)) = '')
AND t2.industry IS NOT NULL;


-- REMOVİNG UNUSELESS ROWS AND COLUMNS

DELETE FROM layoffs_cleaned2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_cleaned2
DROP COLUMN row_num;

SELECT * FROM layoffs_cleaned2;




-- Exploratory Data Analysis

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_cleaned2;

-- Looing at Percentage to see how big these layoffs were

SELECT MAX(percentage_laid_off), MIN(percentage_laid_off)
FROM layoffs_cleaned2
WHERE percentage_laid_off IS NOT NULL;

-- Which companies had 1 which is basically 100 percent of they company laid off

SELECT * 
FROM layoffs_cleaned2
WHERE percentage_laid_off = 1;

SELECT * 
FROM layoffs_cleaned2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Companies with the biggest single Layoff

SELECT TOP 5 company, total_laid_off
FROM layoffs_cleaned2
ORDER BY total_laid_off DESC;

-- Companies with the most total layoffs

SELECT TOP 10 company, SUM(total_laid_off)
FROM layoffs_cleaned2
GROUP BY company
ORDER BY 2 DESC;

-- by location

SELECT TOP 10 location, SUM(total_laid_off)
FROM layoffs_cleaned2
GROUP BY location
ORDER BY 2 DESC;

-- Total in the past 3 years or in the dataset

SELECT country, SUM(total_laid_off)
FROM layoffs_cleaned2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_cleaned2
GROUP BY YEAR(date)
ORDER BY 1 ASC;


SELECT industry, SUM(total_laid_off)
FROM layoffs_cleaned2
GROUP BY industry
ORDER BY 2 DESC;


SELECT stage, SUM(total_laid_off)
FROM layoffs_cleaned2
GROUP BY stage
ORDER BY 2 DESC;

-- The most layoffs per year

WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_cleaned2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

-- Rolling Total of Layoffs Per Month

SELECT LEFT(CONVERT(VARCHAR, date, 23), 7) AS dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_cleaned2
GROUP BY LEFT(CONVERT(VARCHAR, date, 23), 7)
ORDER BY dates ASC;


WITH DATE_CTE AS 
(
    SELECT LEFT(CONVERT(VARCHAR, date, 23), 7) AS dates, SUM(total_laid_off) AS total_laid_off
    FROM layoffs_cleaned2
    GROUP BY LEFT(CONVERT(VARCHAR, date, 23), 7)
)
SELECT dates, 
       SUM(total_laid_off) OVER (ORDER BY dates ASC) AS rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;



