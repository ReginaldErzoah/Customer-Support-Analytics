# Customer Support Analytics - Data Dictionary

## Overview

This document describes the structure, purpose, and business meaning of the analytical datasets created in the Customer Support Analytics project.

The project follows a dimensional modeling approach consisting of:

* One fact table containing customer support ticket performance metrics
* Two dimension tables containing customer and product attributes

The analytical model is designed to support reporting and dashboard development in Power BI.

---

# Data Model Overview

The analytical warehouse follows a star schema design:

```
                 dim_customers
                       |
                       |
                       |
dim_products ---- fact_ticket_metrics
```

## Fact Table

| Table               | Description                                                                      |
| ------------------- | -------------------------------------------------------------------------------- |
| fact_ticket_metrics | Contains individual customer support tickets and operational performance metrics |

## Dimension Tables

| Table         | Description                           |
| ------------- | ------------------------------------- |
| dim_customers | Contains customer profile information |
| dim_products  | Contains product information          |

---

# Fact Table: fact_ticket_metrics

## Description

The fact table represents customer support ticket activity.

### Grain

> One row represents one customer support ticket.

This table is optimized for analyzing:

* Support workload
* Response performance
* Resolution efficiency
* Customer satisfaction

---

## Columns

| Column                       | Data Type | Description                                                |
| ---------------------------- | --------- | ---------------------------------------------------------- |
| ticket_id                    | Integer   | Unique identifier for each support ticket                  |
| customer_id                  | String    | Surrogate key linking the ticket to the customer dimension |
| product_id                   | String    | Surrogate key linking the ticket to the product dimension  |
| ticket_type                  | String    | Category of support request                                |
| ticket_status                | String    | Current status of the ticket                               |
| ticket_priority              | String    | Priority level assigned to the ticket                      |
| ticket_channel               | String    | Channel through which the customer contacted support       |
| product_name                 | String    | Name of the product associated with the ticket             |
| purchase_date                | Date      | Date the customer purchased the product                    |
| first_response_time          | Timestamp | Original timestamp when support first responded            |
| time_to_resolution           | Timestamp | Original timestamp when the issue was resolved             |
| cleaned_first_response_time  | Timestamp | Corrected first response timestamp after quality checks    |
| cleaned_resolution_time      | Timestamp | Corrected resolution timestamp after quality checks        |
| response_time_quality_flag   | String    | Indicates whether timestamp values were valid or corrected |
| resolution_hours             | Decimal   | Total hours taken to resolve the customer issue            |
| customer_satisfaction_rating | Integer   | Customer rating after support interaction                  |

---

# Fact Table Metrics

## Resolution Hours

### Definition

Measures the time required to resolve a customer support issue.

Formula:

```
Resolution Time =
Resolution Timestamp - First Response Timestamp
```

Business Use:

* Measure support efficiency
* Identify slow ticket categories
* Monitor operational performance

---

## Response Time Quality Flag

### Values

| Value     | Meaning                                                          |
| --------- | ---------------------------------------------------------------- |
| Valid     | Original timestamps were correctly ordered                       |
| Corrected | Timestamp order was reversed and corrected during transformation |

Business Use:

Provides transparency into data quality adjustments.

---

# Dimension Table: dim_customers

## Description

Contains unique customer information extracted from support ticket records.

### Grain

> One row represents one unique customer.

---

## Columns

| Column          | Data Type | Description                                      |
| --------------- | --------- | ------------------------------------------------ |
| customer_id     | String    | Surrogate key generated from customer attributes |
| customer_email  | String    | Customer email address                           |
| customer_name   | String    | Customer full name                               |
| customer_age    | Integer   | Customer age                                     |
| customer_gender | String    | Customer gender category                         |

---

## Customer Dimension Usage

Used for analyzing:

* Customer support activity
* Satisfaction patterns
* Customer demographics
* Customer segmentation

---

# Dimension Table: dim_products

## Description

Contains unique product information associated with customer support tickets.

### Grain

> One row represents one unique product.

---

## Columns

| Column       | Data Type | Description                               |
| ------------ | --------- | ----------------------------------------- |
| product_id   | String    | Surrogate key generated from product name |
| product_name | String    | Product name                              |

---

## Product Dimension Usage

Used for analyzing:

* Products generating the highest support volume
* Product-related issues
* Customer satisfaction by product

---

# Staging Table: stg_customer_support_tickets

## Description

The staging table contains cleaned source data before analytical transformations.

Location:

```
models/staging/
stg_customer_support_tickets.sql
```

---

## Purpose

Responsibilities:

* Standardize raw fields
* Rename columns
* Apply initial cleaning
* Prepare source data for transformation layers

---

# Intermediate Table: int_ticket_performance

## Description

The intermediate model contains reusable business transformations before final analytical marts are created.

Location:

```
models/intermediate/
int_ticket_performance.sql
```

---

## Purpose

Responsibilities:

* Prepare ticket performance calculations
* Apply business rules
* Create reusable transformation logic

---

# Data Quality Rules

The following validation rules are applied using dbt tests.

## Completeness

Required fields:

* ticket_id
* customer information
* product information

---

## Uniqueness

Unique fields:

* ticket_id
* customer_id
* product_id

---

## Valid Values

Validated fields:

* ticket priority
* ticket channel
* ticket status
* ticket type
* customer satisfaction rating

---

## Business Logic Validation

Custom tests verify:

* Resolution hours are positive
* Ticket counts remain consistent
* Duplicate ticket identifiers are detected

---

# Data Refresh Workflow

The analytical data flow is:

```
Raw CSV
   |
   v
stg_customer_support_tickets
   |
   v
int_ticket_performance
   |
   v
fact_ticket_metrics
dim_customers
dim_products
   |
   v
Parquet Exports
   |
   v
Power BI Dashboard
```

---

# Summary

The Customer Support Analytics data model provides a clean analytical foundation for operational reporting.

The combination of fact and dimension tables enables efficient analysis of:

* Support workload
* Operational efficiency
* Customer experience
* Product performance

The documented structure ensures that future analysts and developers can easily understand, maintain, and extend the analytics solution.
