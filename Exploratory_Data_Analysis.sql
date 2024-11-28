-- Exploratory Data Analysis 
SELECT * 
FROM layoffs_staging2; 

-- Aggregate Functions
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2; 

SELECT * 
FROM layoffs_staging2 
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC
; 

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2 
GROUP BY company 
ORDER BY 2 desc;

-- LAID OFF DATES
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- PER YEAR LAID OFF
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2 
GROUP BY YEAR(`date`) 
ORDER BY 1 desc;

-- Laid Off By Company
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2 
GROUP BY company 
ORDER BY 2 desc;

-- Rolling Sum
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1,7 ) AS `MONTH`, SUM(total_laid_off) AS total_off -- PER MONTH 
FROM layoffs_staging2 
WHERE SUBSTRING(`date`, 1,7 ) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, 
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total; 

-- RANKING 
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company,YEAR(`date`),  SUM(total_laid_off)
FROM layoffs_staging2 
GROUP BY company,YEAR(`date`) 
), 
Company_Year_Rank AS (
SELECT * , DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5; 








 
