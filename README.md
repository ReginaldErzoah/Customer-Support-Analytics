# Customer Support Analytics

A complete end-to-end Business Intelligence analytics project that transforms raw customer support ticket data into a reliable analytical data model using **DuckDB, dbt, Python, and Power BI**.

The project focuses on understanding support performance, customer experience, product issues, and operational efficiency through a modern analytics engineering workflow.

---

# Project Overview

Customer support teams generate large volumes of operational data including:

* Customer inquiries
* Technical issues
* Refund requests
* Cancellation requests
* Product-related problems
* Response and resolution timelines
* Customer satisfaction ratings

This project builds a scalable analytics pipeline that cleans, validates, transforms, and models customer support data into business-ready datasets for reporting and decision-making.

---

# Business Objectives

The project answers key business questions such as:

### Support Performance

* How many support tickets are received?
* How quickly are customers receiving responses?
* Which ticket categories take the longest to resolve?
* Are resolution times improving?

### Customer Experience

* What is the average customer satisfaction score?
* Which customers generate the most support interactions?
* Which channels receive the most complaints?

### Product Performance

* Which products generate the highest number of support tickets?
* Which products require attention based on customer issues?

### Data Quality

* Are ticket records complete?
* Are there duplicate tickets?
* Are performance metrics reliable?

---

# Technology Stack

| Area | Technology | Purpose |
|---|---|---|
| Data Processing | Python | Data loading, exploration, validation, and analytical processing |
| Data Processing | Pandas | Data manipulation and exploratory data analysis |
| Data Processing | NumPy | Numerical computations and data transformations |
| Database | DuckDB | Local analytical database used as the data warehouse layer |
| Data Transformation | SQL | Querying, data cleaning, and transformation logic |
| Analytics Engineering | dbt | Data modeling, testing, documentation, and transformation workflow |
| Analytics Engineering | dbt-utils | Utility macros including surrogate key generation |
| Data Quality | dbt Tests | Automated validation of completeness, uniqueness, and business rules |
| Data Storage | CSV | Raw source data format |
| Data Storage | Parquet | Optimized analytical file format used for Power BI exports |
| Business Intelligence | Power BI | Interactive dashboards, KPI reporting, and business insights |
| Visualization | Matplotlib | Data visualization during exploratory analysis |
| Visualization | Seaborn | Statistical visualization and analytical charts |
| Visualization (UI/UX)| Figma | Design of BI report backgrounds |
| Development Environment | Jupyter Notebook | Interactive analysis, experimentation, and documentation |
| Version Control | Git | Source control and project version management |
| Version Control | GitHub | Repository hosting and portfolio showcase |
| Documentation | Markdown | Project documentation and technical reporting |

---

# Project Architecture

```
Raw Data
   |
   |
   v
CSV Dataset
   |
   |
   v
DuckDB Database
   |
   |
   v
dbt Transformations
   |
   |
   +----------------+
   |                |
   v                v
Dimensions       Fact Table
   |                |
   |                |
   +----------------+
            |
            v
     Data Quality Tests
            |
            v
     Parquet Exports
            |
            v
       Power BI Dashboard
```

---

# Data Model

The project follows a dimensional modeling approach.

## Fact Table

### fact_ticket_metrics

Contains ticket-level performance metrics.

Key fields:

* ticket_id
* customer_id
* product_id
* ticket_type
* ticket_status
* ticket_priority
* ticket_channel
* first_response_time
* time_to_resolution
* resolution_hours
* customer_satisfaction_rating

---

## Dimension Tables

### dim_customers

Customer information:

* customer_id
* customer_email
* customer_name
* customer_age
* customer_gender

### dim_products

Product information:

* product_id
* product_name

---

# dbt Transformation Workflow

The dbt pipeline contains three main layers.

## 1. Staging Layer

Location:

```
models/staging/
```

Purpose:

* Load raw source tables
* Standardize column names
* Prepare clean source data

Model:

```
stg_customer_support_tickets.sql
```

---

## 2. Intermediate Layer

Location:

```
models/intermediate/
```

Purpose:

* Create reusable business logic
* Prepare analytical transformations

Model:

```
int_ticket_performance.sql
```

---

## 3. Mart Layer

Location:

```
models/marts/
```

Purpose:

Create final analytical tables.

Models:

```
fact_ticket_metrics.sql

dim_customers.sql

dim_products.sql
```

---

# Data Quality Framework

The project includes automated dbt tests to ensure reliable reporting.

Tests implemented:

## Completeness Tests

Examples:

* Customer IDs cannot be null
* Product names cannot be null
* Ticket IDs cannot be null

## Uniqueness Tests

Examples:

* Unique customer IDs
* Unique product IDs
* Unique ticket IDs

## Validity Tests

Examples:

* Ticket priority values
* Ticket channels
* Ticket categories
* Satisfaction ratings

## Custom Business Tests

Additional tests include:

```
assert_positive_resolution_hours.sql
```

Ensures resolution times are valid.

```
assert_valid_satisfaction_rating.sql
```

Ensures satisfaction ratings remain within expected ranges.

```
assert_no_duplicate_ticket_ids.sql
```

Checks duplicate ticket records.

---

# Handling Data Quality Issues

During development, timestamp inconsistencies were discovered where:

```
first_response_time > time_to_resolution
```

This created negative resolution durations.

A cleaning layer was introduced in:

```
fact_ticket_metrics.sql
```

The model now:

* Detects incorrect timestamp ordering
* Swaps invalid timestamps
* Creates quality monitoring flags

Example:

```
response_time_quality_flag
```

Values:

* Valid
* Corrected

This ensures reporting metrics remain accurate.

---

# Analytics Notebook Workflow

The project contains analytical notebooks:

```
notebooks/

00_load_raw_data.ipynb

01_data_exploration.ipynb

02_data_quality_checks.ipynb

03_customer_support_analysis.ipynb

04_powerbi_exports.ipynb
```

---

## Notebook Purpose

### 00_load_raw_data

Loads raw CSV data into DuckDB.

---

### 01_data_exploration

Explores:

* Dataset structure
* Missing values
* Data distributions
* Initial observations

---

### 02_data_quality_checks

Performs:

* Duplicate checks
* Missing value analysis
* Data validation

---

### 03_customer_support_analysis

Creates analytical insights around:

* Ticket trends
* Support categories
* Resolution performance
* Customer satisfaction

---

### 04_powerbi_exports

Exports dbt models into Parquet files.

Generated files:

```
exports/

dim_customers.parquet

dim_products.parquet

fact_ticket_metrics.parquet
```

---

# Power BI Dashboard

The final dashboard contains three pages.

---

# Page 1: Support Overview

Purpose:

Executive summary of customer support operations.

KPIs:

* Total Tickets
* Unique Customers
* Average Satisfaction Score
* Average Resolution Hours
* Report Date Range

Visuals:

* Ticket volume trend
* Ticket type distribution
* Priority breakdown
* Channel performance

---

# Page 2: Support Performance

Purpose:

Analyze operational efficiency.

KPIs:

* Average First Response Hours
* Average Resolution Hours
* Critical Ticket Percentage
* Closed Ticket Percentage
* Customer Satisfaction Score

Visuals:

* Resolution time by ticket type
* Priority performance
* Response efficiency
* Ticket status analysis

---

# Page 3: Products & Customers

Purpose:

Identify product issues and customer behavior.

KPIs:

* Customers Supported
* Tickets per Customer
* Top Product Issues
* Average Customer Satisfaction

Visuals:

* Tickets by product
* Customer ticket frequency
* Product issue ranking
* Customer satisfaction distribution

---

# Repository Structure

```
Customer Support Analytics/

│
├── dashboard/
│   ├── Customer Support Analytics.pbix
│   └── Screenshots/
│
├── dbt_packages/
│
├── exports/
│   ├── dim_customers.parquet
│   ├── dim_products.parquet
│   └── fact_ticket_metrics.parquet
│
├── models/
│   ├── staging/
│   ├── intermediate/
│   └── marts/
│
├── notebooks/
│
├── raw_data/
│   └── customer_support_tickets.csv
│
├── tests/
│
├── customer_support.duckdb
│
├── dbt_project.yml
│
└── README.md
```

---

# Running the Project Locally

## 1. Clone Repository

```
git clone <repository-url>

cd Customer-Support-Analytics
```

---

## 2. Create Environment

```
python -m venv dbt-env
```

Activate:

Windows:

```
dbt-env\Scripts\activate
```

---

## 3. Install Dependencies

```
pip install -r requirements.txt
```

---

## 4. Install dbt Packages

```
dbt deps
```

---

## 5. Run dbt Models

```
python -m dbt.cli.main run
```

---

## 6. Run Data Tests

```
python -m dbt.cli.main test
```

---

## 7. Generate Power BI Data Files

Run:

```
04_powerbi_exports.ipynb
```

This creates Parquet files inside:

```
exports/
```

---

# Key Insights Generated

Examples of insights discovered:

* Refund requests were the most common support category.
* Technical issues represented a significant portion of customer interactions.
* Customer satisfaction averaged approximately 3/5.
* Support volume was distributed relatively evenly across communication channels.
* Certain products generated higher support demand and require investigation.
* Automated validation improved trust in reporting metrics.

---

# Future Improvements

Potential enhancements:

## Data Engineering

* Deploy DuckDB warehouse to cloud storage
* Add scheduled pipelines
* Introduce orchestration with Airflow

## Analytics

* Add forecasting models
* Predict ticket escalation risk
* Identify churn indicators

## Machine Learning

Possible models:

* Ticket priority prediction
* Resolution time prediction
* Customer satisfaction prediction

---

# Author

**Reginald Erzoah**

Data Analyst | Business Intelligence Analyst | ML Engineer

Portfolio:

```
reginalderzoah.github.io
```

GitHub:

```
github.com/ReginaldErzoah
```

---

# License

This project is licensed under the MIT License.
