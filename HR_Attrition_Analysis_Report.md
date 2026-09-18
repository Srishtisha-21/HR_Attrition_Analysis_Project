# HR Attrition Analysis — Project Report

**Prepared by:** `Srishti Kumari`
**Tools:** PostgreSQL · Power BI Desktop · DAX · Power Query
**Deliverable:** Two-page interactive Power BI report 
**Date:** `September 2026`



---

## 1. Executive Summary

The organization is losing **`16.08`%** of its workforce — `238` employees out of `1470`. That loss is not spread evenly. It concentrates sharply in a definable segment: young, single, early-tenure employees at low job levels and low salary bands, frequently working overtime and without a recent promotion, most often in **Sales** or **Laboratory Technician** roles.

This is operationally good news. A uniform attrition problem requires a company-wide intervention; a concentrated one can be addressed with targeted action at a fraction of the cost. The analysis below identifies where that action should be aimed.

---

## 2. Objective and Scope

### Objective
Move the organization from a single headline attrition number to a **segmented, driver-level understanding** of turnover, and convert that understanding into specific retention actions.

### Guiding questions
1. What is the overall attrition rate and the headcount profile behind it?
2. Which demographic segments are most likely to leave?
3. Which departments and job roles carry the most attrition risk?
4. Which controllable factors — pay, overtime, job level, tenure, promotion gap — correlate most strongly with leaving?

### Scope and limitations
- The dataset is a **point-in-time snapshot**, one row per employee. It supports cross-sectional comparison, not a time trend.
- The analysis establishes **correlation, not causation**. A high attrition rate in a segment identifies where to investigate, not a proven cause.
- Small segments can show volatile percentages; findings should be read alongside the underlying headcount of each band.
- No exit-interview text, performance ratings over time, or manager-level data were available.

---

## 3. Data and Methodology

### 3.1 Data source
The employee dataset was loaded into a **PostgreSQL** database as `public.employee` and connected to Power BI through the native PostgreSQL connector. Using a database rather than a flat CSV mirrors a production reporting setup, where the BI layer reads from a governed source that can be refreshed.

### 3.2 Data preparation (Power Query)
- Validated data types across all columns; `employeeid` confirmed unique (grain check).
- Checked for nulls and duplicate employee records.
- Standardised categorical values (`attrition`, `overtime`, `gender`, `maritalstatus`).
- Created **banded columns** so that continuous variables could be read as business segments:

| Derived column | Built from | Why |
|---|---|---|
| `agegroup` | `age` | Life-stage comparison instead of 40+ distinct ages |
| `salaryslab` | `monthlyincome` | Exposes pay-band effects that a scatter of salaries hides |
| `YearsAtCompany Group` | `yearsatcompany` | Isolates the early-tenure risk window |
| `YearSinceLastPromotion Group` | `yearssincelastpromotion` | Quantifies career-stagnation effect |

### 3.3 Data model
A single fact-style table (`public employee`) plus a **dedicated measure table** (`DAX_Measure`) holding no data. This keeps metric logic centralised and discoverable, and prevents measures from being scattered across the column list.

### 3.4 Metric definitions

```dax
Total Employees =
COUNT('public employee'[employeeid])

Attrition Count =
CALCULATE(
    COUNT('public employee'[employeeid]),
    'public employee'[attrition] = "Yes"
)

Attrition% =
DIVIDE([Attrition Count], [Total Employees], 0)
```

`Attrition%` is expressed as a ratio of two filter-aware measures, so it evaluates correctly inside any slicer selection or chart category — the same measure drives all ten visuals across both pages.

### 3.5 Report design
Two pages, each following an identical layout logic: a **KPI strip** across the top, two **question-led sections** below it, and an **insight callout** on the right of each section so a reader gets the takeaway without interpreting the chart themselves. Department and Job Role slicers are repeated on both pages and a page navigator links them, so a filtered investigation carries across the report.

---

## 4. Findings

### 4.1 Headline metrics

| KPI | Value | Read |
|---|---|---|
| Employee Count | `1470` | Total workforce in scope |
| Attrition Rate | `16.08`% | Share of employees who have left |
| Average Monthly Salary | `6.05K` | Compensation baseline |
| Average Salary Hike | `15.21`% | Appraisal generosity baseline |
| Average Tenure | `7.01` yrs | Workforce maturity |

### 4.2 Who is leaving

**Age.** Attrition is highest in the **18–25 band** and declines steadily with age. Early-career employees are still exploring the market, carry lower switching costs and have the least accumulated organizational equity.

**Marital status.** **Single** employees leave at the highest rate. This compounds with the age finding rather than standing apart from it — the two describe overlapping populations with high mobility.

**Gender.** Male employees leave at a **marginally** higher rate than female employees. The gap is small, and gender should be treated as a descriptive attribute rather than an actionable driver.

> **Highest-risk demographic profile: single employees aged 18–25.**

### 4.3 Where they are leaving from

**By job role.** **Sales Executives** and **Laboratory Technicians** post the highest attrition of all roles. Both are high-volume, high-pressure, entry-heavy positions — Sales carries target pressure and variable pay, Lab Technician carries repetitive workload with a narrow promotion path.

**By department.** **Sales** is the most vulnerable department, consistent with the role-level finding.

The concentration matters: when attrition clusters in two roles inside one department, a targeted intervention reaches most of the problem.

### 4.4 Why they are leaving — key drivers

**Compensation.** Attrition falls as salary slab rises; employees in the **lowest pay bands leave at a materially higher rate**. This is the strongest single driver in the report and the most directly fixable.

**Overtime.** Employees flagged as working **overtime** show a clearly higher attrition rate than those who do not — a workload and burnout signal, and a structural staffing signal where overtime is chronic rather than seasonal.

**Job level.** Attrition is concentrated at the **lowest job levels** and falls as level rises. Together with the pay finding, this describes the same population from two angles: junior employees, underpaid relative to the market, with limited visibility of advancement.

### 4.5 Tenure and career growth

**Tenure.** Attrition is heaviest among **recently joined employees** and declines as tenure increases. Early exits typically signal a gap between the role as advertised and the role as experienced, weak onboarding, or poor manager fit — all addressable within the first 90 days.

**Promotion gap.** Employees with **no recent promotion** leave more often. Stagnation acts as a slow-burn driver: it rarely triggers an immediate exit but steadily reduces the cost of accepting an outside offer.

### 4.6 The composite risk profile

The drivers are not independent — they describe one population seen through six lenses:

> **Young · single · first years at the company · lowest job level · lowest salary slab · working overtime · no recent promotion · Sales or Lab Technician role.**

Any employee matching four or more of these attributes should be treated as a retention priority.

---

## 5. Recommendations

### Immediate (0–3 months)
1. **Pay-band audit for the lowest salary slabs**, starting with Sales Executive and Laboratory Technician. Benchmark against market and correct the largest gaps first.
2. **Overtime audit.** Identify employees with sustained overtime, redistribute workload, and treat chronic overtime as a hiring requisition rather than a scheduling issue.
3. **Stay interviews** with currently employed staff in the high-risk profile. Exit interviews explain losses; stay interviews prevent them.

### Short term (3–6 months)
4. **Rebuild first-year onboarding**: structured 30/60/90-day check-ins, an assigned buddy, and explicit role-expectation setting at offer stage to close the advertised-vs-actual gap.
5. **Publish progression ladders** with indicative time-to-promotion per job level, so advancement is visible rather than assumed.
6. **Promotion-gap review**: flag every employee past a defined threshold without a promotion or role change and require a documented development plan.

### Medium term (6–12 months)
7. **Early-career retention programme** targeting the 18–25 cohort: learning budget, internal rotation, mentorship, and a defined first-promotion milestone.
8. **Department-level attrition ownership**: give Sales leadership a quarterly attrition target and report progress on this dashboard.
9. **Attrition cost model**: quantify replacement cost per exit and per department to size the business case for the pay correction in Recommendation 1.

---

## 6. Impact of the Deliverable

- Replaces a single company-wide attrition number with **segment-level visibility** across nine dimensions.
- Lets HR business partners **self-serve**: any department or role can be filtered without a new analysis request.
- Converts analysis into **six named, ownable interventions** rather than a general observation that attrition is high.
- Provides a repeatable measurement surface — once refresh is scheduled, the same report tracks whether the interventions worked.

---

## 7. Next Steps

| Enhancement | Value added |
|---|---|
| Employee-level **risk score** combining the identified drivers | Moves from segment analysis to a named watch-list |
| **Time-intelligence** page (monthly trend, rolling 12-month rate) | Enables before/after measurement of interventions |
| **Cost-of-attrition** measure | Frames retention spend against avoided cost |
| **Predictive model** (logistic regression / random forest) in Python | Probability of exit per employee, fed back into the report |
| Publish to **Power BI Service** with RLS by department | Secure self-service access for department heads |

---

## Appendix A — Visual Inventory

| Page | Section | Visual | Fields |
|---|---|---|---|
| 1 | KPI strip | 5 cards | Count of `employeeid`, `Attrition%`, Avg `monthlyincome`, Avg `percentsalaryhike`, Avg `yearsatcompany` |
| 1 | Who is Leaving? | Column chart | `Attrition%` by `agegroup` |
| 1 | Who is Leaving? | Donut | `Attrition%` by `gender` |
| 1 | Who is Leaving? | Donut | `Attrition%` by `maritalstatus` |
| 1 | Where are they leaving from? | Bar | `Attrition%` by `jobrole` |
| 1 | Where are they leaving from? | Bar | `Attrition%` by `department` |
| 2 | Key Drivers | Column chart | `Attrition%` by `salaryslab` |
| 2 | Key Drivers | Donut | `Attrition%` by `overtime` |
| 2 | Key Drivers | Bar | `Attrition%` by `joblevel` |
| 2 | Tenure & Career Growth | Column chart | `Attrition%` by `YearsAtCompany Group` |
| 2 | Tenure & Career Growth | Column chart | `Attrition%` by `YearSinceLastPromotion Group` |
| Both | Filters | 2 slicers per page | `department`, `jobrole` |
| Both | Navigation | Page navigator | — |

## Appendix B — Reproducing the Analysis

1. Restore the dataset into PostgreSQL using `sql/01_create_table.sql`.
2. Open the `.pbix` file in Power BI Desktop.
3. Update the data source credentials under *Transform data → Data source settings*.
4. Refresh. All measures and visuals recalculate from the database.
