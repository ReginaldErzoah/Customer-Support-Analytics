# DuckDB Connection Setup

## Overview

This project uses DuckDB as the analytical database engine for storing, transforming, and querying customer support data.

DuckDB was selected because it provides:

* Fast analytical SQL execution
* Local file-based database storage
* Compatibility with Python, dbt, and Power BI workflows
* Efficient processing of analytical workloads without requiring a separate database server

The database file used in this project is:

```
customer_support.duckdb
```

---

# Database Architecture

The project follows a layered analytics architecture:

```
Raw CSV Data
     |
     ↓
Staging Models
     |
     ↓
Intermediate Models
     |
     ↓
Mart Models
     |
     ↓
Power BI Dashboard
```

Each layer has a specific responsibility.

---

# Database Location

The DuckDB database file is stored in the project root directory:

```
Customer Support Analytics/
│
├── customer_support.duckdb
├── models/
├── notebooks/
├── dashboard/
└── exports/
```

The database contains all dbt-created models and analytical tables.

---

# Connecting to DuckDB Using Python

DuckDB can be accessed using the Python DuckDB package.

Example:

```python
import duckdb

conn = duckdb.connect(
    "customer_support.duckdb"
)
```

After creating the connection, SQL queries can be executed directly.

Example:

```python
query = """
SELECT *
FROM main.fact_ticket_metrics
LIMIT 10
"""

result = conn.execute(query).df()

result
```

---

# Connecting Through Jupyter Notebooks

The project notebooks use DuckDB for:

* Data exploration
* Data quality checks
* Analytical queries
* Export preparation

Example notebook connection:

```python
import duckdb

conn = duckdb.connect(
    "../customer_support.duckdb"
)
```

The connection object is reused throughout analysis notebooks.

---

# dbt DuckDB Configuration

dbt connects to DuckDB through the `profiles.yml` configuration file.

Example configuration:

```yaml
customer_support_analytics:

  target: dev

  outputs:

    dev:

      type: duckdb

      path: customer_support.duckdb

      threads: 4
```

This allows dbt models to be materialized directly into DuckDB tables.

---

# Querying dbt Models

After running dbt:

```bash
python -m dbt.cli.main run
```

The generated models are available inside DuckDB.

Examples:

```sql
SELECT *
FROM main.fact_ticket_metrics;
```

```sql
SELECT *
FROM main.dim_customers;
```

```sql
SELECT *
FROM main.dim_products;
```

---

# Power BI Integration

Because DuckDB does not have a default Power BI connector, the project exports analytical tables into Parquet files.

Exported tables:

```
exports/

├── fact_ticket_metrics.parquet
├── dim_customers.parquet
└── dim_products.parquet
```

Power BI connects directly to these Parquet files.

This approach provides:

* Faster dashboard loading
* Separation between analytics processing and visualization
* Easy refresh workflow

---

# Development Workflow

The standard workflow is:

1. Load raw CSV data into DuckDB.

2. Run dbt transformations.

```bash
python -m dbt.cli.main run
```

3. Validate models.

```bash
python -m dbt.cli.main test
```

4. Export analytical tables.

5. Refresh Power BI dashboard.

---

# Maintenance Notes

The DuckDB database file should not be manually edited.

All transformations should happen through:

* dbt models
* SQL transformations
* Data quality tests

The database acts as the analytical warehouse layer for the project.
