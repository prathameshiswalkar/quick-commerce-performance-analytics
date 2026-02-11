Quick Commerce Performance & Customer Insights Analytics

Project Overview

This project simulates a real-world quick-commerce analytics pipeline, beginning from synthetic data generation and extending through advanced SQL modeling to an interactive Power BI dashboard.

The objective was to design a complete end-to-end analytics workflow that fulfills structured academic and business reporting criteria using:

Python for data generation and preprocessing

Excel for initial validation and inspection

MySQL for relational modeling and advanced SQL analytics

Power BI for multi-page interactive business dashboard reporting

This project replicates how organizations transform raw transactional data into structured business insights.

Project Objectives

The project was designed to satisfy the following requirements.

Power BI Report Requirements

Multiple related tables

Date-time columns with full timestamp tracking

Multi-page interlinked dashboard (more than 3 pages)

20+ KPIs including percentage change metrics

PPT Documentation Requirements

Title

Acknowledgement

Objective and Motivation

Data Ingestion Steps

Data Cleaning and Preprocessing

Data Analysis and Business Insights

SQL Query Snapshots

Dashboard Screenshots

Key Insights

Future Work

Resources

SQL Requirements

Queries for all KPIs

Queries for all major charts

Advanced SQL techniques including CTEs, Window Functions, Subqueries, Joins, Ranking, Rolling Calculations, and Cohort Analysis

End-to-End Workflow

Step 1 – Data Generation (Python)

Synthetic data was generated using Python scripts to simulate:

150,000 customers

900,000+ orders

900,000+ transactions

Product catalog with perishable tagging

Order lifecycle tracking from placed to delivered or cancelled

A structured date dimension table

The dataset includes detailed timestamp columns such as order timestamps, payment timestamps, delivery timestamps, ETA values, and city-level distribution to simulate realistic quick-commerce operations.

Step 2 – Initial Data Validation (Excel)

Before importing into SQL:

CSV files were reviewed in Excel

Column structures validated

Date formats verified

Null values inspected

Boolean values standardized

Duplicate records checked

This ensured clean schema alignment before database ingestion.

Step 3 – Data Cleaning and Transformation (Python)

Using Pandas:

City names were standardized

Boolean conversions handled

Null values identified and treated

Data types corrected

Timestamp formatting verified

Cleaned data exported for SQL import

This stage ensured data integrity before loading into MySQL.

Step 4 – Database Modeling (MySQL)

A structured relational schema was created with the following tables:

customers

orders

products

transactions

order_status_logs

date_dim

Analytical Views Created

vw_order_fact

vw_order_lifecycle

vw_payments_fact

Indexes were created to optimize queries involving:

Order timestamps

Customer joins

Product joins

Payment joins

This replicates industry-grade database design practices.

Advanced SQL Analytics

The project implements more than 25 KPIs across revenue, customer, operational, product, and payment domains.

Revenue Metrics

Total Revenue

Revenue Month-over-Month percentage

Revenue per Customer

Revenue Share percentage for Top Products

Pareto 80/20 Product Analysis

Customer Metrics

Total Customers

Repeat Customer percentage

Orders per Customer

Customer Lifetime Value

Cohort Retention Analysis

Delivery Metrics

On-Time Delivery percentage

Delayed Orders percentage

SLA Breach percentage

Average Delivery Time

90th Percentile Delivery Time

Product Metrics

Top 10 Products by Revenue

Perishable Revenue percentage

Top Products Per City using Window Ranking

Payment Metrics

Total Transactions

Payment Success Rate percentage

Failed Payment percentage

Rolling 7-Day Payment Failure percentage

Payment Mode Distribution

Advanced SQL Techniques Used

Common Table Expressions (CTEs)

Window Functions including RANK, ROW_NUMBER, SUM OVER, and LAG

Rolling Averages

Conditional Aggregation

Cohort Analysis Logic

Timestamp difference calculations

Multi-table joins

Cumulative revenue calculations

This demonstrates analytical SQL depth beyond basic aggregation.

Power BI Dashboard

The final dashboard includes seven interlinked pages:

Summary Dashboard

City and Delivery Performance

Customer and Product Insights

City Details (Drill-through)

Customer Details (Drill-through)

Product Details (Drill-through)

Payment Details

Features include:

Date slicers

Drill-through navigation

KPI cards

Trend analysis

Conditional formatting

Interactive filtering

Cross-page navigation

Dashboard Preview

Summary Page
(Insert image link)

City and Delivery Performance
(Insert image link)

Customer and Product Insights
(Insert image link)

Payment Analytics
(Insert image link)

Presentation Deliverables

The presentation includes:

Problem statement

Data pipeline explanation

SQL query screenshots

Dashboard visuals

Business interpretation

Key insights

Strategic recommendations

Future roadmap

The presentation file is available in the presentation folder.

Key Business Insights

Revenue is concentrated among top-performing products, indicating a Pareto distribution.

Repeat customer rate significantly contributes to overall revenue stability.

Certain cities demonstrate higher SLA breach patterns.

Payment failures show rolling volatility patterns over time.

Perishable category contributes a measurable share of total revenue.

Customer lifetime value distribution indicates revenue concentration among high-value customers.

Future Improvements

Churn prediction modeling

Real-time data pipeline integration

Predictive ETA modeling

RFM segmentation

Customer clustering

Time-series forecasting

Tools Used

Python (Pandas, NumPy)

Excel

MySQL

Power BI Desktop

Git and Git LFS

Repository Structure

data/
python/
sql/
images/
presentation/

Project Highlights

900,000+ transactional records

20+ business KPIs

7-page interactive dashboard

Advanced SQL analytics implementation

Structured relational modeling

End-to-end analytics pipeline

Conclusion

This project demonstrates the complete lifecycle of a data analytics solution, from raw data generation to executive-level reporting.

It reflects strong SQL capabilities, structured database modeling, analytical thinking, business KPI design, and dashboard storytelling.
