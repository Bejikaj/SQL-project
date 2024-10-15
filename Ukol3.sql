-- Otázka č.3 Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

-- Průměrná cena sortimentu v jednotlivých letech
CREATE OR REPLACE VIEW avg_price_food AS  
SELECT
	YEAR(date_to) AS year_price,
	category_code,
	ROUND(AVG(avg_price), 2) AS avg_price
FROM t_jan_benacek_project_SQL_primary_final
GROUP BY category_code,
		 year_price;

-- Průměrná cena sortimentu za celé obdbobí (tj. změna mezi roky 2006 a 2018)
CREATE OR REPLACE VIEW avg_price_food_min_max_period AS
SELECT
year_price,
category_code,
avg_price
FROM avg_price_food apf 
WHERE year_price = ( SELECT MIN(year_price) FROM avg_price_food apf)
	OR year_price = ( SELECT MAX(year_price) FROM avg_price_food apf);


-- Porovnání % a hodnoty změny sortimentu v jednotlivých letech
CREATE OR REPLACE VIEW diff_food_years AS
SELECT
apf.category_code AS food_code,
apf2.year_price AS prev_year,
apf.year_price AS current_year,
apf2.avg_price AS PY_price,
apf.avg_price AS CY_price,
ROUND( (apf.avg_price - apf2.avg_price), 2 ) AS price_diff_value,
ROUND(  (apf.avg_price - apf2.avg_price) / apf2.avg_price * 100, 2) AS price_diff_perc
FROM avg_price_food apf
JOIN avg_price_food apf2
	ON apf.category_code = apf2.category_code
	AND apf.year_price = apf2.year_price + 1;

-- Porovnání % a hodnoty změny sortimentu za celé období (tj. změna mezi roky 2006 a 2018)
 SELECT
apfmmp.category_code,
apfmmp.avg_price AS avg_price_min,
apfmmp2.avg_price AS avg_price_max,
ROUND( (apfmmp2.avg_price - apfmmp.avg_price), 2 ) AS price_diff_value,
ROUND( (apfmmp2.avg_price - apfmmp.avg_price) / apfmmp.avg_price * 100, 2 ) AS price_diff_perc
FROM avg_price_food_min_max_period apfmmp
JOIN avg_price_food_min_max_period apfmmp2
	ON apfmmp2.category_code = apfmmp.category_code
GROUP BY category_code
ORDER BY price_diff_value ASC;

SELECT
*
FROM diff_food_years dfy 
ORDER BY price_diff_perc DESC; 
