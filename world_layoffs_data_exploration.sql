-- EXPLORATORY DATA ANALYSIS
-- Explore reported global layoffs between 2020 and 2023.

-- Preview the cleaned dataset.
SELECT *
FROM layoffs_staging2;

-- Identify the largest single layoff event and largest reported layoff percentage.
SELECT max(total_laid_off), max(percentage_laid_off)
FROM layoffs_staging2; -- The largest reported single layoff event affected 12,000 employees.

-- Find companies that reported laying off 100% of their workforce.
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 -- A value of 1 means 100% of the workforce was laid off, meaning that the company probably closed.
ORDER BY total_laid_off DESC;

-- Examine fully laid-off companies based on previously reported funding.
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC; -- Some companies raised substantial funding before reporting 100% layoffs.

-- Calculate total reported layoffs by company.
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC; -- Amazon, Google, and Meta had the highest reported layoff totals.

-- Identify the date range covered by the dataset.
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2; -- The dataset covers records from 2020 through 2023.

-- Calculate total reported layoffs by industry.
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC; -- Consumer, Retail, Transportation, Finance and Healthcare had
-- some of the highest reported layoff totals.

-- Calculate total reported layoffs by country.
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC; -- The United States had the highest reported total, followed by
-- countries including India, the Netherlands, Sweden, and Brazil.

-- Compare reported layoffs by year.
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
WHERE `date` IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY 1 DESC; -- Most of the layoffs are from 2023.

-- Compare reported layoffs by company stage.
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC; -- The companies with the most layoffs were in the Post-IPO stage.
-- The post-IPO stage is the operational phase where a company functions as a publicly-traded entity
-- on a stock exchange after completing its Initial Public Offering.

-- Compare layoffs by calendar month across all years combined.
SELECT SUBSTRING(`date`, 6, 2) AS `month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 6, 2) IS NOT NULL
GROUP BY `month`
ORDER BY 2 DESC; -- Most layoffs were made in January.

-- Calculate reported layoffs for each year-month period.
SELECT SUBSTRING(`date`, 1, 7) AS `year-month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `year-month`
ORDER BY 1 ASC;

-- -- Calculate monthly layoffs and a cumulative rolling total.
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `year-month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `year-month`
ORDER BY 1 ASC
)
SELECT `year-month`, total_off, SUM(total_off) OVER (ORDER BY `year-month`) AS rolling_total
FROM Rolling_Total;

-- Calculate each company's reported layoffs by year.
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;

-- Rank companies by total reported layoffs within each year and return the five highest ranks.
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`),  SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE ranking <= 5; -- DENSE_RANK includes ties, so a year may return more than five companies.