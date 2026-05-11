# Quick Commerce Performance & Customer Insights Analytics

## Project Overview

This project simulates a real-world quick commerce analytics ecosystem, covering the complete analytics lifecycle — from synthetic data generation and preprocessing to advanced SQL analytics and interactive Power BI dashboard reporting. 

The primary objective of this project was to design an end-to-end business analytics pipeline capable of transforming large-scale transactional data into actionable business insights using industry-standard tools and workflows.

### Tech Stack

* **Python** — Data generation, preprocessing, and transformation
* **Excel** — Initial validation and inspection
* **MySQL** — Relational database modeling and advanced SQL analytics
* **Power BI** — Interactive dashboarding and business intelligence reporting
* **Git & Git LFS** — Version control and project management

---

# Project Objectives

The project was designed to replicate enterprise-level analytics reporting and fulfill structured business intelligence requirements.

## Dashboard Requirements

* Multiple related tables
* Full timestamp-based tracking using date-time columns
* Multi-page interlinked dashboard architecture
* 20+ business KPIs with percentage-based trend metrics
* Drill-through navigation and interactive filtering

## SQL Requirements

* KPI query implementation
* Chart-level analytical queries
* Advanced SQL concepts including:

  * CTEs
  * Window Functions
  * Subqueries
  * Joins
  * Ranking Functions
  * Rolling Calculations
  * Cohort Analysis

## Documentation Requirements

* Project overview
* Data ingestion workflow
* Data cleaning and preprocessing steps
* SQL query documentation
* Dashboard screenshots
* Business insights and recommendations
* Future enhancement roadmap

---

# End-to-End Workflow

## 1. Data Generation (Python)

Synthetic datasets were generated using Python to simulate a scalable quick commerce environment.

### Generated Data Includes

* 150,000 customers
* 900,000+ orders
* 900,000+ transactions
* Product catalog with perishable classification
* Order lifecycle tracking
* Structured date dimension table

### Key Features

* Realistic timestamp simulation
* City-level order distribution
* Delivery ETA calculations
* Payment lifecycle tracking
* Order cancellation handling

---

## 2. Initial Data Validation (Excel)

Before database ingestion:

* CSV structures were verified
* Date formats validated
* Null values inspected
* Boolean fields standardized
* Duplicate records checked

This ensured schema consistency before SQL import.

---

## 3. Data Cleaning & Transformation (Python)

Using **Pandas**, the following preprocessing tasks were performed:

* Standardized city names
* Corrected inconsistent data types
* Handled null values
* Verified timestamp formatting
* Standardized boolean conversions

The cleaned datasets were then exported for database ingestion.

---

## 4. Database Modeling (MySQL)

A structured relational schema was designed with the following tables:

* `customers`
* `orders`
* `products`
* `transactions`
* `order_status_logs`
* `date_dim`

## Analytical Views Created

* `vw_order_fact`
* `vw_order_lifecycle`
* `vw_payments_fact`

## Database Optimization

Indexes were implemented for:

* Order timestamps
* Customer joins
* Product joins
* Payment joins

This replicates real-world analytical database optimization practices.

---

# Advanced SQL Analytics

The project implements **25+ business KPIs** across multiple business domains.

## Revenue Analytics

* Total Revenue
* Revenue Month-over-Month %
* Revenue per Customer
* Revenue Share % for Top Products
* Pareto 80/20 Product Analysis

## Customer Analytics

* Total Customers
* Repeat Customer %
* Orders per Customer
* Customer Lifetime Value (CLV)
* Cohort Retention Analysis

## Delivery Analytics

* On-Time Delivery %
* Delayed Orders %
* SLA Breach %
* Average Delivery Time
* 90th Percentile Delivery Time

## Product Analytics

* Top 10 Products by Revenue
* Perishable Revenue %
* Top Products Per City using Window Ranking

## Payment Analytics

* Total Transactions
* Payment Success Rate %
* Failed Payment %
* Rolling 7-Day Payment Failure %
* Payment Mode Distribution

---

# Advanced SQL Concepts Used

* Common Table Expressions (CTEs)
* Window Functions

  * `RANK()`
  * `ROW_NUMBER()`
  * `SUM() OVER()`
  * `LAG()`
* Rolling Averages
* Conditional Aggregation
* Cohort Analysis
* Timestamp Difference Calculations
* Multi-table Joins
* Cumulative Revenue Calculations

This project demonstrates analytical SQL capabilities beyond basic aggregation and reporting.

---

# Power BI Dashboard

The final Power BI solution includes **7 interactive dashboard pages**:

1. Summary Dashboard
2. City & Delivery Performance
3. Customer & Product Insights
4. City Details (Drill-through)
5. Customer Details (Drill-through)
6. Product Details (Drill-through)
7. Payment Analytics

## Dashboard Features

* Interactive slicers
* KPI cards
* Drill-through navigation
* Trend analysis
* Conditional formatting
* Cross-page filtering
* Interactive visual storytelling

---

# Key Business Insights

* Revenue distribution follows a Pareto pattern, where top-performing products contribute a significant portion of total sales.
* Repeat customers play a major role in revenue stability.
* Certain cities show consistently higher SLA breach percentages.
* Payment failures demonstrate rolling volatility trends over time.
* Perishable products contribute a measurable share of overall platform revenue.
* Customer Lifetime Value analysis indicates revenue concentration among high-value customer segments.

---

# Future Enhancements

* Churn Prediction Modeling
* Predictive ETA Systems
* Real-Time Data Pipeline Integration
* RFM Segmentation
* Customer Clustering
* Time-Series Forecasting

---

# Repository Structure

```bash
├── data/
├── python/
├── sql/
├── images/
├── presentation/
└── README.md
```

---

# Project Highlights

* 900,000+ transactional records
* 25+ business KPIs
* 7-page interactive dashboard
* Advanced SQL analytics implementation
* Structured relational database modeling
* End-to-end analytics pipeline

---

# Conclusion

This project demonstrates the complete lifecycle of a modern analytics solution — from raw data generation to executive-level business reporting.

It highlights:

* Advanced SQL proficiency
* Relational database modeling
* Business KPI design
* Analytical problem-solving
* Dashboard storytelling
* End-to-end data analytics workflow

The project closely mirrors how organizations transform raw operational data into strategic business insights for decision-making.
