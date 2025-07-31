-- count of actual working
SELECT
	COUNT(e.is_active) AS actual_working
FROM employees e
WHERE e.is_active = 1;

-- count of non working
SELECT
	COUNT(e.is_active) AS non_working
FROM employees e
WHERE e.is_active = 0;

-- average age
SELECT
	AVG(e.age) AS avg_age
FROM employees e;

-- countries with the most count of employees
SELECT TOP 5 
	c.country_name,
	COUNT(e.employee_id) AS now_working
FROM employees e
JOIN countries c ON e.country_id = c.country_id
WHERE e.is_active = 1
GROUP BY c.country_name
ORDER BY now_working DESC;

-- employees from finance department
SELECT
	e.employee_name,
	e.employee_id,
	d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';

-- count of new employee hired by year
SELECT
	YEAR(e.joining_date) AS year_join,
	COUNT(e.employee_id) AS num_employee
FROM employees e
GROUP BY YEAR(e.joining_date)
ORDER BY year_join DESC;

-- sum of absences
SELECT
	COUNT(e.employee_id) AS num_employee,
	SUM(a.hours_absent) AS absent_hours
FROM employees e
LEFT JOIN absences a ON e.employee_id = a.employee_id;

-- average hours absence by type
SELECT
	at.absence_type_name,
	AVG(a.hours_absent) AS avg_hours
FROM realistic_absences a
JOIN absence_types at ON a.absence_type_id = at.absence_type_id
GROUP BY at.absence_type_name;

-- employee with the most overtime
SELECT TOP 10
	e.employee_name,
	e.employee_id,
	SUM(o.hours_worked) AS overtime
FROM employees e
LEFT JOIN overtimes o ON e.employee_id = o.employee_id
GROUP BY e.employee_name, e.employee_id
ORDER BY overtime DESC;

-- count of employee in departments
SELECT
	d.department_name,
	COUNT(e.employee_id) AS employee
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- sum of absences, number of employee, average absences grouping by departments
SELECT
	d.department_name,
	COUNT(rd.absence_id) AS sum_absences,
	COUNT(DISTINCT(e.employee_id)) AS num_employee,
	COUNT(rd.absence_id)/COUNT(DISTINCT(e.employee_id)) AS avg_absences
FROM employees e
JOIN departments d ON e.department_id = d.department_id
LEFT JOIN realistic_absences rd ON e.employee_id = rd.employee_id
GROUP BY d.department_name;

-- sum of absences by months
SELECT
	MONTH(rd.absence_date) AS month,
	COUNT(rd.absence_id) AS sum_absence
FROM realistic_absences rd
GROUP BY MONTH(rd.absence_date)
ORDER BY COUNT(rd.absence_id) DESC;

-- 5 of employee from each of department with the smallest sum of absences
WITH ranked_group AS (
	SELECT
		d.department_name,
		e.employee_name,
		e.employee_id,
		COUNT(rd.absence_id) AS sum_absences,
		ROW_NUMBER() OVER (
			PARTITION BY d.department_name ORDER BY COUNT(rd.absence_id) DESC
			) AS rn
	FROM employees e
	JOIN departments d ON e.department_id = d.department_id
	JOIN realistic_absences rd ON e.employee_id = rd.employee_id
	GROUP BY e.employee_id, e.employee_name, d.department_name)
SELECT
	department_name,
	employee_name,
	employee_id,
	sum_absences
FROM ranked_group
WHERE rn <= 5
ORDER BY department_name, sum_absences DESC;

-- employees which had in the same month overtimes and absences
SELECT
	e.employee_name,
	e.employee_id,
	o.shared_month,
	o.overtime_hours,
	rd.absent_hours
FROM employees e
JOIN (
	SELECT
		employee_id,
		MONTH(overtime_date) AS shared_month,
		SUM(hours_worked) AS overtime_hours
	FROM overtimes
	GROUP BY employee_id, MONTH(overtime_date)
) o ON e.employee_id = o.employee_id
JOIN (
	SELECT
		employee_id,
		MONTH(absence_date) AS shared_month,
		SUM(hours_absent) AS absent_hours
    FROM realistic_absences
    GROUP BY employee_id, MONTH(absence_date)
) rd ON e.employee_id = rd.employee_id AND o.shared_month = rd.shared_month
ORDER BY o.shared_month, employee_name;

-- prediction female and male names and percentage distribution
SELECT
	SUM(CASE 
		WHEN e.employee_name LIKE '%a %' 
			OR e.employee_name LIKE '%y %' 
			OR e.employee_name LIKE '%an %' THEN 1 ELSE 0 END) AS female_count,
	SUM(CASE
		WHEN NOT (e.employee_name LIKE '%a %' 
			OR e.employee_name LIKE '%y %' 
			OR e.employee_name LIKE '%an %')THEN 1 ELSE 0 END) AS male_count,
	ROUND(
        100.0 * SUM(CASE 
            WHEN e.employee_name LIKE '%a %' OR e.employee_name LIKE '%y %' OR e.employee_name LIKE '%an %' THEN 1 
			ELSE 0
        END) / COUNT(*), 2
    ) AS female_percentage,

    ROUND(
        100.0 * SUM(CASE 
            WHEN NOT (e.employee_name LIKE '%a %' OR e.employee_name LIKE '%y %' OR e.employee_name LIKE '%an %') THEN 1 
			ELSE 0
        END) / COUNT(*), 2
    ) AS male_percentage,
	COUNT(*) AS all_employee
FROM employees e;

-- employee which had overtimes and absences in the same month, order by the greatest count of hours
SELECT
	e.employee_name,
	e.employee_id,
	o.shared_month,
	o.overtime_hours,
	rd.absent_hours
FROM employees e
JOIN (
	SELECT
		employee_id,
		MONTH(overtime_date) AS shared_month,
		SUM(hours_worked) AS overtime_hours
	FROM overtimes
	GROUP BY employee_id, MONTH(overtime_date)
) o ON e.employee_id = o.employee_id
JOIN (
	SELECT
		employee_id,
		MONTH(absence_date) AS shared_month,
		SUM(hours_absent) AS absent_hours
    FROM realistic_absences
    GROUP BY employee_id, MONTH(absence_date)
) rd ON e.employee_id = rd.employee_id AND o.shared_month = rd.shared_month
GROUP BY o.overtime_hours, rd.absent_hours, e.employee_name, o.shared_month, e.employee_id
HAVING overtime_hours > 2 AND absent_hours > 30
ORDER BY overtime_hours DESC, absent_hours DESC;

-- sum of absences by months
SELECT 
    FORMAT(absence_date, 'yyyy-MM') AS month,
    COUNT(*) AS total_absences
FROM absences
GROUP BY FORMAT(absence_date, 'yyyy-MM')
ORDER BY month;

-- average overtime
SELECT 
    e.employee_name,
	e.employee_id,
    AVG(o.hours_worked) AS avg_overtime
FROM employees e
JOIN overtimes o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.employee_name
ORDER BY avg_overtime DESC

-- sum hours of absences and hours of overtimes by employee
WITH AbsenceStats AS (
    SELECT 
        employee_id,
        SUM(hours_absent) AS absence_count
    FROM absences
    GROUP BY employee_id
),
OvertimeStats AS (
    SELECT 
        employee_id,
        SUM(hours_worked) AS total_overtime
    FROM overtimes
    GROUP BY employee_id
)
SELECT 
    e.employee_name,
    a.absence_count,
    o.total_overtime
FROM employees e
LEFT JOIN AbsenceStats a ON e.employee_id = a.employee_id
LEFT JOIN OvertimeStats o ON e.employee_id = o.employee_id;

-- employee in order by count of absences in department
SELECT 
    e.employee_name,
	e.employee_id,
    d.department_name,
    COUNT(a.absence_id) AS absence_count,
    RANK() OVER(PARTITION BY e.department_id ORDER BY COUNT(a.absence_id) DESC) AS dept_rank
FROM employees e
JOIN absences a ON e.employee_id = a.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY e.employee_name, d.department_name, e.department_id, e.employee_id;

-- count of leaving from job by months
SELECT 
    FORMAT(exit_date, 'yyyy-MM') AS exit_month,
    COUNT(*) AS leavers
FROM employees
WHERE is_active = 0 AND exit_date IS NOT NULL
GROUP BY FORMAT(exit_date, 'yyyy-MM')
ORDER BY exit_month;
