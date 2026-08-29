-- Data Cleaning

SELECT * FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any Columns - use with caution

-- CREATE A SIMILAR TABLE, SO WE DON'T DELETE IMPORTANT DATA FROM THE ORIGINAL - best practice

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT layoffs_staging
SELECT * FROM layoffs;

-- 1. Remove Duplicates

-- CHECK FOR DUPLICATES (IF ROW_NUM IS 2, IT IS A DUPLICATE)

WITH duplicate_CTE as
(
SELECT * ,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) as row_num
FROM layoffs_staging
)
SELECT * FROM duplicate_CTE
WHERE row_num > 1;

-- CREATE A TABLE THAT HAS AN EXTRA COLUMN: ROW_NUM:

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_staging2;

-- INSERT THE DATA IN THE NEW TABLE:

INSERT INTO layoffs_staging2
SELECT * ,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) as row_num
FROM layoffs_staging;

-- THE NEW TABLE:
SELECT * FROM layoffs_staging2;

-- CHECK FOR DUPLICATES:
SELECT * FROM layoffs_staging2
WHERE row_num > 1;

-- DELETE THE DUPLICATES
-- Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.
-- To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.
-- OR RUN SET SQL_SAFE_UPDATES = 0;  THEN THE DELETE CODE AND THEN SET SQL_SAFE_UPDATES = 1; 

SET SQL_SAFE_UPDATES = 0; 

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 1;

-- 2. Standardize the Data

-- Delete spaces

-- Set safe mode off (Edit, Preferences, SQL Editor, scroll down and uncheck safe mode)
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Group together Crypto industry

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1; -- run this again afte updating to check if the update worked

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

update layoffs_staging2
set industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- now check every column and see if you can spot issues

SELECT *
FROM layoffs_staging2;

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1; -- looks OK

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1; -- found an issue with United States

-- You can use a code similar to the previous one:

-- update layoffs_staging2
-- set country = 'United States'
-- WHERE country LIKE '%States%';

-- OR 

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE '%States%';

-- CHANGE the date format and data type

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y'); -- changes the date format

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE; -- changes the data type from text to date


-- 3. Null Values or blank values

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1; -- we have NULL and missing values

SELECT *
FROM layoffs_staging2
where total_laid_off IS NULL
and percentage_laid_off is null;

-- INDUSTRY COLUMN

-- change the blanks to NULL

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = ''; -- change the blanks to NULL first, otherwise the update won't work

SELECT DISTINCT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''; -- make sure the blanks are gone

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb'; -- notice that we coould populate the blank from another entry for industry (Travel)

-- Populate NULLs for the industry column

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '') -- or blank is not neccesary because we changed blanks to null
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- FUNDS RAISED MILLIONS - we could populate from the internet, but not for this project
-- We can't populate other columns/rows because of unknown values


-- 4. Remove Any Columns or Rows

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; -- useless for calculations, so need to delete


DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num; -- we used this column to find duplicates, so we don't need it anymore



