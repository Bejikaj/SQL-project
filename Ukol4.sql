-- Otázka č.4 Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
    
    
-- Prům. mzda v letech s rozdílem v % a s číselnou hodnotou změny
    
CREATE OR REPLACE VIEW avg_wage AS 
SELECT
	payroll_year,
	ROUND(AVG(value)) AS avg_wage
FROM t_jan_benacek_project_SQL_primary_final
WHERE value_type_code = 5958
GROUP BY payroll_year;
    
CREATE OR REPLACE VIEW avg_wage_with_diff AS    
SELECT
aw2.payroll_year AS prev_year,
aw.payroll_year AS current_year,
aw2.avg_wage AS PY_price,
aw.avg_wage AS CY_price,
ROUND( (aw.avg_wage - aw2.avg_wage), 2 ) AS price_diff_value,
ROUND( (aw.avg_wage - aw2.avg_wage) / aw2.avg_wage * 100, 2 ) AS price_diff_perc
FROM avg_wage aw
JOIN avg_wage aw2 
	ON aw.payroll_year = aw2.payroll_year + 1;

-- Prům. cena potravin v letech s rozdílem v % a s číselnou hodnotou změny
CREATE OR REPLACE VIEW avg_price_food AS  
SELECT
	YEAR(date_to) AS year_price,
	category_code,
	ROUND(AVG(value), 2) AS avg_price
FROM t_jan_benacek_project_SQL_primary_final
GROUP BY category_code,
		 year_price;

CREATE OR REPLACE VIEW avg_price_food_sum_year AS 
SELECT
apf2.year_price AS previous_year,
apf.year_price AS current_year,
SUM(apf2.avg_price) AS avg_PY_price,
SUM(apf.avg_price) AS avg_CY_price,
ROUND( SUM(apf.avg_price) - SUM(apf2.avg_price), 2 ) AS diff_value,
ROUND( (SUM(apf.avg_price) - SUM(apf2.avg_price)) / SUM(apf2.avg_price) * 100, 2 ) AS diff_perc
FROM avg_price_food apf
JOIN avg_price_food apf2
	ON apf.year_price = apf2.year_price + 1
	AND apf.category_code = apf2.category_code
GROUP BY apf.year_price
;

SELECT
apfsy.current_year AS year_to_compare,
apfsy.diff_perc AS food_perc_change,
awwd.price_diff_perc AS wage_perc_change,
ROUND (apfsy.diff_perc - awwd.price_diff_perc, 2) AS food_minus_wage_change
FROM avg_price_food_sum_year apfsy
JOIN avg_wage_with_diff awwd 
	ON apfsy.current_year = awwd.current_year;
