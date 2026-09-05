# World Layoffs Analysis and Power BI Dashboard

## Project Overview

This project analyzes reported company layoffs worldwide between 2020 and 2023. MySQL was used to clean and explore the data, and Power BI was used to create an interactive dashboard presenting the main findings.

## Dashboard

<img width="1574" height="885" alt="image" src="https://github.com/user-attachments/assets/a79125d8-5fdf-45b7-9578-f5555298921a" />

## Data Cleaning

The cleaning process included:

- Creating a staging table to preserve the original data
- Identifying and removing duplicate records
- Standardizing company, industry, and country names
- Removing unnecessary spaces with `TRIM()`
- Converting the date column from text to the `DATE` data type
- Replacing blank values with `NULL`
- Populating missing industry values where matching company information was available
- Removing records without reported layoff totals or percentages
- Removing temporary columns used during cleaning

## Exploratory Data Analysis

The SQL analysis examined:

- Total reported layoffs by company
- Total reported layoffs by country and industry
- Layoff trends by year and month
- Companies reporting the largest layoffs
- Companies reporting their entire workforce laid off
- Rolling monthly layoff totals
- The five companies with the highest reported layoffs each year

## Power BI Dashboard

The dashboard includes:

- Total reported layoffs
- Largest single reported layoff event
- Number of companies represented
- Reported layoffs by country
- Monthly reported layoffs from 2020 to 2023
- Top 10 companies by reported layoffs
- Reported layoffs by industry
- Interactive filters for year, country, and industry

## Data Source

The original dataset was obtained from the [Layoffs 2022 dataset on Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022).

## Acknowledgement

This project began as a guided SQL project based on Alex The Analyst's Data Analyst Bootcamp tutorial. The Power BI dashboard was added independently to extend the analysis.
