--Q1 Identify matches played between two specific teams (e.g., India and South Africa) in 2024 and their results.

SELECT MatchDate, Team1, Team2, Winner, Margin, Ground
FROM dbo.T20I
WHERE ((Team1 = 'India' AND Team2 = 'South Africa')
    OR (Team1 = 'South Africa' AND Team2 = 'India'))
  AND MatchDate >= '2024-01-01' AND MatchDate < '2025-01-01'
ORDER BY MatchDate;


--Q2 Find the team with the highest number of wins in 2024 and the total matches it won.

SELECT TOP 1 Winner AS Team,
       COUNT(*)  AS Total_Wins
FROM dbo.T20I
WHERE MatchDate >= '2024-01-01' AND MatchDate < '2025-01-01'
  AND Winner NOT IN ('tied', 'no result')
GROUP BY Winner
ORDER BY Total_Wins DESC;


--Q3 Rank the teams based on the total number of wins in 2024.

SELECT RANK() OVER (ORDER BY COUNT(*) DESC) AS Team_Rank,
       Winner                               AS Team,
       COUNT(*)                             AS Total_Wins
FROM dbo.T20I
WHERE MatchDate >= '2024-01-01' AND MatchDate < '2025-01-01'
  AND Winner NOT IN ('tied', 'no result')
GROUP BY Winner
ORDER BY Team_Rank, Team;


--Q4 Which team had the highest average winning margin (in runs), and what was the average margin?

WITH run_wins AS (
    SELECT Winner,
           TRY_CAST(LEFT(Margin, CHARINDEX(' ', Margin + ' ') - 1) AS INT) AS Margin_Runs
    FROM dbo.T20I
    WHERE MatchDate >= '2024-01-01' AND MatchDate < '2025-01-01'
      AND Margin LIKE '% run%'
      AND Winner NOT IN ('tied', 'no result')
)
SELECT TOP 1
       Winner AS Team,
       COUNT(*) AS Wins_By_Runs,
       CAST(AVG(CAST(Margin_Runs AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS Avg_Winning_Margin_Runs
FROM run_wins
GROUP BY Winner
ORDER BY Avg_Winning_Margin_Runs DESC;

--Q4.1 Which team had the highest average winning margin (in wickets), and what was the average margin?

WITH wicket_wins AS (
    SELECT Winner,
           TRY_CAST(LEFT(Margin, CHARINDEX(' ', Margin + ' ') - 1) AS INT) AS Margin_Wickets
    FROM dbo.T20I
    WHERE MatchDate >= '2024-01-01' AND MatchDate < '2025-01-01'
      AND Margin LIKE '% wicket%'
      AND Winner NOT IN ('tied', 'no result')
)
SELECT TOP 1
       Winner AS Team,
       COUNT(*) AS Wins_By_Wickets,
       CAST(AVG(CAST(Margin_Wickets AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS Avg_Winning_Margin_Wickets
FROM wicket_wins
GROUP BY Winner
ORDER BY Avg_Winning_Margin_Wickets DESC;


--Q5 List all matches where the winning margin was greater than the average margin across all matches.

WITH parsed AS (
    SELECT MatchDate, Team1, Team2, Winner, Margin, Ground,
           CASE WHEN Margin LIKE '% run%'    THEN 'Runs'
                WHEN Margin LIKE '% wicket%' THEN 'Wickets'
           END AS Margin_Type,
           TRY_CAST(LEFT(Margin, CHARINDEX(' ', Margin + ' ') - 1) AS INT) AS Margin_Value
    FROM dbo.T20I
    WHERE MatchDate >= '2024-01-01' AND MatchDate < '2025-01-01'
      AND Winner NOT IN ('tied', 'no result')
),
with_avg AS (
    SELECT *,
           AVG(CAST(Margin_Value AS DECIMAL(10,2))) OVER (PARTITION BY Margin_Type) AS Avg_Margin
    FROM parsed
    WHERE Margin_Type IS NOT NULL
)
SELECT MatchDate, Team1, Team2, Winner, Margin, Margin_Type, Ground,
       CAST(Avg_Margin AS DECIMAL(10,2)) AS Avg_Margin_For_Type
FROM with_avg
WHERE Margin_Value > Avg_Margin
ORDER BY Margin_Type, Margin_Value DESC, MatchDate;


--Q6 Find the team with the most wins when chasing a target (wins by wickets)

SELECT TOP 1 WITH TIES
       Winner AS Team,
       COUNT(*) AS Wins_While_Chasing
FROM dbo.T20I
WHERE MatchDate >= '2024-01-01' AND MatchDate < '2025-01-01'
  AND Margin LIKE '% wicket%'
  AND Winner NOT IN ('tied', 'no result')
GROUP BY Winner
ORDER BY Wins_While_Chasing DESC;


--Q7 Head-to-head record between two selected teams (e.g., England vs Australia).

DECLARE @TeamA VARCHAR(50) = 'England';
DECLARE @TeamB VARCHAR(50) = 'Australia';

SELECT @TeamA AS Team_A,
       @TeamB AS Team_B,
       COUNT(*) AS Matches_Played,
       SUM(CASE WHEN Winner = @TeamA THEN 1 ELSE 0 END) AS Team_A_Wins,
       SUM(CASE WHEN Winner = @TeamB THEN 1 ELSE 0 END) AS Team_B_Wins,
       SUM(CASE WHEN Winner NOT IN (@TeamA, @TeamB) THEN 1 ELSE 0 END) AS Tied_Or_No_Result
FROM dbo.T20I
WHERE (Team1 = @TeamA AND Team2 = @TeamB)
   OR (Team1 = @TeamB AND Team2 = @TeamA);


--Q8 Identify the month in 2024 with the highest number of T20I matches played.

SELECT TOP 1 WITH TIES
       DATENAME(MONTH, MatchDate) AS Month_Name,
       MONTH(MatchDate)           AS Month_Number,
       COUNT(*)                   AS Matches_Played
FROM dbo.T20I
WHERE MatchDate >= '2024-01-01' AND MatchDate < '2025-01-01'
GROUP BY DATENAME(MONTH, MatchDate), MONTH(MatchDate)
ORDER BY Matches_Played DESC;


--Q9 For each team, find how many matches they played in 2024 and their win percentage.

WITH team_matches AS (
    SELECT Team1 AS Team, Winner
    FROM dbo.T20I
    WHERE MatchDate >= '2024-01-01' AND MatchDate < '2025-01-01'
    UNION ALL
    SELECT Team2 AS Team, Winner
    FROM dbo.T20I
    WHERE MatchDate >= '2024-01-01' AND MatchDate < '2025-01-01'
)
SELECT Team,
       COUNT(*) AS Matches_Played,
       SUM(CASE WHEN Winner = Team THEN 1 ELSE 0 END) AS Wins,
       CAST(100.0 * SUM(CASE WHEN Winner = Team THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,2)) AS Win_Percentage
FROM team_matches
GROUP BY Team
ORDER BY Win_Percentage DESC, Matches_Played DESC;



--Q10 Identify the most successful team at each ground (team with most wins per ground).

WITH ground_wins AS (
    SELECT Ground,
           Winner AS Team,
           COUNT(*) AS Wins
    FROM dbo.T20I
    WHERE MatchDate >= '2024-01-01' AND MatchDate < '2025-01-01'
      AND Winner NOT IN ('tied', 'no result')
    GROUP BY Ground, Winner
),
ranked AS (
    SELECT Ground, Team, Wins,
           RANK() OVER (PARTITION BY Ground ORDER BY Wins DESC) AS rnk
    FROM ground_wins
)
SELECT Ground, Team, Wins
FROM ranked
WHERE rnk = 1
ORDER BY Wins DESC, Ground, Team;



