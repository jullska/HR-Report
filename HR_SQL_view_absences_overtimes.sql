-- Creating view with absences and overtime
CREATE VIEW vw_employee_absence_summary AS
SELECT 
    e.employee_id,
    e.employee_name,
    d.department_name,
    COUNT(a.absence_id) AS total_absences,
    SUM(o.hours_worked) AS total_overtime
FROM employees e
LEFT JOIN absences a ON e.employee_id = a.employee_id
LEFT JOIN overtimes o ON e.employee_id = o.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY e.employee_id, e.employee_name, d.department_name;

Select * from vw_employee_absence_summary;