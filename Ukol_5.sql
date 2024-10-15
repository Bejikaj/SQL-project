-- Discord - bejikaj#2628
-- Otázka č.5 Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

CREATE OR REPLACE VIEW GDP_diff AS
SELECT
eco1.country,
eco2.year AS previous_year,
eco2.GDP AS GDP_PY,
eco1.year AS current_year,
eco1.GDP AS GDP_CY,
ROUND ( eco1.GDP - eco2.GDP,2 ) AS diff_value,
ROUND ( (eco1.GDP - eco2.GDP) / eco2.GDP * 100, 2 ) AS diff_perc
FROM t_jan_benacek_project_SQL_secondary_final as eco1
JOIN t_jan_benacek_project_SQL_secondary_final as eco2
	ON eco1.country = eco2.country
	AND eco1.year = eco2.YEAR + 1
WHERE eco1.country = 'Czech Republic';

-- Prům cena potravin - pomocný view
CREATE OR REPLACE VIEW avg_price_food AS  
SELECT
	YEAR(date_to) AS year_price,
	category_code,
	ROUND(AVG(avg_price), 2) AS avg_price
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
GROUP BY apf.year_price;

-- Prům mzda - pomocný view
CREATE OR REPLACE VIEW avg_wage AS 
SELECT
	payroll_year,
	ROUND(AVG(avg_wage)) AS avg_wage
FROM t_jan_benacek_project_SQL_primary_final
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

-- Výsledná tabule
SELECT
apfsy.current_year AS year_to_compare,
gd.diff_perc AS GDP_change_perc,
apfsy.diff_perc AS food_change_perc,
awwd.price_diff_perc AS wage_change_perc
FROM avg_price_food_sum_year apfsy
JOIN avg_wage_with_diff awwd 
	ON apfsy.current_year = awwd.current_year 
JOIN gdp_diff gd
	ON apfsy.current_year = gd.current_year 
ORDER BY apfsy.current_year ASC;
