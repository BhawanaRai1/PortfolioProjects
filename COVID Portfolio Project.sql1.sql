/*
Covid 19 Data Exploration

Skills used : Joins, CTE'S, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


select *
from PortfolioProject..CovidDeaths$
Where continent is not null
Order by 3,4 ;

--Select Data that we are going to be starting with

SELECT location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths$
Where continent is not null
ORDER BY 1,2;

--Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/ total_cases)* 100 as DealthPercentage
FROM PortfolioProject..CovidDeaths$
WHERE location like 'Nepal'
AND continent is not null
ORDER BY 1,2;


--Total Cases vs Population
--Shows what percentage of population infected with Covid
Select location, date, population, total_cases, (total_cases/ population) * 100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths$
Order by 1,2;

--Countries with Highest Infection Rate compared to Population

Select location, population, Max (total_cases) AS HighestInfectionCount, Max (total_cases/ population) * 100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths$
Group by location, population
Order by PercentPopulationInfected DESC;

--Countries with Highest Death Count Per Population
Select location, Max (Cast (total_deaths as INT)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by location
Order by TotalDeathCount DESC;

-- BREAKING THINGS DOWN BY CONTINENT

--Showing continents with the highest death count per population

Select continent, Max (Cast (total_deaths as INT)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by continent
Order by TotalDeathCount DESC;

--Continent with Highest Infection Rate compared to Population

Select continent, population, Max (total_cases) AS HighestInfectionCount, Max (total_cases/ population) * 100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by continent, population
Order by PercentPopulationInfected DESC;

--GLOBAL NUMBERS


Select date, SUM (new_cases) as total_cases, SUM (CAST (new_deaths AS Int)) as total_deaths, SUM (Cast(new_deaths as Int))/ SUM (new_cases) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by date
Order by 1,2;

Select SUM (new_cases) as total_cases, SUM (CAST (new_deaths AS Int)) as total_deaths, SUM (Cast(new_deaths as Int))/ SUM (new_cases) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where continent is not null
Order by 1,2;


--Total Population vs Vaccinations
--Showing Percentage of population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM (CONVERT(int, vac.new_vaccinations)) OVER ( Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location =vac.location
     And dea.date= vac.date
Where dea.continent is not null
Order by 2,3;

--Using CTE to Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population,New_vaccination, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM (CONVERT(int, vac.new_vaccinations)) OVER ( Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location =vac.location
     And dea.date= vac.date
Where dea.continent is not null
)

Select *, (RollingPeopleVaccinated/Population)*100 as PeopleVaccinatedPercentage
From PopvsVac;



--TEMP TABLE


     And dea.date= vac.date
Where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100 as PeopleVaccinatedPercentage
From #PercentagePopulationVaccinated;


--Creating view to store data for later visualizationsDROP Table if exists #PercentPopulationVaccinated
Create TablE #PercentagePopulationVaccinated
(Continent nvarchar (300),
Location nvarchar (300),
Date date,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric)


Insert into #PercentagePopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (CONVERT(int, vac.new_vaccinations)) OVER ( Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location =vac.location

Create View PercentagePopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM (CONVERT(int, vac.new_vaccinations)) OVER ( Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location =vac.location
     And dea.date= vac.date


	 select *
	 from PercentagePopulationVaccinated;
Where dea.continent is not null