---1. List the top 10 orders with the highest sales from the EachOrderBreakdown table.

select orderid, sales 
from eachorderbreakdown
order by 2 desc
limit 10

---2. Show the number of orders for each product category in the EachOrderBreakdown table
select category, count(orderid) as number_of_orders
from eachorderbreakdown
group by 1
order by 2 desc

---3.  Find the total profit for each sub-category in the EachOrderBreakdown table
select subcategory , sum(profit) as total_profit
from eachorderbreakdown
group by 1
order by 2 desc

---4. Identify the customer with the highest total sales across all orders.

select o.customername, sum(eob.sales) as total_sales
from orderslist as o
join eachorderbreakdown as eob
on o.orderid = eob.orderid
group by 1
order by 2 desc 

---5. Find the month with the highest average sales in the OrdersList table. 

SELECT TO_CHAR(orderdate, 'Mon') AS extracted_month, avg(eob.sales) as average_sales
FROM orderslist as ol
join eachorderbreakdown as eob
on ol.orderid = eob.orderid
group by 1
order by 2 desc
limit 1

---6. . Find out the average quantity ordered by customers whose first name starts with an alphabet
's'?

select avg(eob.quantity) as avg_qty
from orderslist as o
join eachorderbreakdown as eob
on o.orderid = eob.orderid
where customername like 'S%'


---7. Find out how many new customers were acquired in the year 2014?

with t1 as (select customername, min(extract(years from orderdate)) as first_order_Date
from orderslist
group by 1
having min(extract(years from orderdate)) = 2014
order by 2)

select count(distinct customername) from t1

---8. . Calculate the percentage of total profit contributed by each sub-category to the overall profit.

select subcategory,
CONCAT(ROUND((sum(profit)/(select sum(profit) from eachorderbreakdown))*100,2),'%')as profit_contribution
from eachorderbreakdown 
group by 1
ORDER BY 2 DESC


---9. Find the average sales per customer, considering only customers who have made more than one order.
select  ol.customername,count(distinct ol.orderid) as no_of_orders, avg(eob.sales) as avg_sales
from orderslist as ol
join eachorderbreakdown as eob
on ol.orderid = eob.orderid
group by 1 
having count(distinct ol.orderid)>1
order by 2

---10. Identify the top-performing subcategory in each category based on total sales.
-------Include the subcategory name, 
-------total sales, and a ranking of sub-category within each category.
with t1 as (select category, subcategory, sum(sales) as total_sales
from eachorderbreakdown
group by 1,2
order by 1,2),

t2 as(
select *, 
      dense_rank() over  (partition by category order by total_sales desc) as rnk
from t1)

select category, subcategory, total_sales, rnk
from t2 
where rnk = 1






