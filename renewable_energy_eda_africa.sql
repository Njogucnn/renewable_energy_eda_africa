## Which African countries have seen the highest increase in total renewable energy production between 2000 and 2023
SELECT tr2023.`ï»¿country` AS country_name,
		tr2023.total_renewables AS renewables_2023,
        tr2000.total_renewables AS renewables_2000,
        (tr2023.total_renewables - tr2000.total_renewables) AS renewables_increase
FROM renewable_energy_clean tr2000 
JOIN renewable_energy_clean tr2023
ON tr2000.`ï»¿country` = tr2023.`ï»¿country`
JOIN african_countries_with_regions
ON tr2023.`ï»¿country` = african_countries_with_regions.country
WHERE tr2023.year = 2023 AND
tr2000.year =2000 AND
african_countries_with_regions.continent = 'Africa'
ORDER BY renewables_increase DESC;

## Which African countries had the largest growth in hydro power generation from 2000 to 2023?
SELECT
    ts2023.`ï»¿country` AS country_name,
    ts2000.hydro AS hydro_2000,
    ts2023.hydro AS hydro_2023,
    (ts2023.hydro - ts2000.hydro) AS difference_hydro
FROM renewable_energy_clean ts2000 
JOIN renewable_energy_clean ts2023
    ON ts2000.`ï»¿country` = ts2023.`ï»¿country`
JOIN african_countries_with_regions 
    ON ts2023.`ï»¿country` = african_countries_with_regions.country
WHERE 
    ts2000.year = 2000 AND
    ts2023.year = 2023 AND
    african_countries_with_regions.continent = 'Africa'
ORDER BY difference_hydro DESC;

## Which African countries had the largest growth in solar power generation from 2000 to 2023?
SELECT 
    ts2023.`ï»¿country` AS country_name,
    ts2000.solar AS solar_2000,
    ts2023.solar AS solar_2023,
    (ts2023.solar - ts2000.solar) AS difference_solar
FROM renewable_energy_clean ts2000 
JOIN renewable_energy_clean ts2023
    ON ts2000.`ï»¿country` = ts2023.`ï»¿country`
JOIN african_countries_with_regions 
    ON ts2023.`ï»¿country` = african_countries_with_regions.country
WHERE 
    ts2000.year = 2000 AND
    ts2023.year = 2023 AND
    african_countries_with_regions.continent = 'Africa'
ORDER BY difference_solar DESC;

## Which African countries had the largest growth in wind power generation from 2000 to 2023?
SELECT 
    ts2023.`ï»¿country` AS country_name,
 ts2000.wind AS wind_2000,
    ts2023.wind AS wind_2023,
    (ts2023.wind - ts2000.wind) AS difference_wind
FROM renewable_energy_clean ts2000 
JOIN renewable_energy_clean ts2023
    ON ts2000.`ï»¿country` = ts2023.`ï»¿country`
JOIN african_countries_with_regions 
    ON ts2023.`ï»¿country` = african_countries_with_regions.country
WHERE 
    ts2000.year = 2000 AND
    ts2023.year = 2023 AND
    african_countries_with_regions.continent = 'Africa'
ORDER BY difference_wind DESC;

## What is the top renewable energy source in each African country in 2023

SELECT  `ï»¿country` AS country_name,
		hydro,
		solar,
        wind,
CASE 
    WHEN hydro >= solar AND hydro >= wind THEN 'Hydro'
    WHEN solar >= hydro AND solar >= wind THEN 'Solar'
    WHEN wind >= hydro AND wind >= solar THEN 'Wind'
END AS main_renewable_source
FROM renewable_energy_clean JOIN african_countries_with_regions
	ON renewable_energy_clean.`ï»¿country` = african_countries_with_regions.country
WHERE year = 2023 
	AND african_countries_with_regions.continent = 'Africa';

## Which African regions saw the greatest increase in renewable energy production between 2000 and 2023?
SELECT
		african_countries_with_regions.region,
		SUM(tr2023.total_renewables) AS renewables_2023,
        SUM(tr2000.total_renewables) AS renewables_2000,
        (SUM(tr2023.total_renewables) - SUM(tr2000.total_renewables)) AS renewables_increase
FROM renewable_energy_clean tr2000 
JOIN renewable_energy_clean tr2023
ON tr2000.`ï»¿country` = tr2023.`ï»¿country`
JOIN african_countries_with_regions
ON tr2023.`ï»¿country` = african_countries_with_regions.country
WHERE tr2023.year = 2023 AND
tr2000.year =2000 AND
african_countries_with_regions.continent = 'Africa'
GROUP BY african_countries_with_regions.region
ORDER BY renewables_increase DESC;

## What was the average per-country renewable energy growth between 2000 and 2023 for each region?
SELECT
    african_countries_with_regions.region,
    SUM(tr2023.total_renewables - tr2000.total_renewables) AS total_increase,
    COUNT(DISTINCT tr2023.`ï»¿country`) AS number_of_countries,
    ROUND(SUM(tr2023.total_renewables - tr2000.total_renewables) / COUNT(DISTINCT tr2023.`ï»¿country`), 2) AS avg_increase_per_country
FROM renewable_energy_clean tr2000 
JOIN renewable_energy_clean tr2023
    ON tr2000.`ï»¿country` = tr2023.`ï»¿country`
JOIN african_countries_with_regions
    ON tr2023.`ï»¿country` = african_countries_with_regions.country
WHERE tr2000.year = 2000 
  AND tr2023.year = 2023
  AND african_countries_with_regions.continent = 'Africa'
GROUP BY african_countries_with_regions.region
ORDER BY avg_increase_per_country DESC;

## Which African countries had the highest GDP in 2023, and what was their total renewable energy production that year
WITH renewables_2023 AS (
    SELECT `ï»¿country`, total_renewables
    FROM renewable_energy_clean
    WHERE year = 2023
),
gdp_2023 AS (
    SELECT `ï»¿Country Name` AS country_name, gdp
    FROM gdp_data
    WHERE year = 2023
)

SELECT 
    r.`ï»¿country` AS country_name,
    g.gdp AS gdp_2023,
    r.total_renewables AS renewables_2023
FROM renewables_2023 r
JOIN gdp_2023 g
    ON r.`ï»¿country` = g.country_name
JOIN african_countries_with_regions acr
    ON r.`ï»¿country` = acr.country
WHERE acr.continent = 'Africa'
ORDER BY g.gdp DESC;

## What is the correlation between GDP per capita and renewable energy use in African countries (2023)

SELECT 
    gdp.`ï»¿Country Name` AS country,
    gdp.gdp,
    energy.total_renewables
FROM (
    SELECT `ï»¿Country Name`, year, gdp
    FROM gdp_data
    WHERE year = 2023
) gdp
JOIN (
    SELECT `ï»¿country`, year, total_renewables
    FROM renewable_energy_clean
    WHERE year = 2023
) energy
    ON gdp.`ï»¿Country Name` = energy.`ï»¿country`
JOIN african_countries_with_regions
    ON gdp.`ï»¿Country Name` = african_countries_with_regions.country
WHERE african_countries_with_regions.continent = 'Africa';

##  Which countries had the highest renewable energy per capita in 2023
SELECT renewable_energy_clean.`ï»¿country` AS country_name,
		(total_renewables/population) AS renewable_energy_per_capita
FROM renewable_energy_clean JOIN african_countries_with_regions
ON renewable_energy_clean.`ï»¿country` = african_countries_with_regions.country
WHERE african_countries_with_regions.continent = 'Africa'
	AND year = 2023
ORDER BY renewable_energy_per_capita DESC;

## Which regions have the highest renewable energy per capita in 2023?
SELECT african_countries_with_regions.region,
		SUM(total_renewables) / SUM(population) AS renewable_energy_per_capita
FROM renewable_energy_clean JOIN african_countries_with_regions
ON renewable_energy_clean.`ï»¿country` = african_countries_with_regions.country
WHERE african_countries_with_regions.continent = 'Africa'
	AND year = 2023
GROUP BY african_countries_with_regions.region
ORDER BY renewable_energy_per_capita DESC;

## Countries with Zero or No Significant Renewable Energy in 2023
SELECT 
		renewable_energy_clean.`ï»¿country` AS country_name,
        renewable_energy_clean.total_renewables
FROM renewable_energy_clean
JOIN african_countries_with_regions 
	ON renewable_energy_clean.`ï»¿country` = african_countries_with_regions.country
WHERE renewable_energy_clean.year = 2023
	AND african_countries_with_regions.continent = 'Africa'
    AND renewable_energy_clean.total_renewables <= 5;

## Which African countries had the highest and lowest renewable energy per capita in 2023?
SELECT renewable_energy_clean.`ï»¿country` AS country_name,
		(total_renewables/population) AS renewable_energy_per_capita
FROM renewable_energy_clean JOIN african_countries_with_regions
ON renewable_energy_clean.`ï»¿country` = african_countries_with_regions.country
WHERE african_countries_with_regions.continent = 'Africa'
	AND year = 2023
ORDER BY renewable_energy_per_capita DESC
LIMIT 5;

SELECT renewable_energy_clean.`ï»¿country` AS country_name,
		(total_renewables/population) AS renewable_energy_per_capita
FROM renewable_energy_clean JOIN african_countries_with_regions
ON renewable_energy_clean.`ï»¿country` = african_countries_with_regions.country
WHERE african_countries_with_regions.continent = 'Africa'
	AND year = 2023
ORDER BY renewable_energy_per_capita 
LIMIT 5;

## What is the trend of renewable energy production in Africa from 2000 to 2023
SELECT SUM(renewable_energy_clean.total_renewables) AS total_renewable_energy,
			renewable_energy_clean.year AS year
	FROM renewable_energy_clean 
    JOIN african_countries_with_regions
		ON renewable_energy_clean.`ï»¿country` = african_countries_with_regions.country
	WHERE african_countries_with_regions.continent = 'Africa'
		 AND renewable_energy_clean.year BETWEEN 2000 AND 2023
    GROUP BY renewable_energy_clean.year
    ORDER BY renewable_energy_clean.year ASC;
    
## What is the trend of renewable energy per capita in Africa from 2000 to 2023
SELECT 
    renewable_energy_clean.year AS year,
    SUM(renewable_energy_clean.total_renewables) / SUM(renewable_energy_clean.population) AS renewable_energy_per_capita
FROM renewable_energy_clean
JOIN african_countries_with_regions
    ON renewable_energy_clean.`ï»¿country` = african_countries_with_regions.country
WHERE african_countries_with_regions.continent = 'Africa'
    AND renewable_energy_clean.year BETWEEN 2000 AND 2023
GROUP BY renewable_energy_clean.year
ORDER BY year ASC;