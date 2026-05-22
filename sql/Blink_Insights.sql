-- ================================================
-- BLINKIT SALES ANALYSIS
-- Author: Your Name
-- Tool: SQL Server Management Studio (SSMS)
-- ================================================

--Sales & Revenue Insights

--Insight 1(Which product categories generate the highest revenue?)

with highest_revenue as (
	SELECT 
		category,
		round(sum(mrp-price),2) as total_revenue,
		dense_rank() over (order by round(sum(mrp-price),2) desc) as rnk
		from products
		group by category
)
select * from highest_revenue
where rnk=1

--Pet Care		7362.55		1

--Percentage profit contribution
WITH profit_contributions AS (
	SELECT 
		category,
		ROUND(SUM(mrp - price), 2) AS total_profit,
		
		-- Window function to divide category profit by the grand total of all categories
		ROUND(
			(SUM(mrp - price) * 100.0) / SUM(SUM(mrp - price)) OVER(), 
			2
		) AS percentage_contribution,
		
		DENSE_RANK() OVER (ORDER BY ROUND(SUM(mrp - price), 2) DESC) AS rnk
	FROM 
		products
	GROUP BY 
		category
)
SELECT * FROM profit_contributions
WHERE rnk = 1;
--Pet Care		7362.55		14.3


--insight 2
--Top 10 best-selling products by quantity and revenue

with best_seller as (
	select 
		product_name,
		round(sum(mrp-price),2) as total_revenue,
		dense_rank() over (order by round(sum(mrp-price),2)desc) as rnk
	from products
	group by product_name
)
select * from best_seller
where rnk<=10

--Pet Treats		3488.96	1
--Lotion			2144.83	2
--Frozen Biryani	2073.98	3
--Cat Food			2014.68	4
--Biscuits			1974.1	5
--Dog Food			1858.91	6
--Baby Wipes		1716.14	7
--Vitamins			1665.78	8
--Cola				1641.79	9
--Soap				1623.58	10

--Insight 3
--Which city/area contributes the most sales?

select c.area, count(o.order_id) as total_orders
from customer c
join orders o
on c.customer_id=o.customer_id
group by c.area
order by total_orders desc;

--Orai			44
--Deoghar		40
--Gandhinagar	37
--Nandyal		36
--Ratlam		35
--Bathinda		34
--Ghaziabad		32
--Bhopal		31
--Udaipur		31
--Tezpur		30

--query4
--What is the monthly sales trend?

with MonthlySales as(
	select
		year(order_date) as order_year,
		month(order_date) as order_month,
		round(sum(order_total),2) as total_GMV
	from orders
	group by year(order_date),month(order_date)


),

mom_Calculation as(
	select
		order_year,
		order_month,
		total_GMV,
		LAG(total_GMV,1) over (order by order_year, order_month) as previous_month_sales
	from MonthlySales
		
)
select
	order_year,
	order_month,
	total_GMV,
	ISNULL(previous_month_sales,0) as last_year_GMV,
	case
		when last_year_GMV is null or last_year_GMV=0 then 0
		else round(((total_GMV-last_year_GMV)/last_year_GMV),2)

	end as MOM_Growth_Percentage
from mom_Calculation
ORDER BY OrderYear DESC, OrderMonth DESC;




--Correct version
WITH MonthlySales AS (
    SELECT
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        ROUND(SUM(order_total), 2) AS total_GMV
    FROM orders
    GROUP BY YEAR(order_date), MONTH(order_date)
),

mom_Calculation AS (
    SELECT
        order_year,
        order_month,
        total_GMV,
        LAG(total_GMV, 1) OVER (ORDER BY order_year, order_month) AS previous_month_sales
    FROM MonthlySales
)

SELECT
    order_year,
    order_month,
    total_GMV,
    ISNULL(previous_month_sales, 0) AS last_month_GMV, -- 1. Added missing comma here
    
    CASE
        -- 2. Used the actual column name 'previous_month_sales' instead of the alias
        WHEN previous_month_sales IS NULL OR previous_month_sales = 0 THEN 0
        -- 3. Multiplied by 100 to convert the decimal into a true percentage value (e.g., 0.12 -> 12.00%)
        ELSE ROUND(((total_GMV - previous_month_sales) / previous_month_sales) * 100, 2)
    END AS MOM_Growth_Percentage
FROM mom_Calculation
-- 4. Fixed underscores to match your upper CTE column definitions
ORDER BY order_year asc, order_month asc;

--Query 5
--Which days of the week have the highest orders?

select * from orders

with WeekdaySales as (
	select
		sum(order_total) as total_GMV,
		DATENAME(WEEKDAY,order_date) as week_days,
		DENSE_RANK() over (order by sum(order_total)desc) as rnk
	from orders
	group by DATENAME(WEEKDAY,order_date)

)

SELECT *
    --week_days,
    --total_GMV
FROM WeekdaySales
WHERE rnk <=2;

--Sunday	1671138.58112717
--1642278.54888153	Wednesday	2

--Query 6
--Average order value by customer ares

select * from customer

with CTE as(
	select 
		area, 
		ROUND(sum(avg_order_value),2) as avg_revenue,
		dense_rank() over (order by ROUND(avg(avg_order_value),2)desc) as rnk
	from customer
	group by area
)
select * from CTE
where rnk=1

--Suryapet	6787.99	1


--insight 7
--Average delivery time by city

select * from customer 
select * from orders 

select 
	c.area, ROUND(avg(cast(datediff(minute,o.promised_delivery_time, o.actual_delivery_time)as float)),2) as Delivey_time
from customer c
join orders o
on c.customer_id=o.customer_id
group by c.area
order by ROUND(avg(cast(datediff(minute,o.promised_delivery_time, o.actual_delivery_time)as float)),2)

--Muzaffarpur	-3.4
--Mangalore		-2
--Morena		-0.75
--Chandrapur	-0.67
--Delhi			-0.07
--Gulbarga		0.19
--Alwar			0.4
--Gwalior		0.68
--Navi Mumbai	0.71
--Madurai		0.75

--insight8 
--Which delivery partner performs best?

select * from delivery

with cte as (
	select 
		delivery_partner_id,
		round(avg(cast(datediff(minute, promised_time, actual_time)as float)),2) as delivery_time,
		DENSE_RANK() OVER (ORDER BY ROUND(AVG(CAST(DATEDIFF(MINUTE, promised_time, actual_time) AS FLOAT)), 2) ASC) AS rnk
	from delivery
	group by delivery_partner_id
)
select * from cte
where rnk =1

--316 partners are performing well

--Query9
--Delayed deliveries percentage
select * from delivery

--with delay_percentage_rate as (
--	select 
--		round(cast(datediff(minute,promised_time,actual_time)),2) as total_delay,

--		round(cast(datediff(minute,promised_time,actual_time)),2)*100.0/round(cast(datediff(minute,promised_time,actual_time)).over(),2)as delay_percentage,

--		dense_rank() over (order by round(cast(datediff(minute,promised_time,actual_time)),2)desc) as rnk
--	from delivery		
--)
--select * from  delay_percentage_rate
--where rnk=1



--Query10
--9. Which time slot gets maximum orders?

--Morning / Afternoon / Evening / Night

select * from orders

with segmentedOrder as (

	select 
		order_id,
		order_total,
		case
			when DATEPART(hour, order_date) between 6 and 11 then 'Morning(6AM-12PM)'
			when DATEPART(hour, order_date) between 12 and 16 then 'Afternoon(12PM-5PM)'
			when DATEPART(hour, order_date) between 17 and 21 then 'Evening(5PM-10PM)'
			else 'Night(10PM-6AM)'
		end as time_slot
	from orders
)

select 
	time_slot,
	count(order_id) as total_orders,
	sum(order_total) as total_revenue,
	cast(count(order_id)*100.0/sum(count(order_id)) over() as decimal(10,2)) as order_percentage
from segmentedOrder
group by time_slot
order by total_orders desc;

--Night(10PM-6AM)		1661	3720712.02801895	33.22
--Morning(6AM-12PM)		1229	2727307.99288559	24.58
--Evening(5PM-10PM)		1080	2356800.69009018	21.60
--Afternoon(12PM-5PM)	1030	2204487.79039764	20.60