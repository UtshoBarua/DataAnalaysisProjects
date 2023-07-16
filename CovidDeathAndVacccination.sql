select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject1.DeathData
order by 1,2;

/* 
Looking at Total cases vs Total Deaths
*/

select location,date,total_cases,new_cases,total_deaths,population, (total_deaths/total_cases)*100 as death_prcentage
from PortfolioProject1.DeathData
where location = 'Bangladesh'
order by 1,2;

#Looking at the total cases vs population 
#Shows what population got Covid
select location,date,total_cases,population, (total_cases/population)*100 as percentage_population_infected
from PortfolioProject1.DeathData
where location ='Bangladesh'
order by 1,2;

#Looking for the highest covid infected locations
select location,population,max(total_cases) as highest_infection_count, max(total_cases/population)*100 percentage_population_infected
from PortfolioProject1.DeathData

group by location,population
order by percentage_population_infected desc;

#Showing countries with highest death count per population
select location, max(total_deaths) as highest_death
from PortfolioProject1.DeathData
where continent is not null
group by location
order by highest_death desc;

#Breaking Things Down By Continent

#Showing highest death count by continent
select continent, max(total_deaths) as highest_death
from PortfolioProject1.DeathData
where continent is not null
group by continent
order by highest_death desc;

#Looking population vs people vaccinated
with PopVsVac ( continent, location, date, population, new_vaccinations,Rolling_people_vaccinated) 
as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) 
as Rolling_people_vaccinated
from DeathData dea
join VaccinationData vac
on dea.date = vac.date and dea.location=vac.location
where dea.continent is not null	
-- order by 2,3;
)

select *, (Rolling_people_vaccinated/population) *100 as Rolling_Vacinated_Percentage
from PopVsVac;

#Store the percentage of population for later
Create View PercentageOfPopulationVacccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) 
as Rolling_people_vaccinated
from DeathData dea
join VaccinationData vac
on dea.date = vac.date and dea.location=vac.location
where dea.continent is not null;

select * from PercentageOfPopulation
