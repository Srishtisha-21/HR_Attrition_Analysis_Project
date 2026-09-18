# HR Attrition Analysis Dashboard | Power BI + PostgreSQL

An end-to-end HR analytics project that answers one question for a people-operations team: **who is leaving the organization, and why?**

Employee data is loaded into **PostgreSQL**, modelled and measured in **Power BI**, and presented as a two-page interactive dashboard that moves from *what is happening* (attrition overview) to *why it is happening* (attrition drivers).



---

## Table of Contents

- [Project Overview](#project-overview)
- [Business Problem](#business-problem)
- [Dashboard Preview](#dashboard-preview)
- [Tech Stack](#tech-stack)
- [Dataset](#dataset)
- [Data Model](#data-model)
- [DAX Measures](#dax-measures)
- [Dashboard Walkthrough](#dashboard-walkthrough)
- [Key Insights](#key-insights)
- [Business Recommendations](#business-recommendations)
- [Repository Structure](#repository-structure)
- [How to Run This Project](#how-to-run-this-project)
- [Skills Demonstrated](#skills-demonstrated)
- [Possible Extensions](#possible-extensions)
- [Author](#author)

---

## Project Overview

| | |
|---|---|
| **Project type** | Business Intelligence / People Analytics |
| **Tools** | PostgreSQL, Power BI Desktop, DAX, Power Query |
| **Pages** | 2 (Attrition Overview, Attrition Drivers & Insights) |
| **KPIs tracked** | 5 |
| **Visuals** | 10 charts + 4 slicers + page navigation |
| **Grain** | One row per employee |

Attrition is one of the most expensive problems an organization carries: replacing an employee typically costs a multiple of their monthly salary once hiring, onboarding and lost productivity are counted. Most HR teams, however, only see a single company-wide attrition number. This dashboard breaks that number down by **demographics, department, role, compensation, workload and career progression** so that retention effort can be aimed where it actually pays off.

## Business Problem

The HR leadership team needed answers to four questions:

1. What is our overall attrition rate, and how does it compare across the workforce?
2. **Who** is leaving — which age groups, genders and life stages?
3. **Where** are they leaving from — which departments and job roles are bleeding talent?
4. **Why** might they be leaving — is it pay, overtime, job level, tenure or lack of promotion?

## Dashboard Preview

### Page 1 — Attrition Overview
![Attrition Overview](<img width="1042" height="760" alt="Attrition Overview" src="https://github.com/user-attachments/assets/20423533-c445-4684-a327-2013a3eede75" />
)

### Page 2 — Attrition Drivers & Insights
![Attrition Drivers](<img width="1047" height="757" alt="Attrition Drives" src="https://github.com/user-attachments/assets/9a873913-70d8-487f-a89b-837499979229" />
)

## Tech Stack

| Layer | Tool | What it was used for |
|---|---|---|
| Storage | **PostgreSQL** | Hosting the cleaned `employee` table in the `public` schema |
| Ingestion | **Power BI – PostgreSQL connector** | Importing the table into the model |
| Transformation | **Power Query (M)** | Type casting, null handling, banding columns (Age Group, Salary Slab, Tenure Group, Promotion Gap Group) |
| Modelling | **Power BI data model** | A dedicated `DAX_Measure` table to keep measures separate from data |
| Measures | **DAX** | Attrition %, attrition count, employee count |
| Presentation | **Power BI Desktop** | Two-page report with slicers, page navigator and insight callouts |

## Dataset

The dataset holds one record per employee with demographic, job and compensation attributes.

| Column | Type | Description |
|---|---|---|
| `employeeid` | int | Unique employee identifier (primary key) |
| `attrition` | text | `Yes` if the employee left, `No` if still employed |
| `age` / `agegroup` | int / text | Age and its banded version (e.g. 18–25, 26–35, 36–45, 46–55, 55+) |
| `gender` | text | Male / Female |
| `maritalstatus` | text | Single / Married / Divorced |
| `department` | text | e.g. Sales, R&D, Human Resources |
| `jobrole` | text | e.g. Sales Executive, Laboratory Technician, Research Scientist |
| `joblevel` | int | Seniority band (1 = entry level) |
| `monthlyincome` | numeric | Monthly salary |
| `salaryslab` | text | Banded salary range |
| `percentsalaryhike` | numeric | Last appraisal hike (%) |
| `overtime` | text | Whether the employee works overtime |
| `yearsatcompany` / `YearsAtCompany Group` | int / text | Tenure and its banded version |
| `yearssincelastpromotion` / `YearSinceLastPromotion Group` | int / text | Promotion gap and its banded version |

**Rows:** `1470` employees &nbsp;|&nbsp; **Attrition cases:** `237`

> The banded columns (`agegroup`, `salaryslab`, and the two `Group` columns) are derived fields created during preparation — they turn continuous variables into readable buckets so the charts answer business questions instead of showing noise.

## Data Model

A deliberately simple star-shaped model:

```
public employee  (fact + dimension attributes, 1 row per employee)
        |
        └── DAX_Measure  (measure-only table, no data — keeps the model navigable)
```

Keeping measures in a dedicated `DAX_Measure` table is a standard modelling practice: report authors find every metric in one place instead of hunting through column lists.

## DAX Measures

```dax
-- Total headcount in the current filter context
Total Employees =
COUNT('public employee'[employeeid])

-- Employees who left
Attrition Count =
CALCULATE(
    COUNT('public employee'[employeeid]),
    'public employee'[attrition] = "Yes"
)

-- The core metric powering every chart in the report
Attrition% =
DIVIDE(
    [Attrition Count],
    [Total Employees],
    0
)
```

Because `Attrition%` is written as a ratio of two filter-aware measures, it recalculates correctly at every level of the report — per department, per age band, per salary slab — and always respects the slicer selections.

## Dashboard Walkthrough

### Page 1 — Attrition Overview *(what is happening, and to whom)*

**KPI strip**

| KPI | Aggregation |
|---|---|
| Employee Count | `COUNT(employeeid)` |
| Attrition Rate | `Attrition%` |
| Average Salary | `AVERAGE(monthlyincome)` |
| Average Salary Hike | `AVERAGE(percentsalaryhike)` |
| Average Tenure | `AVERAGE(yearsatcompany)` |

**Who is leaving?** — Attrition % by Age Group (column), by Gender (donut), by Marital Status (donut)

**Where are they leaving from?** — Attrition % by Job Role (bar), by Department (bar)

**Interactivity** — Department and Job Role slicers, cross-filtering across all visuals, and a page navigator to jump to the drivers page.

### Page 2 — Attrition Drivers & Insights *(why it might be happening)*

**Key drivers of attrition** — Attrition % by Salary Slab (column), by OverTime (donut), by Job Level (bar)

**Tenure and career growth impact** — Attrition % by Years at Company band, and by Years Since Last Promotion band

The same KPI strip and slicers carry over, so a filtered view on page 1 can be followed straight through to root-cause analysis.

## Key Insights

**Who is leaving**
- Single employees aged **18–25** show the highest attrition of any demographic segment.
- Male employees leave at a marginally higher rate than female employees — a gap small enough that gender is not a primary driver.

**Where they are leaving from**
- **Sales Executives** and **Laboratory Technicians** are the most exit-prone roles.
- The **Sales department** is the most vulnerable business unit.

**Why they are leaving**
- Employees in the **lowest salary slabs** leave at a significantly higher rate — compensation is the strongest single signal.
- Employees working **overtime** and those at **lower job levels** show elevated attrition, pointing to workload and limited advancement.
- **Recently joined employees are the least stable**: attrition is concentrated in the earliest tenure band and falls as tenure grows, which flags an onboarding and role-expectation gap.
- Employees with **no recent promotion** leave more often — career stagnation compounds the pay issue.

> Taken together, the profile of a high-risk employee is: young, single, early-tenure, low job level, low salary slab, working overtime, with no recent promotion — most commonly in a Sales or Lab Technician role.

## Business Recommendations

| Finding | Recommended action |
|---|---|
| Low salary slabs drive the most exits | Benchmark entry-band pay against market; prioritise correction for Sales and Lab roles |
| Overtime correlates with attrition | Audit workload distribution; cap sustained overtime and hire to fill structural gaps |
| First-year employees are the least stable | Strengthen onboarding, assign 30/60/90-day check-ins and buddy mentors |
| Promotion gap drives exits | Publish transparent progression ladders; review anyone past a defined promotion-gap threshold |
| Sales & Lab Technician roles concentrate risk | Run stay interviews in these functions before exit interviews become necessary |
| Young, single, entry-level cohort is highest risk | Build a targeted early-career retention programme: learning budget, rotation opportunities, clear time-to-promotion |

## Repository Structure

```
HR-Attrition-Analysis-Dashboard/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── dashboard/
│   └── HR_Attrition_Analysis_Dashboard.pbix
│
├── data/
│   └── hr_employee_data.csv
│
├── sql/
│   ├── 01_create_table.sql
│   └── 02_data_exploration.sql
│
├── dax/
│   └── measures.dax
│
├── assets/
│   ├── page1_attrition_overview.png
│   └── page2_attrition_drivers.png
│
└── docs/
    └── HR_Attrition_Analysis_Report.md
```

## How to Run This Project

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/HR-Attrition-Analysis-Dashboard.git
   ```
2. **Create the database** — run `sql/01_create_table.sql` in PostgreSQL, then load `data/hr_employee_data.csv` into the `public.employee` table.
3. **Open the report** — launch `dashboard/HR_Attrition_Analysis_Dashboard.pbix` in Power BI Desktop (free download).
4. **Point it at your database** — *Transform data → Data source settings → Change Source*, enter your host, database, and credentials, then **Refresh**.
5. *(Optional)* If you do not have PostgreSQL installed, import the CSV directly via **Get Data → Text/CSV** — every measure and visual will work unchanged.

## Skills Demonstrated

- Relational data storage and SQL querying in PostgreSQL
- Connecting Power BI to a live database rather than a flat file
- Data cleaning and feature banding in Power Query
- Star-schema-style modelling with a dedicated measure table
- Writing filter-context-aware DAX (`CALCULATE`, `DIVIDE`)
- Dashboard design: KPI hierarchy, question-led section headers, consistent colour encoding
- Report UX: slicers, cross-filtering, page navigation, embedded insight callouts
- Translating statistical findings into business recommendations

## Possible Extensions

- Add a **Risk Score** measure that flags individual employees by combining the identified drivers
- Layer in **time intelligence** (monthly attrition trend, rolling 12-month rate) if hire/exit dates become available
- Model **cost of attrition** (replacement cost × exits) to give leadership a rupee/dollar figure
- Publish to **Power BI Service** with scheduled refresh and row-level security by department
- Build a **predictive attrition model** (logistic regression / random forest) in Python and feed scores back into the report

## Author

**`Srishti Sah`**
`LinkedIn: https://www.linkedin.com/in/srishti-kumari-632a55355/` · `GitHub: https://github.com/Srishtisha-21` · `srishti1922sha@gmail.com`


