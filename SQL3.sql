CREATE DATABASE portfolioproject;
USE portfolioproject;

DROP TABLE IF EXISTS coviddeaths;
CREATE TABLE CovidDeaths (
iso_code VARCHAR(20),
continent VARCHAR(50),
location VARCHAR(100),
date VARCHAR(20),
population VARCHAR(50),
total_cases VARCHAR(50),
new_cases VARCHAR(50),
new_cases_smoothed VARCHAR(50),
total_deaths VARCHAR(50),
new_deaths VARCHAR(50),
new_deaths_smoothed VARCHAR(50),
total_cases_per_million VARCHAR(50),
new_cases_per_million VARCHAR(50),
new_cases_smoothed_per_million VARCHAR(50),
total_deaths_per_million VARCHAR(50),
new_deaths_per_million VARCHAR(50),
new_deaths_smoothed_per_million VARCHAR(50),
reproduction_rate VARCHAR(50),
icu_patients VARCHAR(50),
icu_patients_per_million VARCHAR(50),
hosp_patients VARCHAR(50),
hosp_patients_per_million VARCHAR(50),
weekly_icu_admissions VARCHAR(50),
weekly_icu_admissions_per_million VARCHAR(50),
weekly_hosp_admissions VARCHAR(50),
weekly_hosp_admissions_per_million VARCHAR(50)
);


LOAD DATA LOCAL INFILE 'C:/Users/dell/OneDrive - Aakash Educational Services Ltd/Desktop/Covid_Deaths.csv'
INTO TABLE CovidDeaths
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(iso_code,
continent,
location,
date,
population,
total_cases,
new_cases,
new_cases_smoothed,
total_deaths,
new_deaths,
new_deaths_smoothed,
total_cases_per_million,
new_cases_per_million,
new_cases_smoothed_per_million,
total_deaths_per_million,
new_deaths_per_million,
new_deaths_smoothed_per_million,
reproduction_rate,
icu_patients,
icu_patients_per_million,
hosp_patients,
hosp_patients_per_million,
weekly_icu_admissions,
weekly_icu_admissions_per_million,
weekly_hosp_admissions,
weekly_hosp_admissions_per_million);

SELECT COUNT(*) FROM CovidDeaths;

SELECT * FROM coviddeaths;

ALTER TABLE CovidDeaths
MODIFY date DATE;

ALTER TABLE CovidDeaths
MODIFY population DOUBLE,
MODIFY total_cases DOUBLE,
MODIFY new_cases DOUBLE,
MODIFY total_deaths DOUBLE,
MODIFY new_deaths DOUBLE;

UPDATE CovidDeaths
SET total_cases = NULL
WHERE total_cases = '';

SELECT * FROM coviddeaths;

DROP TABLE IF EXISTS covidvaccinations;
CREATE TABLE CovidVaccinations (
iso_code VARCHAR(10),
continent VARCHAR(50),
location VARCHAR(100),
date DATE,

total_tests DOUBLE,
new_tests DOUBLE,
total_tests_per_thousand DOUBLE,
new_tests_per_thousand DOUBLE,
new_tests_smoothed DOUBLE,
new_tests_smoothed_per_thousand DOUBLE,
positive_rate DOUBLE,
tests_per_case DOUBLE,
tests_units VARCHAR(50),

total_vaccinations DOUBLE,
people_vaccinated DOUBLE,
people_fully_vaccinated DOUBLE,
total_boosters DOUBLE,
new_vaccinations DOUBLE,
new_vaccinations_smoothed DOUBLE,

total_vaccinations_per_hundred DOUBLE,
people_vaccinated_per_hundred DOUBLE,
people_fully_vaccinated_per_hundred DOUBLE,
total_boosters_per_hundred DOUBLE,
new_vaccinations_smoothed_per_million DOUBLE,

new_people_vaccinated_smoothed DOUBLE,
new_people_vaccinated_smoothed_per_hundred DOUBLE,

stringency_index DOUBLE,
population_density DOUBLE,
median_age DOUBLE,
aged_65_older DOUBLE,
aged_70_older DOUBLE,
gdp_per_capita DOUBLE,
extreme_poverty DOUBLE,
cardiovasc_death_rate DOUBLE,
diabetes_prevalence DOUBLE,
female_smokers DOUBLE,
male_smokers DOUBLE,
handwashing_facilities DOUBLE,
hospital_beds_per_thousand DOUBLE,
life_expectancy DOUBLE,
human_development_index DOUBLE,

excess_mortality_cumulative_absolute DOUBLE,
excess_mortality_cumulative DOUBLE,
excess_mortality DOUBLE,
excess_mortality_cumulative_per_million DOUBLE
);


LOAD DATA LOCAL INFILE 'C:/Users/dell/OneDrive - Aakash Educational Services Ltd/Desktop/Covid_Vaccination.csv'
INTO TABLE CovidVaccinations
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM CovidVaccinations;

ALTER TABLE CovidVaccinations
ADD INDEX idx_location_date (location, date);

SELECT * FROM covidvaccinations;

SELECT * 
FROM portfolioproject.coviddeaths
WHERE continent is null;

SELECT * 
FROM portfolioproject.coviddeaths
ORDER BY 3,4;

SELECT * 
FROM portfolioproject.covidvaccinations
ORDER BY 3,4;

-- SELECT DATA That we are going to be using

SELECT location,
       date,
       NULLIF(total_cases,0) AS total_cases,
       NULLIF(new_cases,0) AS new_cases,
       NULLIF(total_deaths,0) AS total_deaths,
       population
FROM portfolioproject.coviddeaths
ORDER BY 1,2;

-- Total Cases VS Total Deaths
-- Shows likelihood of dying if you are infected with covid

SELECT location,
       date,
       NULLIF(total_cases,0) AS total_cases,
       NULLIF(total_deaths,0) AS total_deaths,
       (total_deaths/total_cases)*100 as DeathPercentage
FROM portfolioproject.coviddeaths
ORDER BY 1,2;

SELECT location,
       date,
       NULLIF(total_cases,0) AS total_cases,
       NULLIF(total_deaths,0) AS total_deaths,
       (total_deaths/total_cases)*100 as DeathPercentage
FROM portfolioproject.coviddeaths
WHERE location="India"
ORDER BY 1,2;

SELECT location,
       date,
       NULLIF(total_cases,0) AS total_cases,
       NULLIF(total_deaths,0) AS total_deaths,
       (total_deaths/total_cases)*100 as DeathPercentage
FROM portfolioproject.coviddeaths
WHERE location like '%states%'
ORDER BY 1,2; 

-- Total cases vs Population
-- Shows what percentage of population get infected with covid

SELECT location,
       date,
       NULLIF(total_cases,0) AS total_cases,population,
       (total_cases/Population)*100 as CasePercentage
FROM portfolioproject.coviddeaths
-- WHERE location='India'
ORDER BY 1,2;  

-- Country with highest cases

SELECT location,
       MAX(total_cases) AS highestInfectionCount ,population,
       MAX((total_cases/Population))*100 as CasePercentage
FROM portfolioproject.coviddeaths
GROUP BY location,population
ORDER BY 4 DESC;  

-- Countries with highest Death Count per Population

SELECT location,
       MAX(cast(total_deaths as decimal)) AS highestDeathCount ,population,
       MAX((total_deaths/Population))*100 as DeathPercentage
FROM portfolioproject.coviddeaths
WHERE continent is not null
GROUP BY location,population
ORDER BY 2 DESC;

SELECT location,
       MAX(CAST(total_deaths AS FLOAT)) AS TotalDeathCount
FROM portfolioproject.coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Based on Continent 
SELECT Continent,
       MAX(CAST(total_deaths AS FLOAT)) AS TotalDeathCount
FROM portfolioproject.coviddeaths
WHERE continent IS NOT NULL
AND continent <> ''
GROUP BY continent
ORDER BY TotalDeathCount DESC;

SELECT continent,location,
       MAX(CAST(total_deaths AS FLOAT)) AS TotalDeathCount
FROM portfolioproject.coviddeaths
WHERE continent IS  NULL OR continent=''
GROUP BY continent,location
ORDER BY TotalDeathCount DESC;

-- SHOWING the continents with highest death Count

SELECT Continent,
       MAX(CAST(total_deaths AS FLOAT)) AS TotalDeathCount
FROM portfolioproject.coviddeaths
WHERE continent IS NOT NULL
AND continent <> ''
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Global Numbers

SELECT Date,SUM(CAST(new_cases AS FLOAT)) AS totalcases, SUM(CAST(new_deaths AS FLOAT)) as TotalDeaths,
(SUM(new_deaths)/SUM(new_cases))*100 AS NewDeathPercentage
FROM coviddeaths
WHERE COntinent <> ''
GROUP BY Date
ORDER BY date;

SELECT SUM(CAST(new_cases AS FLOAT)) AS totalcases, SUM(CAST(new_deaths AS FLOAT)) as TotalDeaths,
(SUM(new_deaths)/SUM(new_cases))*100 AS NewDeathPercentage
FROM coviddeaths
WHERE COntinent <> ''
ORDER BY date;

SELECT *
FROM covidvaccinations;

SELECT date,SUM(total_vaccinations),SUM(people_vaccinated),SUM(people_fully_vaccinated)
FROM covidvaccinations
WHERE continent <> ''
GROUP BY date
ORDER BY date;


-- LOOKING AT TOTAL POPULATIOn VS VACCINATIONS
SELECT DISTINCT dea.date,dea.continent,dea.location,dea.population,vacc.new_vaccinations,
SUM(CAST( vacc.new_vaccinations AS FLOAT )) OVER (PARTITION BY dea.location) AS RollingPeopleVaccinated
-- (RollingPeopleVaccinated/dea.population)*100 AS percentofpeoplevaccinated
FROM coviddeaths AS dea
JOIN covidvaccinations as vacc
ON dea.date=vacc.date
AND dea.location=vacc.location
WHERE dea.continent != ''
ORDER BY dea.location, dea.date;

SELECT *
FROM coviddeaths AS dea
JOIN covidvaccinations as vacc
ON dea.date=vacc.date
AND dea.location=vacc.location;

SELECT dea.continent,dea.location,dea.population,vacc.new_vaccinations,
SUM(CONVERT(vacc.new_vaccinations, FLOAT)) OVER (PARTITION BY dea.location)
FROM coviddeaths AS dea
JOIN covidvaccinations AS vacc
ON dea.location=vacc.location
ORDER BY dea.location;


USE portfolioproject;
SELECT DISTINCT dea.continent,
       dea.location,
       dea.date,
       dea.population,
       vacc.new_vaccinations,
       SUM(CONVERT(vacc.new_vaccinations, FLOAT)) 
       OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingVaccinations
FROM coviddeaths AS dea
JOIN covidvaccinations AS vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date;

SELECT * FROM coviddeaths LIMIT 10;

SELECT location, date, COUNT(*)
FROM covidvaccinations
GROUP BY location, date
HAVING COUNT(*) > 1;

-- USE CTE 
WITH PopVSVac (date,continent,location,population,new_vaccinations,RollingPeopleVaccinated)
AS
(
SELECT dea.date,dea.continent,dea.location,dea.population,vacc.new_vaccinations,
SUM(CAST( vacc.new_vaccinations AS FLOAT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
-- (RollingPeopleVaccinated/dea.population)*100 AS percentofpeoplevaccinated
FROM coviddeaths AS dea
JOIN covidvaccinations as vacc
ON  dea.location=vacc.location
AND dea.date=vacc.date
WHERE dea.continent <> ''
)
SELECT *, (RollingPeopleVaccinated/population)*100 AS percentofpeoplevaccinated
FROM popVSvac; 

-- using temp table

CREATE TEMPORARY TABLE PercentPeopleVaccinated
(
date DATE,continent VARCHAR(50),location VARCHAR(50),population BIGINT,new_vaccinations BIGINT, RollingPeopleVaccinated BIGINT
) ;
INSERT INTO PercentPeopleVaccinated
SELECT dea.date,dea.continent,dea.location,dea.population,vacc.new_vaccinations,
SUM(CAST( vacc.new_vaccinations AS FLOAT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
-- (RollingPeopleVaccinated/dea.population)*100 AS percentofpeoplevaccinated
FROM coviddeaths AS dea
JOIN covidvaccinations as vacc
ON  dea.location=vacc.location
AND dea.date=vacc.date
WHERE dea.continent <> '';

SELECT *, (RollingPeopleVaccinated/population)*100 AS percentofpeoplevaccinated
FROM PercentPeopleVaccinated; 

-- CREATE VIEW

CREATE VIEW PerPopVaccinated AS 
SELECT dea.date,dea.continent,dea.location,dea.population,vacc.new_vaccinations,
SUM(CAST( vacc.new_vaccinations AS FLOAT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
-- (RollingPeopleVaccinated/dea.population)*100 AS percentofpeoplevaccinated
FROM coviddeaths AS dea
JOIN covidvaccinations as vacc
ON  dea.location=vacc.location
AND dea.date=vacc.date
WHERE dea.continent <> '';
-- ORDER BY dea.location,dea.date;

SELECT * 
FROM perpopvaccinated
LIMIT 10;

