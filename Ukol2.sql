-- Otázka č.2 Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
-- Price_category (Mléko polotučné pasterované - 114201, Chléb konzumní kmínový - 111301)
    
-- Prům. mzda (fyzický přepočet - calculation code = 100) v letech    
CREATE OR REPLACE VIEW avg_wage AS 
SELECT
	payroll_year,
	ROUND(AVG(value)) AS avg_wage
FROM t_jan_benacek_project_SQL_primary_final
WHERE value_type_code = 5958
GROUP BY payroll_year;


-- Prům. cena vybraného sortimentu
CREATE OR REPLACE VIEW avg_price_food_year AS  
SELECT
	YEAR(date_to) AS year_price,
	category_code,
	ROUND(AVG(value), 2) AS avg_price
FROM czechia_price cp
WHERE category_code = 114201 
	OR category_code = 111301
GROUP BY category_code,
		 year_price;

-- Množství sortimentu za průměrnou mzdu v letech		
SELECT 
aw.payroll_year AS year,
apfy.category_code,
apfy.year_price,
aw.avg_wage,
apfy.avg_price,
ROUND( aw.avg_wage / apfy.avg_price, 2) AS no_of_units_per_wage
FROM avg_wage aw
JOIN avg_price_food_year apfy
	ON aw.payroll_year = apfy.year_price
	;
