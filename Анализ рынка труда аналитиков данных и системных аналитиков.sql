SELECT *
FROM public.parcing_table pt 
LIMIT 10;


-- диапазон заработных плат
SELECT MIN(pt.salary_from) AS "мин начальная зп", MAX(pt.salary_from) AS "макс начальная зп",
	   MIN(pt.salary_to) AS "мин пороговая зп", MAX(pt.salary_to) AS "макс пороговая зп",
	   ROUND(AVG(salary_from),2) AS "сред начальная зп", ROUND(AVG(salary_to),2) AS "сред пороговая зп"
FROM public.parcing_table pt;

-- изменение спроса на системных аналитиков и аналитиков данных в период с февраля по июнь 2024 года по месяцам
SELECT CASE
	   WHEN name LIKE '%Аналитик данных%'
	    OR name LIKE '%аналитик данных%'
	   THEN 'Аналитик данных'
	   END AS "направление",
DATE_TRUNC('month', published_at)::date AS "месяц", COUNT(*) AS "спрос"
FROM public.parcing_table
WHERE name LIKE '%Аналитик данных%'
	   	OR name LIKE '%аналитик данных%'
GROUP BY 1,2
	   
	   	UNION ALL
	   	
SELECT CASE 	 
	   	WHEN pt.name LIKE '%Системный аналитик%'
	   	OR pt.name LIKE '%системный аналитик%'
	   	THEN 'Системный аналитик'
	   END,
DATE_TRUNC('month', pt.published_at)::date, COUNT(*)
FROM public.parcing_table pt
 WHERE pt.name LIKE '%Системный аналитик%'
	   	OR pt.name LIKE '%системный аналитик%'
GROUP BY 1, 2
ORDER BY 1,2;

--регионы, в которых больше всего сосредоточено вакансий
SELECT pt.area AS "регион", COUNT(*) AS  "кол-во вакансий"
FROM public.parcing_table pt
GROUP BY area
ORDER BY 2 DESC
LIMIT 10;

--компании, в которых больше всего сосредоточено вакансий
SELECT pt.employer AS "компании", COUNT(*) AS "кол-во вакансий"
FROM public.parcing_table pt
GROUP BY employer
ORDER BY 2 DESC
LIMIT 10;

--типы занятости
SELECT pt.employment AS "тип занятости", COUNT(*) AS "кол-во вакансий"
FROM public.parcing_table pt
GROUP BY 1
ORDER BY 2 DESC;

-- графики работ
SELECT schedule AS "график работы", COUNT(*) AS "кол-во вакансий"
FROM public.parcing_table pt 
GROUP BY 1
ORDER BY 2 DESC;

-- распределение грейдов 
SELECT experience AS "грейд", COUNT(*) "кол-во вакансий"
FROM public.parcing_table pt
GROUP BY 1
ORDER BY 2 DESC;

/* 4. распределение грейдов среди аналитиков данных и системных аналитиков
в абсолютном выражении и %*/
SELECT pt.experience AS "грейд", COUNT(*) AS "кол-во вакансий", ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*)
	FROM public.parcing_table p
	WHERE p.name LIKE '%Аналитик данных%'
	   OR p.name LIKE '%аналитик данных%'
	   OR p.name LIKE '%Системный аналитик%'
	   OR p.name LIKE '%системный аналитик%')::numeric, 2) AS "% грейда"
FROM public.parcing_table pt
WHERE pt.name LIKE '%Аналитик данных%'
	   OR pt.name LIKE '%аналитик данных%'
	   OR pt.name LIKE '%Системный аналитик%'
	   OR pt.name LIKE '%системный аналитик%'
GROUP BY pt.experience
ORDER BY 2 DESC;

-- основные работодатели
SELECT employer AS "компания", COUNT(*) AS "кол-во вакансий", employment AS  "тип занятости", schedule AS "график работы", 
	   ROUND(AVG(salary_from),2) AS "средняя зп в начале",
	   ROUND(AVG(salary_to),2) AS "порогавая средняя зп"
	   FROM public.parcing_table pt
	   WHERE pt.name LIKE '%Аналитик данных%'
	   	OR pt.name LIKE '%аналитик данных%'
	   	OR pt.name LIKE '%Системный аналитик%'
	   	OR pt.name LIKE '%системный аналитик%'
	   GROUP BY employer, employment, schedule
	   ORDER BY 2 DESC
	   LIMIT 5;

-- средняя зп в зависимости от опыта работы системных аналитиков и аналитиков данных
SELECT CASE
	   WHEN name LIKE '%Аналитик данных%'
	    OR name LIKE '%аналитик данных%'
	   THEN 'Аналитик данных'
	   END AS "направление",
experience AS "грейд", COUNT(*) AS "кол-во вакансий", ROUND(AVG(salary_from), 2) AS "средняя зп в начале",
ROUND(AVG(salary_to), 2) AS "порогавая средняя зп"
FROM  public.parcing_table
	   WHERE name LIKE '%Аналитик данных%'
	   	OR name LIKE '%аналитик данных%'
GROUP BY 1,2
	   	
	   	UNION ALL
	   	
SELECT CASE 	 
	   	WHEN pt.name LIKE '%Системный аналитик%'
	   	OR pt.name LIKE '%системный аналитик%'
	   	THEN 'Системный аналитик'
	   END,
experience, COUNT(*), ROUND(AVG(salary_from), 2),
	   ROUND(AVG(salary_to), 2)
FROM  public.parcing_table pt	   	
	   	WHERE pt.name LIKE '%Системный аналитик%'
	   	OR pt.name LIKE '%системный аналитик%'
GROUP BY 1,2
ORDER BY 1,2;
	   

-- наиболее востребованные жесткие навыки 
SELECT key_skills_1 AS "1 хард скилл", COUNT(*) AS "кол-во вакансий"
FROM public.parcing_table pt
WHERE key_skills_1 != ''
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

SELECT key_skills_2 AS "2 хард скилл", COUNT(*) AS "кол-во вакансий"
FROM public.parcing_table pt
WHERE key_skills_2 != ''
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

SELECT key_skills_3 AS "3 хард скилл", COUNT(*) AS "кол-во вакансий"
FROM public.parcing_table pt
WHERE key_skills_3 != ''
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

SELECT key_skills_4 AS "4 хард скилл", COUNT(*) AS "кол-во вакансий"
FROM public.parcing_table
WHERE key_skills_4 != ''
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- наиболее востребованные мягкие навыки 
SELECT soft_skills_1 AS "1 мягкий скилл", COUNT(*) AS "кол-во вакансий"
FROM public.parcing_table
WHERE soft_skills_1 != ''
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

SELECT soft_skills_2  AS "2 мягкий скилл", COUNT(*) AS "кол-во вакансий"
FROM public.parcing_table
WHERE soft_skills_2 != ''
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

SELECT soft_skills_3 AS "3 мягкий скилл", COUNT(*) AS "кол-во вакансий"
FROM public.parcing_table
WHERE soft_skills_3 != ''
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

SELECT soft_skills_4 AS "4 мягкий скилл", COUNT(*)  AS "кол-во вакансий"
FROM public.parcing_table
WHERE soft_skills_4 != ''
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;



