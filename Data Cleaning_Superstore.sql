create table superstore_data (
	OrderID VARCHAR,
	OrderDate DATE,
	CustomerName Varchar,
	City_State_Country VARCHAR,
	Region VARCHAR,
	Segment VARCHAR,
	ShipDate VARCHAR,
	ShipMode VARCHAR,
	OrderPriority VARCHAR)
	
SET DATESTYLE to mdy
COPY superstore_data(OrderID, OrderDate,CustomerName,City_State_Country,	Region, Segment, ShipDate,ShipMode,OrderPriority )
FROM 'D:\0.2 PORTFOLIO\sql\superstore data.CSV'
DELIMITER ','
CSV HEADER
	
select * from superstore_data

create table Order_Breakdown(
	OrderID VARCHAR,
	ProductName VARCHAR,
	Discount decimal,
	Sales decimal,
	Profit decimal,
	Quantity int,
	SubCategory VARCHAR)


SELECT * FROM Order_Breakdown

COPY Order_Breakdown(OrderID,ProductName,Discount,Sales,
					 Profit,Quantity,SubCategory )
FROM 'D:\0.2 PORTFOLIO\sql\Order Breakdown.CSV'
DELIMITER ','
CSV HEADER


	
ALTER TABLE superstore_data
rename to OrdersList

	
ALTER TABLE Order_Breakdown
rename to EachOrderBreakdown

---1. Establish the relationship between the tables as per the ER diagram
SELECT * FROM ORDERSLIST

ALTER TABLE orderslist
add constraint pk_orderid PRIMARY KEY(OrderID)


ALTER TABLE orderslist
ALTER COLUMN orderid SET DATA TYPE VARCHAR,
ALTER COLUMN orderid SET NOT NULL

ALTER TABLE EachOrderBreakdown
ALTER COLUMN orderid SET DATA TYPE VARCHAR,
ALTER COLUMN orderid SET NOT NULL

ALTER TABLE EachOrderBreakdown
add constraint fk_orderid FOREIGN KEY(OrderID) REFERENCES orderslist

---2. Split City State Country into 3 individual columns namely ‘City’, ‘State’, ‘Country’.

ALTER TABLE orderslist
add column City varchar, 
add column State varchar, 
add column Country varchar

UPDATE orderslist
SET city = split_part(city_state_country, ',', 1),
    State = split_part(city_state_country, ',', 2),
	Country = split_part(city_state_country, ',', 3);

ALTER TABLE orderslist
DROP COLUMN city_state_country;

select * from orderslist

---->3. Add a new Category Column using the following mapping as per the first 3 characters in the
---Product Name Column:
---a. TEC- Technology
---b. OFS – Office Supplies
---c. FUR - Furniture

select * from eachorderbreakdown

ALTER TABLE eachorderbreakdown
add column category varchar

update eachorderbreakdown
set category = case when left(productname,3) = 'OFS' then 'Office Supplies'
                    when left(productname,3) = 'TEC' then 'Technology'
                    when left(productname,3) = 'FUR' then 'Furniture'
                end;
				
---4. Delete the first 4 characters from the ProductName Column.
update eachorderbreakdown
set productname = substring(productname,5,length(productname)-4)


---5. Remove duplicate rows from EachOrderBreakdown table, if all column values are matching

select orderid, productname, discount, sales,profit,quantity,
       subcategory, row_number() over(partition by orderid, 
	   productname, discount, sales,profit,quantity,
       subcategory ) as rank 
from eachorderbreakdown

delete from eachorderbreakdown
where orderid in (select orderid from(
	select *, row_number() over(partition by orderid, 
	   productname, discount, sales,profit,quantity,
       subcategory ) as rnk from eachorderbreakdown) t1
	   where rnk > 1)


---6. Replace blank with NA in OrderPriority Column in OrdersList table

select count(*) from orderslist

UPDATE orderslist
SET orderpriority = CASE WHEN orderpriority = '' THEN 'NA' 
                    END;












