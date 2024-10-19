--Create a database named "Cleaning"
CREATE DATABASE Cleaning;
--Exploring the data
SELECT * FROM Uncleaned_DataScience_jobs;

--Make a copy of the data as a safe practice
SELECT * INTO DataScience_Jobs FROM Uncleaned_DataScience_jobs;

SELECT * FROM DataScience_Jobs;

-- Exploring job_title column
SELECT DISTINCT Job_Title
FROM DataScience_Jobs;

--Separate name of states from city in the location column
SELECT Location,
		SUBSTRING (Location, 1, CHARINDEX(',' , Location)) AS City,
		SUBSTRING (Location, CHARINDEX(',', Location) +2, LEN(Location) ) AS State
FROM DataScience_Jobs;

SELECT * FROM DataScience_Jobs;

-- Create New columns named City and State, and populate them
		-- For City
ALTER TABLE DataScience_Jobs
ADD City VARCHAR(MAX);

-- For State
ALTER TABLE DataScience_Jobs
ADD State VARCHAR(MAX)

--Populate City
UPDATE DataScience_Jobs
SET City = SUBSTRING (Location, 1, CHARINDEX(',' , Location));

--Populate State
UPDATE DataScience_Jobs
SET State = SUBSTRING (Location, CHARINDEX(',', Location) +2, LEN(Location));


SELECT * FROM DataScience_Jobs;

--Replace 'to' with '-' in the size column
UPDATE DataScience_Jobs
SET Size = REPLACE(Size, 'to', '-');

-- Also in SIze column, replace all '-1' with 1-50 employees
UPDATE DataScience_Jobs
SET Size = REPLACE(Size, '-1', '1-50 employees');

SELECT * FROM DataScience_Jobs;

--Explore Founded column
-- Retrieve the lenght of all values in Founded column
SELECT Founded, LEN(CAST(Founded AS NVARCHAR(MAX))) AS length
FROM DataScience_Jobs
ORDER BY length;-- many values are -1, which is wrong

-- Group the years 
SELECT DISTINCT Founded, COUNT(*) AS year_count
FROM DataScience_Jobs
GROUP BY Founded
ORDER BY year_count DESC; -- 118 values are -1

--Replacing -1 with unknown
UPDATE DataScience_Jobs
SET Founded = REPLACE(Founded, -1, 0)

SELECT * FROM DataScience_Jobs

-- Explore salary Estimate
--remove (Glassdoor est.) and (Employer est.)

UPDATE DataScience_Jobs
SET Salary_Estimate = REPLACE(Salary_Estimate, '( Glassdoor est. )', '');

UPDATE DataScience_Jobs
SET Salary_Estimate = REPLACE(Salary_Estimate, '( Employer est. )', '');

--Replace '-1' with NIL in Industry column
UPDATE DataScience_Jobs
SET Industry = REPLACE(Industry, '-1', 'NIL');

--Replace '-1' with 'Unknown' in Type_of_ownership column
UPDATE DataScience_Jobs
SET Type_of_ownership = REPLACE(Type_of_ownership, '-1', 'Unknown');

SELECT * FROM DataScience_Jobs;

--Replace 'to' with '-' in the Revenue column
UPDATE DataScience_Jobs
SET Revenue = REPLACE (Revenue, 'to', '-');

--Replace '-1' with 'Unknown / Non-Applicable' in the Revenue column
UPDATE DataScience_Jobs
SET Revenue = REPLACE (Revenue, '-1', 'Unknown / Non-Applicable');


SELECT Revenue, COUNT (*) Rev_Count
FROM DataScience_Jobs
GROUP BY Revenue
ORDER BY Rev_Count DESC;

SELECT * FROM DataScience_Jobs;

SELECT Company_Name,Competitors
FROM DataScience_Jobs

UPDATE DataScience_Jobs
SET Competitors = REPLACE (Competitors, '-1', 'Unknown');

--Create a view to contain only the tables relevant to our analysis
CREATE VIEW DS_view AS
SELECT Job_Title, Salary_Estimate, Rating, Company_Name, City, State, Size, Type_of_ownership, Industry, Sector, Revenue
FROM DataScience_Jobs;

SELECT * FROM DS_view;

SELECT Sector, COUNT (*) Sect_Count
FROM DS_view
GROUP BY Sector
ORDER BY Sect_Count DESC;

UPDATE DS_view
SET Sector = REPLACE (Sector, '-1', 'Unknown')


--ANALYSIS BEGINS

-- Vacancy by Job Title i.e job with the highest vacancy

SELECT TOP 10 Job_Title, COUNT (*) JT_Count
FROM DS_view
GROUP BY Job_Title
ORDER BY JT_Count DESC;

SELECT * FROM DS_view;

-- Vacancy by Job rating
SELECT
		CASE
			WHEN Rating < 2.5 THEN 'Low-rated'
			WHEN Rating BETWEEN 2.5 AND 4.0 THEN 'Mid-rated'
			ELSE 'Highly-rated'
		END AS Rating_category,
		COUNT(*) AS Rating_count
FROM DS_view
GROUP BY CASE
			WHEN Rating < 2.5 THEN 'Low-rated'
			WHEN Rating BETWEEN 2.5 AND 4.0 THEN 'Mid-rated'
			ELSE 'Highly-rated'
		END
ORDER BY Rating_count DESC;

--Vacancy by State
SELECT TOP 10 State,
		COUNT(*) AS State_count
FROM DS_view
GROUP BY State
ORDER BY State_count DESC;

--Vacancy by Company's Employee size
SELECT TOP 10 Size,
		COUNT(*) AS Company_Size_count
FROM DS_view
WHERE Size != 'Unknown'
GROUP BY Size
ORDER BY Company_Size_count DESC;

-- Vacancy by industry
SELECT TOP 10 Industry,
		COUNT(*) AS industry_count
FROM DS_view
WHERE Industry != 'NIL'
GROUP BY Industry
ORDER BY industry_count DESC;

SELECT * FROM DS_view;

-- Vacancy by Sector
SELECT TOP 10 Sector,
		COUNT(*) AS Sector_count
FROM DS_view
WHERE Sector != 'Unknown'
GROUP BY Sector
ORDER BY Sector_count DESC;
