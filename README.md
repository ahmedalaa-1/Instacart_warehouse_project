# Instacart Data Warehouse

A complete **Data Warehouse project built with SQL Server 2022**, transforming raw Instacart CSV data into clean, validated, and analytics-ready data using a **Medallion Architecture**.

> **Note:** The Power BI analysis and dashboards built on top of this Data Warehouse are available in a **separate repository**.

**Data Flow:**

`Original Data → Bronze → Silver → Gold → Power BI`

---

## 🏗️ Architecture

The project follows a layered Data Warehouse architecture where each layer transforms and improves the data before passing it to the next stage.

<!-- Add your Architecture Diagram here -->

![Instacart Data Warehouse Architecture](Architecture Diagram.png
)

---

## 🎯 Project Objectives

* Build an end-to-end Data Warehouse using SQL Server 2022.
* Transform raw Instacart CSV files into structured warehouse layers.
* Apply data cleaning and validation rules.
* Resolve invalid relationships and inconsistent data.
* Perform Data Quality checks throughout the transformation process.
* Build fact and dimension tables for analytical use.
* Create a Gold Layer ready for BI and analytical workloads.
* Apply dimensional modeling principles and a Star Schema.

---

## 🗂️ Source Data

The project uses the following Instacart datasets:

| File                       | Description                           |
| -------------------------- | ------------------------------------- |
| `orders.csv`               | Customer order information            |
| `products.csv`             | Product details                       |
| `aisles.csv`               | Product aisle information             |
| `departments.csv`          | Product department information        |
| `order_products_prior.csv` | Products purchased in prior orders    |
| `order_products_train.csv` | Products purchased in training orders |

---

# 🥉 Bronze Layer

The Bronze Layer stores the source data in SQL Server while keeping it close to its original structure.

### Main Activities

* Loaded CSV files into SQL Server.
* Preserved the original source structure.
* Created raw tables for the source datasets.
* Created intentionally messy datasets for Data Quality testing.
* Validated row counts and schema consistency.
* Identified potential data-quality issues before transformation.

### Main Tables

* `raw_orders`
* `raw_products`
* `raw_aisles`
* `raw_departments`
* `raw_order_products_prior`
* `raw_order_products_train`

---

# 🥈 Silver Layer

The Silver Layer transforms the raw data into clean, standardized, and validated datasets.

### Data Cleaning & Transformation

* Standardized text using `TRIM()` and `UPPER()`.
* Validated and standardized IDs.
* Removed invalid relationships.
* Handled NULL values appropriately.
* Checked for duplicate records.
* Validated business rules.
* Validated relationships between entities.
* Standardized order-related attributes.
* Combined and transformed transactional data where required.

The main goal of the Silver Layer is to ensure that only reliable and consistent data reaches the analytical model.

---

# 🥇 Gold Layer

The Gold Layer contains the final analytical model designed for BI and reporting workloads.

The model follows a **Star Schema** approach, separating transactional facts from descriptive dimensions.

### Dimensions

#### `gold.dim_products`

Contains product-level information including:

* Product ID
* Product Name
* Department ID
* Department Name
* Aisle ID
* Aisle Name

#### `gold.dim_users`

Contains unique customer/user identifiers.

---

### Fact Tables

#### `gold.fact_orders`

Contains order-level information including:

* Order ID
* User ID
* Order Sequence
* Order Day of Week
* Order Hour
* Days Since Prior Order
* Evaluation Set

#### `gold.fact_order_products`

Contains product-level order transactions including:

* Order ID
* Product ID
* Add-to-Cart Order
* Reordered Flag

---

# ⭐ Data Model

The Gold Layer provides a structured analytical model for downstream BI and analytics.

```text
                  dim_products
                       │
                       │
                       ▼
dim_users ────── fact_order_products
                       │
                       │
                       ▼
                  fact_orders
```

The Gold Layer supports analysis of:

* Customer behavior
* Product performance
* Reordering behavior
* Department performance
* Aisle performance
* Order timing
* Customer order patterns

---

# 🔍 Data Quality

Data Quality checks were performed throughout the pipeline to ensure the reliability of the final Gold Layer.

The validation process covered areas such as:

* Duplicate records
* NULL values
* Invalid IDs
* Invalid relationships
* Referential integrity
* Text standardization
* Business rule validation
* Transaction consistency

The purpose was to prevent invalid or inconsistent data from propagating into the analytical layer.

---

# 📊 Power BI

The Gold Layer is used as the data source for a separate **Power BI analysis project**.

The Power BI repository contains the analytical model, dashboards, KPIs, and visualizations built on top of this Data Warehouse.

### Power BI Analysis Includes

* Order & Item Analysis
* Department & Aisle Analysis
* Reorder Analysis
* Customer Segmentation
* Order Timing Analysis
* Day × Hour Order Analysis
* Days Since Prior Order Analysis

> **Power BI Project:**
> Add your Power BI repository link here.

---

# 🛠️ Technologies

| Technology               | Purpose                          |
| ------------------------ | -------------------------------- |
| **SQL Server 2022**      | Data Warehouse                   |
| **T-SQL**                | Data Transformation & Validation |
| **CSV**                  | Source Data                      |
| **Dimensional Modeling** | Analytical Data Model            |
| **Star Schema**          | Gold Layer Architecture          |
| **Power BI**             | Downstream Analytics             |

---

# 📁 Project Structure

```text
Instacart-Data-Warehouse/
│
├── README.md
│
├── docs/
│   └── architecture-diagram.png
│
├── sql/
│   ├── bronze/
│   ├── silver/
│   └── gold/
│
└── ...
```

---

# 🚀 Project Flow

```text
Original CSV Data
        │
        ▼
     BRONZE
 Raw & Structured
        │
        ▼
     SILVER
Clean & Validated
        │
        ▼
      GOLD
Analytics Ready
        │
        ▼
    POWER BI
Separate Repository
```

This project demonstrates an end-to-end Data Warehouse workflow from **raw source data to an analytics-ready Gold Layer**.
