# Customer Support Analytics - Data Architecture

## Overview

The Customer Support Analytics project is an end-to-end analytics engineering solution designed to transform raw customer support ticket data into reliable analytical datasets and interactive business intelligence dashboards.

The project follows a modern analytics workflow:

**Raw Data → Data Transformation → Data Quality Validation → Analytical Data Models → BI Dashboard**

The objective is to provide visibility into:

* Customer support workload
* Response and resolution performance
* Customer satisfaction trends
* Product-related issues
* Customer behaviour patterns

---

# Architecture Overview

```
Raw Customer Support Data (CSV)
              |
              v
        Data Loading Layer
              |
              v
        dbt Staging Models
              |
              v
     Intermediate Transformation Layer
              |
              v
        Analytics Mart Layer
              |
              v
       Data Quality Testing
              |
              v
       Parquet Data Exports
              |
              v
          Power BI Dashboard
```

---

# Technology Stack

| Component             | Technology         |
| --------------------- | ------------------ |
| Data Storage          | DuckDB             |
| Data Transformation   | dbt Core           |
| Data Modeling         | SQL                |
| Data Quality Testing  | dbt Tests          |
| Data Export Format    | Apache Parquet     |
| Business Intelligence | Microsoft Power BI |
| Analysis Environment  | Jupyter Notebook   |
| Version Control       | Git/GitHub         |

---

# Data Pipeline Layers

## 1. Raw Data Layer

### Source

The project begins with raw customer support ticket records stored as CSV data.

Location:

```
raw_data/
└── customer_support_tickets.csv
```

The dataset contains information including:

* Ticket details
* Customer information
* Product information
* Support channels
* Response timestamps
* Resolution timestamps
* Customer satisfaction ratings

The raw dataset is loaded into DuckDB for analytical processing.

---

# 2. Staging Layer

Location:

```
models/staging/
└── stg_customer_support_tickets.sql
```

The staging layer performs initial data preparation.

Responsibilities:

* Standardize column names
* Clean raw fields
* Prepare source data for downstream transformations
* Maintain a consistent structure

The staging model represents the cleaned version of the source dataset without applying major business logic.

---

# 3. Intermediate Transformation Layer

Location:

```
models/intermediate/
└── int_ticket_performance.sql
```

The intermediate layer applies reusable business transformations.

Responsibilities:

* Create calculated performance fields
* Prepare ticket-level metrics
* Handle timestamp calculations
* Support downstream dimensional modeling

This layer separates business logic from final reporting tables.

---

# 4. Analytics Mart Layer

Location:

```
models/marts/
```

The mart layer contains analytical tables optimized for reporting.

The project uses a dimensional modeling approach.

---

## Fact Table

### fact_ticket_metrics

Location:

```
models/marts/
└── fact_ticket_metrics.sql
```

The fact table contains ticket-level performance metrics.

Grain:

> One row represents one customer support ticket.

Contains:

* Ticket identifiers
* Customer keys
* Product keys
* Ticket classifications
* Support performance metrics
* Customer satisfaction measurements

Key metrics include:

* Resolution hours
* Response time quality flags
* Customer satisfaction ratings

---

## Dimension Tables

### dim_customers

Stores customer attributes.

Contains:

* Customer ID
* Customer name
* Customer email
* Customer age
* Customer gender

Used for:

* Customer segmentation
* Satisfaction analysis
* Customer behaviour reporting

---

### dim_products

Stores product information.

Contains:

* Product ID
* Product name

Used for:

* Product issue analysis
* Support volume analysis
* Product performance reporting

---

# Data Quality Framework

Data quality checks are implemented using dbt tests.

Location:

```
tests/
```

Implemented validations include:

## Completeness Checks

Ensures required fields are populated.

Examples:

* Ticket IDs cannot be null
* Customer information cannot be missing
* Product names must exist

---

## Uniqueness Checks

Ensures key identifiers are unique.

Examples:

* Customer IDs
* Product IDs
* Ticket IDs

---

## Validity Checks

Ensures values fall within expected ranges.

Examples:

* Valid ticket priorities
* Valid ticket channels
* Valid satisfaction ratings

---

## Business Rule Checks

Custom tests validate analytical assumptions.

Examples:

* Resolution hours must be positive
* Ticket counts remain consistent

---

# BI Data Export Layer

Location:

```
exports/
```

The final dbt models are exported as Parquet files.

Generated files:

```
exports/

├── fact_ticket_metrics.parquet
├── dim_customers.parquet
└── dim_products.parquet
```

Parquet was selected because it provides:

* Efficient column-based storage
* Faster Power BI loading
* Reduced file size
* Compatibility with analytical workflows

---

# Business Intelligence Layer

Tool:

Microsoft Power BI

The exported analytical tables power a three-page dashboard.

Dashboard pages:

## Page 1: Support Overview

Focus:

* Overall support workload
* Ticket distribution
* Customer satisfaction overview

---

## Page 2: Support Performance

Focus:

* Response efficiency
* Resolution performance
* Operational effectiveness

---

## Page 3: Products & Customers

Focus:

* Product-related issues
* Customer behaviour
* Satisfaction patterns

---

# Project Workflow

The complete workflow is:

```
1. Load raw CSV data
        |
        v
2. Explore and validate dataset
        |
        v
3. Build dbt transformation models
        |
        v
4. Run automated data quality tests
        |
        v
5. Export analytical models
        |
        v
6. Build Power BI dashboard
        |
        v
7. Generate business insights
```

---

# Future Improvements

Potential enhancements:

* Add automated scheduled data refresh
* Deploy dbt transformations through CI/CD
* Add cloud data warehouse support
* Introduce SLA monitoring
* Add predictive models for ticket volume forecasting
* Implement customer churn prediction
* Add natural language processing for ticket categorization

---

# Summary

This project demonstrates a complete analytics engineering workflow by combining SQL transformation, dimensional modeling, automated data validation, analytical exports, and business intelligence reporting.

The architecture ensures that business users receive accurate, reliable, and actionable insights from customer support data.
