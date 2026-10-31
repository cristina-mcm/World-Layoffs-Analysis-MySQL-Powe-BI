# World Layoffs Analysis and Power BI Dashboard

## Project Overview

This project analyzes reported company layoffs worldwide between 2020 and 2023. MySQL was used to clean and explore the data, and Power BI was used to create an interactive dashboard presenting the main findings.

## Dashboard

<img width="1574" height="885" alt="image" src="https://github.com/user-attachments/assets/a79125d8-5fdf-45b7-9578-f5555298921a" />

## Key Findings

- The dataset contains 383,659 reported layoffs across 1,628 companies.
- The largest single reported layoff event involved 12,000 employees.
- Reported layoffs accelerated during the second half of 2022 and reached their highest monthly level in early 2023.
- The United States accounted for the largest share of reported layoffs among the countries represented.
- Consumer and retail companies were among the industries with the highest reported layoffs.
- Amazon reported the highest cumulative layoffs at approximately 18,200, followed by Google at 12,000 and Meta at 11,000.
- Most companies among the top 10 were large technology or technology-related businesses, showing the sector’s significant role in the 2022–2023 increase.

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

## Repository Contents

- [Data](Data/)
  - [layoffs.csv](Data/layoffs.csv) — original dataset
  - [layoffs_cleaned.csv](Data/layoffs_cleaned.csv) — cleaned dataset used for analysis and visualization
- [world_layoffs_data_cleaning.sql](world_layoffs_data_cleaning.sql) — MySQL data-cleaning script
- [world_layoffs_data_exploration.sql](world_layoffs_data_exploration.sql) — exploratory SQL queries
- [world_layoffs_data_visualization.pbix](world_layoffs_data_visualization.pbix) — interactive Power BI dashboard

## Data Source

The original dataset was obtained from the [Layoffs 2022 dataset on Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022).

## Acknowledgement

This project began as a guided SQL project based on Alex The Analyst's Data Analyst Bootcamp tutorial. The Power BI dashboard was added independently to extend the analysis.
