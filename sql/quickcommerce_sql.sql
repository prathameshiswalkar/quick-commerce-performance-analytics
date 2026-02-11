show variables like 'local_infile';
set global local_infile = 1;
select @@default_storage_engine;

CREATE TABLE orders (
    order_id BIGINT,
    cust_id INT,
    prod_id INT,
    quantity INT,
    order_date DATE,
    order_time TIME,
    order_ts DATETIME,
    city VARCHAR(50),
    eta_minutes INT,
    order_value DECIMAL(12,2)
) ENGINE=InnoDB;

create database capstone;
use capstone;
select database();

CREATE TABLE customers (
    cust_id INT,
    cust_name VARCHAR(100),
    email VARCHAR(120),
    phone VARCHAR(15),
    gender VARCHAR(10),
    age INT,
    city VARCHAR(50),
    address TEXT,
    signup_date DATE,
    last_active_date DATE
) ENGINE=InnoDB;

SHOW TABLES;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
  cust_id,
  cust_name,
  email,
  phone,
  gender,
  age,
  city,
  address,
  signup_date,
  @last_active_date
)
SET last_active_date = NULLIF(TRIM(@last_active_date), '');

select * from customers;

CREATE TABLE products (
    prod_id INT,
    prod_name VARCHAR(150),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    brand VARCHAR(100),
    price DECIMAL(10,2),
    is_perishable BOOLEAN,
    created_at DATE
) ENGINE=InnoDB;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
  prod_id,
  prod_name,
  category,
  sub_category,
  brand,
  price,
  @is_perishable,
  created_at
)
SET is_perishable =
    CASE
        WHEN LOWER(TRIM(@is_perishable)) = 'true' THEN 1
        WHEN LOWER(TRIM(@is_perishable)) = 'false' THEN 0
        ELSE NULL
    END;
    
CREATE TABLE order_status_logs (
    status_log_id BIGINT,
    order_id BIGINT,
    order_status VARCHAR(30),
    status_date DATE,
    status_time TIME,
    status_ts DATETIME
) ENGINE=InnoDB;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_status_logs.csv'
INTO TABLE order_status_logs
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


CREATE TABLE orders (
    order_id BIGINT,
    cust_id INT,
    prod_id INT,
    quantity INT,
    order_date DATE,
    order_time TIME,
    order_ts DATETIME,
    city VARCHAR(50),
    eta_minutes INT,
    order_value DECIMAL(12,2)
) ENGINE=InnoDB;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders_part_18.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

CREATE TABLE date_dim (
    date DATE,
    year INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    week_of_year INT,
    day INT,
    day_name VARCHAR(20),
    is_weekend BOOLEAN,
    is_month_end BOOLEAN
) ENGINE=InnoDB;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/date_dim.csv'
INTO TABLE date_dim
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
  date,
  year,
  month,
  month_name,
  quarter,
  week_of_year,
  day,
  day_name,
  @is_weekend,
  @is_month_end
)
SET
  is_weekend = CASE
      WHEN LOWER(TRIM(@is_weekend)) = 'true' THEN 1
      WHEN LOWER(TRIM(@is_weekend)) = 'false' THEN 0
      ELSE NULL
  END,
  is_month_end = CASE
      WHEN LOWER(TRIM(@is_month_end)) = 'true' THEN 1
      WHEN LOWER(TRIM(@is_month_end)) = 'false' THEN 0
      ELSE NULL
  END;
  
CREATE TABLE transactions (
    transaction_id BIGINT,
    order_id BIGINT,
    payment_mode VARCHAR(30),
    payment_status VARCHAR(20),
    transaction_amount DECIMAL(12,2),
    payment_ts DATETIME
) ENGINE=InnoDB;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
  transaction_id,
  order_id,
  payment_mode,
  payment_status,
  transaction_amount,
  payment_ts
);

SELECT 'customers' AS table_name, COUNT(*) FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_status_logs', COUNT(*) FROM order_status_logs
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'date_dim', COUNT(*) FROM date_dim;

# count order_status_log
select order_status, count(order_status) from order_status_logs
group by order_status;

create schema if not exists kpi;

select * from customers;
select * from date_dim;
select * from order_status_logs;
select * from orders;
select * from products;
select * from transactions;

# creating views - vw_order_fact
create or replace view vw_order_fact as
select o.order_id, o.cust_id, o.prod_id, o.quantity, o.order_value, 
o.city, o.eta_minutes, o.order_ts, date(order_ts) as order_date
from orders o
where order_ts is not null;

# order lifecycle / funnel
create or replace view vw_order_lifecycle as 
select order_id, 
min(case when order_status = 'PLACED' then status_ts end) as placed_ts,
min(case when order_status = 'PACKED' then status_ts end) as packed_ts,
min(case when order_status = 'OUT_FOR_DELIVERY' then status_ts end) as ofd_ts,
min(case when order_status = 'DELIVERED' then status_ts end) as delivered_ts,
min(case when order_status = 'CANCELLED' then status_ts end) as cancelled_ts
from order_status_logs
group by order_id;


# paymnent view
create or replace view vw_payments_fact as 
select transaction_id, order_id, payment_mode, payment_status, transaction_amount,
payment_ts, date(payment_ts) as payment_date
from transactions
where payment_ts is not null;

# INDEXES
create index idx_orders_ts on orders(order_ts);
create index idx_orders_cust on orders(cust_id);
create index idx_orders_prod on orders(prod_id);

create index idx_logs_order on order_status_logs(order_id);
create index idx_logs_order_status_ts on order_status_logs(order_id, order_status, status_ts);
create index idx_txn_order on transactions(order_id);
create index idx_date_date on date_dim(date);

# CORE KPIs 

# 1. Total Revenue
select sum(order_value) from vw_order_fact;

# 2. Total Orders
select count(distinct order_id) from vw_order_fact;

# 3. Average order values (AOV)
select round(sum(order_value) / count(distinct order_id),2) as AOV
from vw_order_fact;

# 4. Active Customers
select count(distinct cust_id) as active_customers
from vw_order_fact;

# 5. New Customers
select count(distinct c.cust_id) new_customer
from customers c
join vw_order_fact o
on c.cust_id = o.cust_id
where c.signup_date = o.order_date;

# 6. Repeat customer rate
select round(count(distinct case when cnt > 1 
then cust_id end) * 100.0 / count(distinct cust_id),2) as repeat_rate_pct
from
(select cust_id, count(*) as cnt
from vw_order_fact
group by cust_id) t;

# 7. Cancellation Rate
select round(count(case when cancelled_ts is not null then 1 end) * 100.0 / count(*), 2) as cancellation_rate_pct 
from vw_order_lifecycle;

# 8. Average Delivery Time
select round(avg(timestampdiff(minute, placed_ts, delivered_ts)),2) as Avg_delivery_time_min
from vw_order_lifecycle
where delivered_ts is not null;

# 9. SLA Breach (%) - (if ETA = 30 mins)
select round(count(case when timestampdiff(minute,placed_ts, delivered_ts) > 30 then 1 end ) * 100.0 / count(*),2) 
as SLA_breach_pct
from vw_order_lifecycle
where delivered_ts is not null;

# 10. Revenue By Month
select year(order_ts) , month(order_ts), sum(order_value) from vw_order_fact
group by year(order_ts), month(order_ts)
order by year(order_ts), month(order_ts);

# 11. Orders By City
select city, count(distinct order_id) as orders,
sum(order_value) as revenue 
from vw_order_fact
group by city
order by revenue desc;

# 12. Order Funnel Using CTE + Conditional Aggregation
with lifecycle as (
select order_id,
min(case when order_status = 'PLACED' then status_ts end) as placed_ts,
min(case when order_status = 'PACKEd' then status_ts end) as packed_ts,
min(case when order_status = 'OUT_FOR_DELIVERY' then status_ts end) as ofd_ts,
min(case when order_status = 'DELIVERY' then status_ts end) as delivered_ts,
min(case when order_status = 'CANCELLED' then status_ts end) as cancelled_ts
from order_status_logs
group by order_id
)
select 
count(*) as total_orders,
count(packed_ts) as packed_orders,
count(ofd_ts) as ofd_orders,
count(delivered_ts) as delivered_orders,
count(cancelled_ts) as cancelled_orders
from lifecycle;

# 13. Average Delivery Time + Percentile
with delivery_times as (
select order_id, timestampdiff(
minute, 
min(case when order_status = 'PLACED' then status_ts end),
min(case when order_status = 'DELIVERED' then status_ts end)) delivery_minutes
from order_status_logs
group by order_id), 
ranked as (
select delivery_minutes, row_number() over (order by delivery_minutes) as rn,
count(*) over () as total_rows
from delivery_times
where delivery_minutes is not null)
select round(avg(delivery_minutes),2) as avg_delivery_min,
max(case when rn >= total_rows * 0.9 then delivery_minutes end)
as p90_delivery_min
from ranked;

# 14. Customer Cohort analysis (Window + Date logic)

with first_order as (
select cust_id, min(order_date) as first_order_date
from vw_order_fact
group by cust_id),
orders_with_cohort as (
select o.cust_id, date_format(f.first_order_date, '%Y-%m') as cohort_month,
date_format(o.order_date, '%Y-%m') as order_month
from vw_order_fact as o
join first_order as f
on o.cust_id = f.cust_id)
select cohort_month, order_month, count(distinct cust_id) as Active_customers
from orders_with_cohort
group by cohort_month, order_month
order by cohort_month, order_month;

# 15. Top Products Per City (WINDOW RANK)
with product_city_revenue as (
select city , p.prod_name , sum(order_value) as revenue
from vw_order_fact o 
join products p
on o.prod_id = p.prod_id
group by o.city, p.prod_name),
ranked_products as (
select *, 
rank() over (partition by city order by revenue desc) as rnk
from product_city_revenue)
select city, prod_name, revenue
from ranked_products
where rnk <= 3;

# 16. Payment failure Trend
with daily_trn as(
select date(payment_ts) trn_date, count(*) total_trn, count(case when payment_status <> 'SUCCESS' then 1 end) as failed_trn
from transactions
group by date(payment_ts))
select trn_date, 
round(failed_trn * 100.0 / total_trn, 2) as failure_pct,
round(avg(failed_trn * 100.0 / total_trn) over (order by trn_date rows between 6 preceding and current row), 2) as rolling_7d_failure_pct
from daily_trn 
order by trn_date;

# 17. Repeat vs New Customer Split
select case when order_count = 1 then 'New' else 'Repeat' end as customer_type, count(*) as customers from
(select cust_id, count(*) as order_count 
from vw_order_fact
group by cust_id) t
group by customer_type;

# 18. Parento (80/20) Product Analysis (Window Cumulative)
with product_revenue as (
select p.prod_name, sum(o.order_value) as revenue
from vw_order_fact o 
join products p 
on o.prod_id = p.prod_id
group by p.prod_name),
ranked as (
select prod_name, revenue, sum(revenue) over () total_revenue, 
sum(revenue) over (order by revenue desc) as cumulative_revenue
from product_revenue)
select prod_name, revenue, round(cumulative_revenue * 100.0 / total_revenue, 2) as cumulative_pct
from ranked
where cumulative_revenue <= total_revenue * 0.8;

# 19. Average Order Value (AOV)
SELECT 
ROUND(SUM(order_value) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM vw_order_fact;

# 20. On-Time Delivery %
SELECT 
ROUND(
    COUNT(CASE 
        WHEN TIMESTAMPDIFF(MINUTE, placed_ts, delivered_ts) <= 30 
        THEN 1 END
    ) * 100.0 / COUNT(*), 2
) AS on_time_delivery_pct
FROM vw_order_lifecycle
WHERE delivered_ts IS NOT NULL;

# 21. Repeat Customer (%) 
WITH cust_orders AS (
    SELECT cust_id, COUNT(*) AS order_count
    FROM vw_order_fact
    GROUP BY cust_id
)
SELECT 
ROUND(
COUNT(CASE WHEN order_count > 1 THEN 1 END) * 100.0 / COUNT(*),
2
) AS repeat_customer_pct
FROM cust_orders;

# 22. Revenue Top 10 Products
SELECT 
p.prod_name,
ROUND(SUM(o.order_value),2) AS revenue
FROM vw_order_fact o
JOIN products p ON o.prod_id = p.prod_id
GROUP BY p.prod_name
ORDER BY revenue DESC
LIMIT 10;

# 23. Revenue Share (%) of Top 10 Products
WITH product_rev AS (
    SELECT 
        p.prod_name,
        SUM(o.order_value) AS revenue
    FROM vw_order_fact o
    JOIN products p ON o.prod_id = p.prod_id
    GROUP BY p.prod_name
),
ranked AS (
    SELECT *,
    SUM(revenue) OVER() AS total_revenue,
    RANK() OVER(ORDER BY revenue DESC) AS rnk
    FROM product_rev
)
SELECT 
prod_name,
ROUND(revenue * 100.0 / total_revenue,2) AS revenue_share_pct
FROM ranked
WHERE rnk <= 10;

# 24. Perishable Revenue
SELECT 
ROUND(SUM(o.order_value),2) AS perishable_revenue
FROM vw_order_fact o
JOIN products p ON o.prod_id = p.prod_id
WHERE p.is_perishable = 1;

# 25. Perishable Revenue (%)
SELECT 
ROUND(
SUM(CASE WHEN p.is_perishable = 1 THEN o.order_value END)
* 100.0 / SUM(o.order_value),2
) AS perishable_revenue_pct
FROM vw_order_fact o
JOIN products p ON o.prod_id = p.prod_id;

# 26. Customer Lifetime Value (CLV)
SELECT 
cust_id,
ROUND(SUM(order_value),2) AS customer_lifetime_value
FROM vw_order_fact
GROUP BY cust_id
ORDER BY customer_lifetime_value DESC;

# 27. Revenue Month-over-Month Growth %
WITH monthly_rev AS (
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m-01') AS month,
        SUM(order_value) AS revenue
    FROM vw_order_fact
    GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
)
SELECT 
month,
revenue,
ROUND(
(revenue - LAG(revenue) OVER (ORDER BY month)) 
/ LAG(revenue) OVER (ORDER BY month) * 100,
2
) AS revenue_mom_pct
FROM monthly_rev;


