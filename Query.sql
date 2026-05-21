use Final_Project

INSERT INTO products
(Product_ID, Product_Name, Product_Category, Product_Subcategory)
VALUES
('PRD-207-U', 'Wireless Gaming Mouse', 'Electronics', 'Accessories'),
('PRD-506-T', 'Men Casual Hoodie', 'Clothing', 'Men'),
('PRD-611-U', 'Smart LED TV 55 Inch', 'Electronics', 'TVs'),
('PRD-616-C', 'Kitchen Blender Pro', 'Home', 'Kitchen'),
('PRD-627-G', 'Hydrating Face Serum', 'Beauty', 'Skincare'),
('PRD-651-V', 'Yoga Training Mat', 'Sports', 'Fitness'),
('PRD-653-L', 'Wooden Coffee Table', 'Home', 'Furniture'),
('PRD-696-G', 'Bluetooth Earbuds', 'Electronics', 'Accessories'),
('PRD-860-J', 'Women Running Shoes', 'Sports', 'Outdoor'),
('PRD-910-L', 'Professional Hair Dryer', 'Beauty', 'Haircare');

--1) what is the total revenue
select sum(Net_amount) as total_revenue 
from orders
--------------------- 
--2)how many total orders
select count(distinct Order_ID) as total_orders
from orders 
------------------------------------------ 
--3) what is the average order value
select sum(net_amount)/ count(distinct order_id)
as average_order_value
from orders


--------------------------------------- 
--4) how does revenue change over time by month
SELECT 
    YEAR(Order_Date) AS Order_Year,
    MONTH(Order_Date) AS Order_Month,
    SUM(Net_Amount) AS Monthly_Revenue
FROM orders 
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Order_Year, Order_Month; 
--------------------------------------------
--5) how many unique customers
select count(distinct customer_id) as unique_customer
from orders
-----------------------------------------------
--6) who are the top 10 customers based on total spending
select top 10  
c.customer_id,c.customer_name,
sum(o.net_amount) as total_spent 
from orders o left join customers c
on o.Customer_ID = c.Customer_ID
group by c.Customer_ID, c.Customer_Name 
order by total_spent desc 
------------------------------------------ 
--7) which products are the best selling by quantity 

select top 10
p.product_id,p.product_name,sum(o.quantity) as quantity_sold 
from orders o left join products p
on o.Product_ID =p.Product_ID 
group by p.Product_ID, p.Product_Name 
order by quantity_sold desc 

-----------------------------------------------------------------
----8- How is revenue distributed across product categories?

SELECT 
    p.Product_Category, 
    SUM(o.Net_Amount) AS Total_Revenue
FROM Orders o
LEFT JOIN Products p ON o.Product_ID = p.Product_ID
GROUP BY p.Product_Category
ORDER BY Total_Revenue DESC;

-------------------------------------------------------------------
----9- What is the total discount amount given?

SELECT 
    SUM(Discount) AS Total_Discount
FROM Orders;

-------------------------------------------------
----10- What is the average discount per order?


SELECT 
    AVG(Discount) AS Average_Discount
FROM Orders;

--------------------------------------------------

----11- Which payment method generates the highest revenue?

SELECT 
    Payment_Method, 
    SUM(Net_Amount) AS Total_Revenue
FROM Orders
GROUP BY Payment_Method
ORDER BY Total_Revenue DESC;
---------------------------------------------------------

----12- Which cities generate the highest revenue?

SELECT TOP 5
    c.City, 
    SUM(o.Net_Amount) AS Total_Revenue
FROM Orders o
LEFT JOIN Customer c ON o.Customer_ID = c.Customer_ID
GROUP BY c.City
ORDER BY Total_Revenue DESC;

--------------------------------------------------------------

----13- What is the total profit after deducting shipping costs?

SELECT 
    SUM(Net_Amount - Shipping_Cost) AS Total_Profit
FROM Orders;
-----------------------------------------------------------------
-- 14- How many customers are repeat customers?

SELECT 
o.Customer_ID,
c.Customer_Name,
COUNT(*) AS Orders_Count
FROM Orders o
JOIN Customers c
ON o.Customer_ID = c.Customer_ID
GROUP BY 
o.Customer_ID,
c.Customer_Name
HAVING COUNT(*) > 1
-----------------------------------------------
-- 15- What is the repeat customer rate?

SELECT 
COUNT(*) * 100.0 /
(
SELECT COUNT(DISTINCT Customer_ID)
FROM Orders
) AS Repeat_Customer_Rate
FROM
(
SELECT Customer_ID
FROM Orders
GROUP BY Customer_ID
HAVING COUNT(*) > 1
) As Temporary_Table
--------------------------------------------- 
-- 16- What is the average quantity of products per order?

SELECT 
AVG(Quantity * 1.0) AS Avg_Quantity_Per_Order
FROM Orders
----------------------------- 
-- 17 -Which product subcategory generates the highest revenue?

select 
top 5 p.Product_subCategory , sum(o.net_amount) as Total_Revenue
from Orders o
join products p 
on o.Product_ID = p.Product_ID
group by p.product_subcategory
Order by Sum(o.net_amount) desc 


---------------------------------------------
-- 18- What is the relationship between discount and order value?

Alter Table orders
add discount_Precentage_Num tinyint

update orders
set discount_precentage_num =
cast(replace(Discount_Percentage,'%','') as tinyint)

select
case when discount_precentage_num = 0 then 'No Discount'
when discount_precentage_num < 10 then 'low Discount'
when discount_precentage_num < 20 then 'Medium Discount'
else 'High Discount'
end as Discount_Level ,

AVG(Net_Amount) as AVG_Order_Value
from Orders

group by 
case when discount_precentage_num = 0 then 'No Discount'
when discount_precentage_num < 10 then 'low Discount'
when discount_precentage_num < 20 then 'Medium Discount'
else 'High Discount' 
end


------------------------------------------------------ 
-- 19- Which customers have the highest purchase frequency?

select Top 10 Customer_ID , count(*) as Purchase_Frequency
from orders
group by Customer_ID
order by Purchase_Frequency desc
-------------------------------------------------
-- 20- How does shipping cost impact overall profitability?

select 
case when Shipping_cost <= 50 then 'Low Shipping'
when Shipping_Cost <=100 then 'Medium Shipping'
else 'High Shipping'
end as Shippping_level,
AVG(Net_amount - Shipping_Cost) as AVG_Profit
from orders
group by 
case when Shipping_cost <= 50 then 'Low Shipping'
when Shipping_Cost <=100 then 'Medium Shipping'
else 'High Shipping'
end 
Order by Shippping_level desc 