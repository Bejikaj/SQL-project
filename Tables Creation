-- Data mezd a cen potravin za Českou republiku sjednocených na společné roky 2006 - 2018

SELECT * FROM czechia_price ORDER BY date_from;
SELECT * FROM czechia_payroll ORDER BY payroll_year;	
CREATE OR REPLACE TABLE t_jan_benacek_project_SQL_primary_final AS 
SELECT 
	cpc.name AS food_category,
	cpc.price_value,
	cpc.price_unit,
	cp.value AS price,
	cp.date_from,
	cp.date_to,
	cpay.payroll_year ,
	cpay.value AS avg_wages,
	cpib.name AS industry_branch
FROM czechia_price cp
JOIN czechia_payroll cpay 
	ON YEAR(cp.date_from) = cpay.payroll_year
	AND cpay.value_type_code = 5958
	AND cp.region_code IS NULL
JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code 
JOIN czechia_payroll_industry_branch cpib 
	ON cpay.industry_branch_code = cpib.code;


-- Dodatečná data o dalších evropských státech

SELECT * FROM t_jan_benacek_project_SQL_primary_final
ORDER BY date_from, food_category;
CREATE OR REPLACE TABLE t_jan_benacek_project_SQL_secondary_final AS 
SELECT 
	c.country,
	e.`year`,
	e.population, 
	e.gini,
	e.GDP	
FROM countries c
JOIN economies e ON e.country = c.country
	WHERE c.continent = 'Europe'
		AND e.`year` BETWEEN 2006 AND 2018
ORDER BY c.`country`, e.`year`;

SELECT * FROM t_jan_benacek_project_SQL_secondary_final;
  
