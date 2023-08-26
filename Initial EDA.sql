-- Looking at total cases vs total deaths

SELECT *
FROM [Portfolio Project]..covidDeaths
WHERE continent is not null
order by 3,4

SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as DeathPercentage
FROM [Portfolio Project]..covidDeaths
WHERE continent is not null
order by 1,2

-- Looking at total cases vs population (UK). Shows what percentage of people have had COVID. 
SELECT location, date, population, total_cases, total_deaths, (total_cases / population)*100 as infectedPercentage
FROM [Portfolio Project]..covidDeaths
WHERE location = 'United Kingdom'
and continent is not null
order by 1,2

-- What countries have the highest infection rates (compared to population)
SELECT location, population, MAX(total_cases) as highestInfectionCount, MAX((total_cases / population))*100 as PercentPopulationInfected
FROM [Portfolio Project]..covidDeaths
WHERE continent is not null
Group by Location, Population
order by PercentPopulationInfected DESC


-- To show countries with the highest death rates

SELECT location, MAX(total_deaths) AS totalDeathCount
FROM [Portfolio Project]..covidDeaths
WHERE continent is not null
Group by location
order by totalDeathCount DESC

-- Showing continents with the highest death counts
SELECT continent, MAX(total_deaths) AS totalDeathCount
FROM [Portfolio Project]..covidDeaths
WHERE continent is not null
Group by continent
order by totalDeathCount DESC



-- Global numbers

SELECT SUM(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(cast(new_deaths as int))  / sum(new_cases)*100 as deathPercentage
FROM [Portfolio Project]..covidDeaths
WHERE continent is not null
order by 1,2


--Join vaccination data and death data
-- Looking at total population vs total vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as rolling_ppl_vaccinated,
(rolling_ppl_vaccinated / population)*100
FROM [Portfolio Project]..covidDeaths dea
Join [Portfolio Project]..covidVaccinations vac
On dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3


--CTE

With pop_vs_vac (Continent, location, date, population, new_vaccinations,rolling_ppl_vaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.location Order by dea.location, dea.date) as rolling_ppl_vaccinated
--(rolling_ppl_vaccinated / population)*100
FROM [Portfolio Project]..covidDeaths dea
Join [Portfolio Project]..covidVaccinations vac
On dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null
)
SELECT *, (rolling_ppl_vaccinated /population)*100 as rolling_ppl_vaccinated_percent
FROM pop_vs_vac

-- TEMP TABLE

DROP Table IF exists #percentPopulationVaccinated
CREATE Table #percentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population bigint,
new_vaccinations numeric,
rollingPeopleVaccinated numeric
)


INSERT into #percentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.location Order by dea.location, dea.date) as rolling_ppl_vaccinated
--(rolling_ppl_vaccinated / population)*100
FROM [Portfolio Project]..covidDeaths dea
Join [Portfolio Project]..covidVaccinations vac
On dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null

SELECT *, (rollingPeopleVaccinated /population)*100
From #percentPopulationVaccinated

-- Creating a view to store data for Tableau visualiastions

Create View percentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.location Order by dea.location, dea.date) as rolling_ppl_vaccinated
--(rolling_ppl_vaccinated / population)*100
FROM [Portfolio Project]..covidDeaths dea
Join [Portfolio Project]..covidVaccinations vac
On dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null

Select *
From percentPopulationVaccinated