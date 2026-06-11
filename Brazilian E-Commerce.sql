--TO SEE THE ENTIRE TABLE
use [BrazilianECommerce];
select * from [dbo].[olist_orders_dataset];

--FIND OUT THE COUNT OF ORDER ID
select count(order_id)
from [dbo].[olist_orders_dataset];

--FIND OUT THE DISTINCT COUNT OF ORDER ID
select count(distinct order_id)
from [dbo].[olist_orders_dataset];

--FIND TOTAL NO OF UNIQUE CUSTOMERS 
select count(distinct customer_unique_id) AS Total_customers
from [dbo].[olist_customers_dataset];

--LIST ALL THE UNIQUE CUSTOMERS STATES.
SELECT DISTINCT (customer_state)
FROM olist_customers_dataset

--FIND STATES WITH MORE THAN 1000 ORDERS.
SELECT c.customer_state,
count(order_id)
from [dbo].[olist_orders_dataset] AS o
join [dbo].[olist_customers_dataset] AS c
ON o.customer_id = c.customer_id
group by customer_state
Having count(o.order_id) > 1000
order by count(o.order_id) desc;

--FIND ORDER PLACED IN 2017
select year(order_purchase_timestamp)as order_year,order_id
from [dbo].[olist_orders_dataset]
where year(order_purchase_timestamp) = 2017;


--FIND ORDERS WITH MULTIPLE PAYMENT INSTALLMENTS.
select * from 
[dbo].[olist_order_payments_dataset]
where payment_installments >1
order by payment_installments desc;

--FIND THE NUMBERS OF ORDERS FOR EACH ORDER STATUS.
select order_status, COUNT(*)
from [dbo].[olist_orders_dataset]
group by order_status;

--FIND TOTAL CUSTOMERS PER CITY SORTED DESCENDING
select count(customer_id),customer_city
from olist_customers_dataset
group by customer_city
order by count(customer_id) desc;

--COUNT HOW MANY ORDERS ARE DELIEVERED AND CANCELED
select order_status , count(*)
from [dbo].[olist_orders_dataset]
where order_status IN ('canceled','delivered')
group by order_status;

--FIND NUMBERS OF ORDERS PER YEAR.
select YEAR(order_purchase_timestamp) as order_year,
count(*) as total_orders
from olist_orders_dataset
group by YEAR(order_purchase_timestamp) 
order by order_year;

--TOP 5 CUSTOMERS CITIES WITH HIGHEST ORDERS
SELECT * 
FROM [dbo].[olist_customers_dataset] as c
JOIN [dbo].[olist_orders_dataset] as o
on c.customer_id = o.customer_id;

select TOP 5 
c.customer_city,
count (o.order_id)
from [dbo].[olist_customers_dataset] as c
JOIN [dbo].[olist_orders_dataset] as o
ON c.customer_id = o.customer_id
group by c.customer_city
order by count(o.order_id) desc;

--FIND TOTAL REVENUE PER PAYEMNT TYPE.
select payment_type,
sum(payment_value) as Total_revenue
from [dbo].[olist_order_payments_dataset]
group by payment_type;

--FIND HOW MANY ORDERS EACH CUSTOMER HAS placed.
select customer_id,
count(order_id) as total_count
from [dbo].[olist_orders_dataset]
group by (customer_id);

--Find top 10 cities with highest orders
select top 10
count(order_id) as Total_count, customer_city
from olist_orders_dataset as o
join [dbo].[olist_customers_dataset] as c
ON o.customer_id = c.customer_id
group by customer_city
order by count(order_id) desc;

--FIND CITY WITH MAXIMUM ORDERS.
select count(order_id) as total_count,customer_city
from [dbo].[olist_orders_dataset] as o
join [dbo].[olist_customers_dataset] as c
ON o.customer_id = c.customer_id
group by customer_city
order by count(order_id) desc;

--FIND TOP 5 CUSTOMERS WITH MOST ORDERS.
select Top 5
count(order_id) as Total_orders,
c.customer_id
from olist_customers_dataset as c
join [dbo].[olist_orders_dataset] as o
ON c.customer_id = o.customer_id
group by c.customer_id
order by Total_orders desc;

--FIND REVENUE PER CITY.
select c.customer_city, 
sum(payment_value) as Total_revenue
from [dbo].[olist_customers_dataset] as c
join [dbo].[olist_orders_dataset] as o
ON c.customer_id = o.customer_id
join [dbo].[olist_order_payments_dataset] as op
ON o.order_id = op.order_id
group by c.customer_city;

FIND DUPLICATE CUSTOMER ID.
select 
customer_id,
count(*)
from [dbo].[olist_customers_dataset]
group by customer_id
having count(*) > 1;

--FIND FIRST ORDERS DATE PER CUSTOMER.
select c.customer_id,
MIN(order_purchase_timestamp) as first_order
from [dbo].[olist_customers_dataset] as c
join [dbo].[olist_orders_dataset] as o
ON c.customer_id = o.customer_id
group by(c.customer_id)
order by first_order;

--FIND LAST ORDER DATE PER CUSTOMER.
select c.customer_id,
MAX(order_purchase_timestamp) as last_order
from [dbo].[olist_customers_dataset] as c
join [dbo].[olist_orders_dataset] as o
ON c.customer_id = o.customer_id
group by(c.customer_id)
order by last_order desc;

--TOP 5 CUSTOMERS THEIR TOTAL ORDERS AND THEIR TOTAL REVENUE.
select Top 5
c.customer_unique_id,
count(distinct o.order_id) as total_order,
sum(payment_value) as total_revenue
from olist_customers_dataset as c
join [dbo].[olist_orders_dataset] as o
ON c.customer_id = o.customer_id
join [dbo].[olist_order_payments_dataset] as op
ON o.order_id = op.order_id
group by c.customer_unique_id
order by sum(payment_value) desc;


--FIND TOTAL REVENUE PER STATE.
select c.customer_state,
sum(payment_value) as Total_revenue
from [dbo].[olist_order_payments_dataset] as op
join [dbo].[olist_orders_dataset] as o
ON op.order_id = o.order_id
join [dbo].[olist_customers_dataset] as c
ON o.customer_id = c.customer_id
group by c.customer_state
order by Total_revenue desc;

--FIND ORDERS WITH NO PAYMENT RECORDS.
select o.order_id
FROM [dbo].[olist_orders_dataset] AS o
LEFT JOIN [dbo].[olist_order_payments_dataset] AS op
ON o.order_id = op.order_id
WHERE op.order_id IS NULL;

--FIND MOST USED PAYMENT TYPE PER STATE.
select op.payment_type,
c.customer_state,
count(*) as Total_count
from [dbo].[olist_order_payments_dataset] as op
join [dbo].[olist_orders_dataset] as o
ON op.order_id = o.order_id
join [dbo].[olist_customers_dataset] as c
ON o.customer_id = c.customer_id
group by op.payment_type,c.customer_state
order by Total_count desc;

--FIND CUSTOMERS WHO CHURNED ORDER ONCE BUT NEVER RETURNED.
select customer_unique_id
from [dbo].[olist_customers_dataset] as c
join olist_orders_dataset as o
ON c.customer_id = o.customer_id
group by c.customer_unique_id
having count(order_id) = 1;

--FIND TOTAL ORDERS PER MONTH.
select Year (order_purchase_timestamp) as year,
Month (order_purchase_timestamp) as month,
count (order_id) as total_order
from [dbo].[olist_orders_dataset]
group by Year (order_purchase_timestamp),
Month (order_purchase_timestamp) 
order by year,month;

--FIND HOW MANY CUSTOMERS PLACED MORE THAN 5 ORDERS.
select count(*) AS total_customers
from(
select c.customer_id
from [dbo].[olist_customers_dataset] as c
join [dbo].[olist_orders_dataset] as o
ON c.customer_id = o.customer_id
group by c.customer_id
having count(o.order_id) > 5
) AS sub;

--FIND PERCENTAGE  OF EACH ORDER STATUS.
select
order_status,
count(*) * 100.0/(select count(*) from olist_orders_dataset) as percentage 
from [dbo].[olist_orders_dataset]
group by order_status

--FIND AVERAGE DELIVERY TIME(IN DAYS).
select 
avg (DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date)) as avg_delivery
from olist_orders_dataset
where order_delivered_customer_date is not null;

--FIND REPEAT CUSTOMERS (PLACED MORE THAN 1 ORDER).
select count(*) AS total_customers
from(
select c.customer_id
from [dbo].[olist_customers_dataset] as c
join [dbo].[olist_orders_dataset] as o
ON c.customer_id = o.customer_id
group by c.customer_id
having count(o.order_id) > 1
) AS sub;

--FIND CUSTOMERS WHO ORDERD IN MULTIPLE STATES.
select 
c.customer_id
FROM [dbo].[olist_customers_dataset] AS c
JOIN [dbo].[olist_orders_dataset] AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT c.customer_state) > 1;

--FIND MONTH-OVER-MONTH REVENUE GROWTH.
select 
YEAR(o.order_purchase_timestamp) as year,
MONTH(o.order_purchase_timestamp) as month,
sum(payment_value) as Total_revenue
from [dbo].[olist_order_payments_dataset] as op
join [dbo].[olist_orders_dataset] as o
ON op.order_id = o.order_id
group by 
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp)
order by YEAR , MONTH;

--FIND MOST POPULAR PAYMENT TYPE OVERALL AND PER STATE.
select op.payment_type,
c.customer_state,
count(*) as Total_count
from [dbo].[olist_order_payments_dataset] as op
join [dbo].[olist_orders_dataset] as o
ON op.order_id = o.order_id
join [dbo].[olist_customers_dataset] as c
ON o.customer_id = c.customer_id
group by c.customer_state,op.payment_type
order by Total_count DESC;

