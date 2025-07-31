-- creating dimension tables

CREATE TABLE countries (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE positions (
    position_id INT PRIMARY KEY,
    position_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE absence_types (
    absence_type_id INT PRIMARY KEY,
    absence_type_name VARCHAR(50) NOT NULL UNIQUE
);

-- create fact table

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    age INT,
    country_id INT,
    department_id INT,
    position_id INT,
    salary DECIMAL(10, 2),
    joining_date DATE,
	is_active BIT,
    exit_date DATE,
    

    FOREIGN KEY (country_id) REFERENCES countries(country_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (position_id) REFERENCES positions(position_id)
);

CREATE TABLE absences (
    absence_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,
    absence_date DATE,
    absence_type_id INT,
    hours_absent INT,

    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (absence_type_id) REFERENCES absence_types(absence_type_id)
);

CREATE TABLE absences_stage (
    employee_id INT,
    absence_date DATE,
    absence_type_id INT,
    hours_absent INT
);

CREATE TABLE realistic_absences (
    absence_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,
    absence_date DATE,
    absence_type_id INT,
    hours_absent INT,

    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (absence_type_id) REFERENCES absence_types(absence_type_id)
);

CREATE TABLE absences_s (
    employee_id INT,
    absence_date DATE,
    absence_type_id INT,
    hours_absent INT
);

CREATE TABLE overtimes (
    overtime_id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,
    overtime_date DATE,
    hours_worked INT,
	approved_by_hr BIT,

    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE overtimes_stage (
    employee_id INT NOT NULL,
    overtime_date DATE,
    hours_worked INT,
	approved_by_hr BIT,
);

-- insert data to table

BULK INSERT dbo.countries
FROM 'D:\Power Bi\HR with SQL\countries.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

SELECT TOP 5 * FROM countries;

BULK INSERT dbo.departments
FROM 'D:\Power Bi\HR with SQL\departments.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
SELECT TOP 5 * FROM departments;

BULK INSERT dbo.positions
FROM 'D:\Power Bi\HR with SQL\positions.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
SELECT TOP 5 * FROM positions;

BULK INSERT dbo.absence_types
FROM 'D:\Power Bi\HR with SQL\absences_type.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
SELECT TOP 5 * FROM absence_types;

BULK INSERT dbo.employees
FROM 'D:\Power Bi\HR with SQL\employees_with_attrition.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
SELECT TOP 10 * FROM employees;

BULK INSERT dbo.absences_stage
FROM 'D:\Power Bi\HR with SQL\absences_clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
SELECT TOP 10 * FROM absences_stage;

INSERT INTO absences (employee_id, absence_date, absence_type_id, hours_absent)
SELECT employee_id, absence_date, absence_type_id, hours_absent
FROM absences_stage;

SELECT TOP 10 * FROM absences;

BULK INSERT dbo.absences_s
FROM 'D:\Power Bi\HR with SQL\absences_realistic.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
SELECT TOP 10 * FROM absences_s;

INSERT INTO realistic_absences (employee_id, absence_date, absence_type_id, hours_absent)
SELECT employee_id, absence_date, absence_type_id, hours_absent
FROM absences_s;

SELECT TOP 10 * FROM realistic_absences;

BULK INSERT dbo.overtimes_stage
FROM 'D:\Power Bi\HR with SQL\overtimes.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
SELECT TOP 10 * FROM overtimes_stage;

INSERT INTO overtimes(employee_id, overtime_date, hours_worked, approved_by_hr)
SELECT employee_id, overtime_date, hours_worked, approved_by_hr
FROM overtimes_stage;

SELECT TOP 10 * FROM employees;