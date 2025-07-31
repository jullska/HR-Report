# HR-Report
This project presents a comprehensive analysis of workforce data using a combination of **Power BI**, **SQL**, and **Python**, based on the publicly available dataset:

> [Employee Records Dataset – Kaggle](https://www.kaggle.com/datasets/smayanj/employee-records-dataset)

It explores trends in attrition, absenteeism, overtime, and salary structure to support HR and business decision-making.
---

## Tools & Technologies Used

- **SQL** – Used to structure and clean the dataset (fact and dimension tables), performed exploratory queries
- **Python** – Used to generate data of attrition, overtime, absence
- **Power BI** – Data visualization and dashboard creation

---

## Report Pages Overview

The report is structured into 5 interactive pages:

1. **Landing Page** - Introductory page with navigation buttons and high-level context about the dashboard.
2. **Workforce Overview** - Key HR metrics: active employees, absences, overtime, onboarding & attrition trends. Filter by department.
3. **Absence Insight** - Analyze absence types, costs, and durations by department, age, and country. Includes average days off per employee.
4. **Overtime Behavior** - Total and average overtime, linked with salary, tenure, age, and department. Focus on employees who worked extra hours.
5. **Salary & Workforce Composition** - Compare annual salary by age and tenure. See how salary relates to absences and overtime.

---

## Key Business Insights

- **Attrition peaks in December**, despite consistent hiring throughout the year.
- **Germany** hosts the largest share of employees across the company.
- On average, each employee takes **~33 days off annually**, with **paid vacation** being the most common.
- Absenteeism cost the company approx. **$209.5M** per year.
- The **Marketing department** logs the most sick leaves, while **Engineering** bears the highest cost due to absences.
- **January saw the highest overtime (6,600+ hours)**, while **February had the lowest (~6,100 hours)**.
- Employees tend to work **fewer overtime hours the longer they stay** with the company.
- **Age does not significantly influence** the amount of overtime done.
- The **average tenure** is **5.3 years**, and the **average employee age** is **41 years**.
- **Salary is not strongly correlated with employee age**, suggesting pay may be driven by other factors such as role or department.

---

## Files Included

- `Report.pbix` – Complete Power BI report
- `sql/` – Scripts used for data modeling and preparation
- `python/` – Scripts for cost estimation and preprocessing
- `screenshots/` – Page visualization from the report

---

## Author

- **Created by:** Julia Stróżyńska
- **Email:** julia.strozynska@onet.pl
- **LinkedIn:** (https://www.linkedin.com/in/julia-strozynska)

## Feedback Welcome!

Feel free to explore the repository and share feedback!
