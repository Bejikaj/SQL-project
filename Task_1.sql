-- Otázka č.1 Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
    
-- Průměrná hrubá mzda na zamce dle odvětví a let
CREATE OR REPLACE VIEW avg_wage_sector AS 
SELECT
	industry_branch_code,
	payroll_year,
	ROUND(AVG(avg_wage)) AS avg_wage
FROM t_jan_benacek_project_SQL_primary_final
WHERE industry_branch_code IS NOT NULL
GROUP BY payroll_year,
		 industry_branch_code
ORDER BY industry_branch_code,
         payroll_year;


-- % Změna hrubé mzdy v sektoru dle roku
SELECT
awes.industry_branch_code AS ind_branch_c,
awes2.payroll_year AS prev_year,
awes.payroll_year AS current_year,
awes2.avg_wage AS PY_wage,
awes.avg_wage AS CY_wage,
ROUND( (awes.avg_wage - awes2.avg_wage) ) AS wage_diff_value,
ROUND(  (awes.avg_wage - awes2.avg_wage) / awes2.avg_wage * 100, 2) AS wage_diff_perc
FROM avg_wage_sector awes
JOIN avg_wage_sector awes2 
	ON awes.industry_branch_code = awes2.industry_branch_code
	AND awes.payroll_year = awes2.payroll_year + 1
