

use [sql_project_1]
select count(*) from dbo.[data 1];

select count(*) from [dbo].[retails_sales]


select * from dbo.[retails_sales];
select top 100 * from dbo.retails_sales 
order by transactions_id asc;

  SELECT * FROM INFORMATION_SCHEMA.SCHEMATA;

--

SELECT * FROM retails_sales 
WHERE transactions_id IS NULL

--

SELECT * FROM retails_sales 
WHERE sale_date IS NULL

--

SELECT * FROM retails_sales 
WHERE sale_time IS NULL

--
SELECT * FROM retails_sales
WHERE 
     transactions_id is null
	 or 
	 sale_date is null
	 or 
	 sale_time is null
	 or 
	 gender is null
	 or 
	 category is null
	 or 
	 quantiy is null
	 or 
	 cogs is null
	 or
	 total_sale is null

	 --
delete from retails_sales
where 
         transactions_id is null
	 or 
	 sale_date is null
	 or 
	 sale_time is null
	 or 
	 gender is null
	 or 
	 category is null
	 or 
	 quantiy is null
	 or 
	 cogs is null
	 or
	 total_sale is null
--
 select count(*) from retails_sales

 -- Data Exploration

 -- how many sales we have?

 select count(*) as total_sales from retails_sales;

 -- how many unique customers?

 select count(distinct(customer_id)) from retails_sales;

 -- total categories
 
 select distinct(category) from retails_sales;

 -- Data analysis 

--Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select * from retails_sales where sale_date = '2022-11-05';

--Write a SQL query to retrieve all transactions where the
--  category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * 
from retails_sales
where category ='Clothing' and
 quantiy >=4  and 
 format(sale_date, 'yyyy-MM') = '2022-11'

select month(sale_date) from retails_sales;

--Write a SQL query to calculate the total sales (total_sale) for each category.:

select category, sum(total_sale) as total_sales,count(*) as total_orders
from
retails_sales
group by category

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select round(avg(age), 2) as avg_age
from retails_sales
where category = 'Beauty'

--Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * from retails_sales
where total_sale >1000

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

select gender, category , count(transactions_id) from retails_sales
group by gender, category

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT year, month, avg_sale
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date) 
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retails_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE rank = 1;


--**Write a SQL query to find the top 5 customers based on the highest total sales **:

with ranked_sales as (
select customer_id ,
sum(total_sale) as total_sales,
 row_number() over( order by sum(total_sale) desc) as rn
  from retails_sales
  group by customer_id
 )
 select * from ranked_sales

 where rn <= 5;

 --Write a SQL query to find the number of unique customers who purchased items from each category.:
 select category , count(distinct customer_id) as count_unique
  from retails_sales
  group by category


  --Write a SQL query to create each shift and number 
  --of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

  with hourly_sales as(
    select *,
	case
	     when Datepart(HOUR,sale_time)< 12 then 'Morning'
		 when Datepart(HOUR,sale_time) between 12 and 17 then 'Afternoon'
		 else 'Evening'
		end as shift
		from retails_sales
  
  
  )
