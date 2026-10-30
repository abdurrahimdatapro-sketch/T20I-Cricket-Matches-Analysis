# T20I Cricket Matches Analysis | SQL Server

## Project Overview

This project analyzes T20 International (T20I) cricket match data using Microsoft SQL Server.

The objective is to explore team performance, match outcomes, winning margins, head-to-head records, and venue statistics through SQL queries.

The analysis focuses on answering practical cricket-related business questions and identifying meaningful insights from historical match data.

## Tools & Technologies

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- SQL

## Dataset

- Dataset: T20 International Cricket Matches
- Table: `dbo.T20I`
- File: `data/T20I.csv`

## Business Questions

This project explores the following questions:

1. Which team recorded the most wins in 2024?
2. Which team had the highest average winning margin in runs in 2024?
3. Which team had the highest average winning margin in wickets in 2024?
4. Which matches had winning margins above the average for their margin type?
5. Which team recorded the most wins when chasing a target?
6. What is the head-to-head record between England and Australia?
7. Which month in 2024 had the highest number of T20I matches?
8. How many matches did each team play in 2024, and what was its win percentage?
9. Which team was most successful at each ground?
10. How many matches did India play against South Africa in 2024?

## SQL Skills Demonstrated

- SELECT, WHERE, GROUP BY, ORDER BY
- Aggregate Functions: COUNT(), SUM(), AVG(), MAX()
- CASE Statements
- Common Table Expressions (CTEs)
- UNION ALL
- Window Functions: RANK()
- Date Filtering and Date Functions
- String Functions
- Conditional Aggregation

## Project Structure

- `data/` – Original T20I dataset.
- `sql/` – SQL queries used for the analysis.
- `README.md` – Project documentation.

## How to Run This Project

1. Download or clone this repository.
2. Open Microsoft SQL Server Management Studio (SSMS).
3. Import `data/T20I.csv` into SQL Server.
4. Create or use a table named `dbo.T20I` with the appropriate column structure.
5. Open `sql/SQLQuery3.sql`.
6. Execute the queries to reproduce the analysis.

## Key Findings

## Key Findings

Based on the analysis of 122 T20I matches played in 2024:

### 1. Team Performance
- India recorded the most wins with 22 victories.
- Australia followed with 15 wins.
- India achieved the highest win percentage at 84.62% (22 wins from 26 matches).

### 2. Winning Margins
- India recorded the highest average winning margin by runs at 55.73 runs.
- India also recorded the highest average winning margin by wickets at 7.29 wickets.

### 3. Match Trends
- June was the busiest month, with 36 matches played.
- India and England recorded the most wins when chasing a target, with 7 wins each.

### 4. Head-to-Head Analysis
- England and Australia played 3 matches against each other.
- Australia won 2 matches, while England won 1.

### 5. Venue Analysis
- Dambulla and Bridgetown hosted the most matches, with 8 matches each.
- Venue-level win analysis identified teams with the highest number of victories at individual grounds.

## Future Improvements

- Expand the analysis to cover additional years.
- Compare team performance across different grounds.
- Build an interactive Tableau or Power BI dashboard.
- Explore additional match trends and performance metrics.

