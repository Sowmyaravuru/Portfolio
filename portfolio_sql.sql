select * from 
portfolio_project . Coviddeaths
where continent is not null
order by 3,4;

/*select * from 
--portfolio_project . covidvaccinations
--order by 3,4*/
select location,date,total_cases,new_cases,total_deaths,population from 
portfolio_project . Coviddeaths
order by 1,2;
-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of death in covid affected patients in india
select location,date,total_cases,total_deaths,(total_deaths/total_cases) * 100 as DeathPercentage 
from 
portfolio_project . Coviddeaths
where location like '%india%'
order by 1,2;

-- Looking Total Cases Vs Population
-- Shows what percentage of population effected by Covid 
select location,date,population,total_cases,(total_cases/population) *100 as PercentagePopulationeffected
from 
portfolio_project . Coviddeaths
 where location like '%india%'
order by 1,2;

-- Looking at countries with highest infection rate compared to population
select location,population,Max(total_cases) as Highestinfectioncount,Max((total_cases/population)) *100 as HighlyEffected
from 
portfolio_project . Coviddeaths
group by location,population
order by HighlyEffected desc ;

-- Showing Countries with Highest Death Count per Population
select location,Max(total_deaths)  as Totaldeathcount
from 
portfolio_project . Coviddeaths
where continent is not null
group by location
order by Totaldeathcount desc ;

-- Let's break things down by continent
select continent,Max(total_deaths)  as Totaldeathcount
from 
portfolio_project . Coviddeaths
where continent is not null
group by continent
order by Totaldeathcount desc ;

-- Showing continents with the highest death count per population
select continent,Max(total_deaths)  as Totaldeathcount
from 
portfolio_project . Coviddeaths
where continent is not null
group by continent
order by Totaldeathcount desc ;

-- Global Numbers
select sum(new_cases),sum(new_deaths),sum(new_deaths)/sum(new_cases)*100 as deathpercentage
 from portfolio_project . Coviddeaths
-- where location like '%india%'
where continent is not null
-- group by date
order by 1,2;

-- Looking at Total Population Vs Vaccinations

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
-- , (Rollingpeoplevaccinated/population) * 100
from portfolio_project.	coviddeaths dea
join portfolio_project.covidvaccinations vac
     on dea.location=vac.location
     and dea.date=vac.date
where dea.continent is not null
order by 2,3;

with PopvsVac(continent,location,date,population,new_vaccinations, Rollingpeoplevaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(new_vaccinations) over (partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
from portfolio_project.	coviddeaths dea
join portfolio_project.covidvaccinations vac
     on dea.location=vac.location
     and dea.date=vac.date
where dea.continent is not null
order by 2,3
)
select* ,(Rollingpeoplevaccinated/Population)*100
from PopvsVac;

-- TempTable
DROP Table if exists PercentPopulationVaccinated;
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);









