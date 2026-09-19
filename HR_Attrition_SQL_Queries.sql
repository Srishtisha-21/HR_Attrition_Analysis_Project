CREATE TABLE Employee (
    employeeid VARCHAR(20),
    age INTEGER,
    agegroup VARCHAR(20),
    attrition VARCHAR(10),
    businesstravel VARCHAR(30),
    dailyrate INTEGER,
    department VARCHAR(50),
    distancefromhome INTEGER,
    education INTEGER,
    educationfield VARCHAR(50),
    employeecount INTEGER,
    employeenumber INTEGER,
    environmentsatisfaction INTEGER,
    gender VARCHAR(20),
    hourlyrate INTEGER,
    jobinvolvement INTEGER,
    joblevel INTEGER,
    jobrole VARCHAR(50),
    jobsatisfaction INTEGER,
    maritalstatus VARCHAR(30),
    monthlyincome INTEGER,
    salaryslab VARCHAR(20),
    monthlyrate INTEGER,
    numcompaniesworked INTEGER,
    over18 VARCHAR(10),
    overtime VARCHAR(10),
    percentsalaryhike INTEGER,
    performancerating INTEGER,
    relationshipsatisfaction INTEGER,
    standardhours INTEGER,
    stockoptionlevel INTEGER,
    totalworkingyears INTEGER,
    trainingtimeslastyear INTEGER,
    worklifebalance INTEGER,
    yearsatcompany INTEGER,
    yearsincurrentrole INTEGER,
    yearssincelastpromotion INTEGER,
    yearswithcurrmanager INTEGER);

SELECT * FROM Employee;

--1. Total Number of Employees
--Question: How many employees are in the dataset?
SELECT COUNT(*) AS total_employees
FROM Employee;


--2. Total Employees Who Left vs Stayed
--Question: How many employees left the company?
SELECT
    attrition,
    COUNT(*) AS employee_count
FROM employee
GROUP BY attrition
ORDER BY employee_count DESC;


--3. Overall Attrition Rate ⭐
--Question: What percentage of employees left?
SELECT
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate
FROM employee;


--4. Attrition by Gender
--Question: Is attrition higher for one gender?
SELECT
    gender,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate
FROM employee
GROUP BY gender
ORDER BY attrition_rate DESC;


--5. Attrition by Department ⭐
--Question: Which department has the highest attrition?
SELECT
    department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate
FROM employee
GROUP BY department
ORDER BY attrition_rate DESC;


--6. Attrition by Job Role ⭐
--Question: Which job roles have the highest attrition?
SELECT
    jobrole,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate
FROM employee
GROUP BY jobrole
ORDER BY attrition_rate DESC;


--7. Attrition by Age Group
SELECT
    agegroup,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate
FROM employee
GROUP BY agegroup
ORDER BY attrition_rate DESC;


--8. Attrition by Job Level
SELECT
    joblevel,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate
FROM employee
GROUP BY joblevel
ORDER BY joblevel;


--9. Attrition by Business Travel
SELECT
    businesstravel,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate
FROM employee
GROUP BY businesstravel
ORDER BY attrition_rate DESC;


--10. Attrition by Overtime ⭐
--Question: Does overtime appear to be associated with higher attrition?
SELECT
    overtime,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate
FROM employee
GROUP BY overtime
ORDER BY attrition_rate DESC;


--11. Average Monthly Income — Stayed vs Left ⭐
--Are employees who leave earning less on average?
SELECT
    attrition,
    COUNT(*) AS employee_count,
    ROUND(AVG(monthlyincome), 2) AS average_monthly_income,
    ROUND(MIN(monthlyincome), 2) AS minimum_income,
    ROUND(MAX(monthlyincome), 2) AS maximum_income
FROM employee
GROUP BY attrition;


--12. Attrition by Salary Slab
SELECT
    salaryslab,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate
FROM employee
GROUP BY salaryslab
ORDER BY attrition_rate DESC;


--13. Attrition by Job Satisfaction ⭐
SELECT
    jobsatisfaction,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate
FROM employee
GROUP BY jobsatisfaction
ORDER BY jobsatisfaction;


--14. Attrition by Environment Satisfaction
SELECT
    environmentsatisfaction,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate
FROM employee
GROUP BY environmentsatisfaction
ORDER BY environmentsatisfaction;


--15. Attrition by Years at Company ⭐
SELECT
    CASE
        WHEN yearsatcompany <= 1 THEN '0-1 Years'
        WHEN yearsatcompany BETWEEN 2 AND 5 THEN '2-5 Years'
        WHEN yearsatcompany BETWEEN 6 AND 10 THEN '6-10 Years'
        ELSE '10+ Years'
    END AS tenure_group,

    COUNT(*) AS total_employees,

    SUM(
        CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END
    ) AS employees_left,

    ROUND(
        100.0 *
        SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate

FROM employee
GROUP BY tenure_group
ORDER BY attrition_rate DESC;


--16. Department + Overtime Analysis ⭐
SELECT
    department,
    overtime,
    COUNT(*) AS total_employees,

    SUM(
        CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END
    ) AS employees_left,

    ROUND(
        100.0 *
        SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate

FROM employee
GROUP BY department, overtime
ORDER BY department, attrition_rate DESC;


--17. Department Salary Analysis
SELECT
    department,
    COUNT(*) AS employee_count,
    ROUND(AVG(monthlyincome), 2) AS average_income,
    ROUND(MIN(monthlyincome), 2) AS minimum_income,
    ROUND(MAX(monthlyincome), 2) AS maximum_income
FROM employee
GROUP BY department
ORDER BY average_income DESC;


--18. Rank Departments by Attrition Using CTE + Window Function ⭐
WITH department_analysis AS (

    SELECT
        department,
        COUNT(*) AS total_employees,

        SUM(
            CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END
        ) AS employees_left,

        ROUND(
            100.0 *
            SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
            / COUNT(*),
            2
        ) AS attrition_rate

    FROM employee
    GROUP BY department
)

SELECT
    department,
    total_employees,
    employees_left,
    attrition_rate,

    RANK() OVER (
        ORDER BY attrition_rate DESC
    ) AS attrition_rank

FROM department_analysis;


--19. Identify Potential High-Risk Employees ⭐
SELECT
    employeeid,
    age,
    agegroup,
    department,
    jobrole,
    overtime,
    jobsatisfaction,
    monthlyincome,
    yearsatcompany
FROM employee
WHERE overtime = 'Yes'
  AND jobsatisfaction <= 2
  AND yearsatcompany <= 3
ORDER BY monthlyincome ASC;


--20. ⭐ Final Management Analysis
SELECT
    department,
    jobrole,
    overtime,

    COUNT(*) AS total_employees,

    SUM(
        CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END
    ) AS employees_left,

    ROUND(AVG(monthlyincome), 2) AS average_income,

    ROUND(AVG(jobsatisfaction), 2) AS average_job_satisfaction,

    ROUND(AVG(yearsatcompany), 2) AS average_years_at_company,

    ROUND(
        100.0 *
        SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS attrition_rate

FROM employee

GROUP BY
    department,
    jobrole,
    overtime

HAVING COUNT(*) >= 10

ORDER BY attrition_rate DESC;