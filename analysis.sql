

--1. What is the overall business performance of Decathlon?
SELECT
    ROUND(SUM(Final_Amount),2) AS Total_Revenue,
    ROUND(SUM(Profit),2) AS Total_Profit,
    COUNT(Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    ROUND(AVG(Final_Amount),2) AS Average_Order_Value,
    ROUND((SUM(Profit)/SUM(Final_Amount))*100,2) AS Profit_Margin_Percentage
FROM sales;

--2. How have revenue and profit changed month by month?
SELECT
    Year,
    Month,
    ROUND(SUM(Final_Amount),2) AS Revenue,
    ROUND(SUM(Profit),2) AS Profit
FROM sales
GROUP BY Year, Month
ORDER BY Year, Month;

--3. Which states generate the highest revenue and profit?
SELECT
    State,
    ROUND(SUM(Final_Amount),2) AS Revenue,
    ROUND(SUM(Profit),2) AS Profit
FROM sales
GROUP BY State
ORDER BY Revenue DESC;

--4. Which sales channels perform best?
SELECT
    Sales_Channel,
    COUNT(Order_ID) AS Orders,
    ROUND(SUM(Final_Amount),2) AS Revenue,
    ROUND(SUM(Profit),2) AS Profit
FROM sales
GROUP BY Sales_Channel
ORDER BY Revenue DESC;

--5. Which product categories contribute the most revenue and profit?
SELECT
    Product_Category,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Final_Amount),2) AS Revenue,
    ROUND(SUM(Profit),2) AS Profit
FROM sales
GROUP BY Product_Category
ORDER BY Revenue DESC;

--6. Which products generate the highest profit?
SELECT
    Product_Name,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM sales
GROUP BY Product_Name
ORDER BY Total_Profit DESC
LIMIT 10;

--7. Which products generate the lowest profit?
SELECT
    Product_Name,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM sales
GROUP BY Product_Name
ORDER BY Total_Profit ASC
LIMIT 10;

--8. Which stores generate the highest revenue and profit?
SELECT
    Store_Name,
    ROUND(SUM(Final_Amount),2) AS Revenue,
    ROUND(SUM(Profit),2) AS Profit,
    COUNT(Order_ID) AS Orders
FROM sales
GROUP BY Store_Name
ORDER BY Revenue DESC;

--9. Which customer segments contribute the highest revenue?
SELECT
    Customer_Segment,
    COUNT(Customer_ID) AS Customers,
    ROUND(SUM(Final_Amount),2) AS Revenue,
    ROUND(AVG(Final_Amount),2) AS Average_Order_Value
FROM sales
GROUP BY Customer_Segment
ORDER BY Revenue DESC;

--10. How does each membership type perform?
SELECT
    Membership_Type,
    COUNT(Customer_ID) AS Customers,
    ROUND(SUM(Final_Amount),2) AS Revenue,
    ROUND(AVG(Final_Amount),2) AS Average_Order_Value,
    ROUND(SUM(Profit),2) AS Profit
FROM Decathlon_Sales
GROUP BY Membership_Type
ORDER BY Revenue DESC;


--#ADVANCE SQL

-- 11. Which product categories generate more profit than the average category profit?
WITH category_profit AS (
    SELECT
        Product_Category,
        SUM(Profit) AS Total_Profit
    FROM sales
    GROUP BY Product_Category
)

SELECT *
FROM category_profit
WHERE Total_Profit >
(
    SELECT AVG(Total_Profit)
    FROM category_profit
)
ORDER BY Total_Profit DESC;


--12. Which stores perform best based on total revenue?
SELECT
    Store_Name,
    SUM(Final_Amount) AS Revenue,
    RANK() OVER(
        ORDER BY SUM(Final_Amount) DESC
    ) AS Revenue_Rank
FROM sales
GROUP BY Store_Name;

--13. Rank product categories based on profit without skipping rank?
SELECT
    Product_Category,
    SUM(Profit) AS Total_Profit,
    DENSE_RANK() OVER(
        ORDER BY SUM(Profit) DESC
    ) AS Profit_Rank
FROM sales
GROUP BY Product_Category;

--14. Which product generates the highest revenue within each category?
WITH ranked_products AS
(
SELECT
    Product_Category,
    Product_Name,
    SUM(Final_Amount) AS Revenue,

    ROW_NUMBER() OVER
    (
        PARTITION BY Product_Category
        ORDER BY SUM(Final_Amount) DESC
    ) AS rn

FROM sales

GROUP BY
Product_Category,
Product_Name
)

SELECT *
FROM ranked_products
WHERE rn = 1;

--15. What is the cumulative monthly revenue?
SELECT
    Order_Year,
    Order_Month,

    SUM(Final_Amount) AS Monthly_Revenue,

    SUM(SUM(Final_Amount))
    OVER
    (
        ORDER BY Order_Year, Order_Month
    ) AS Running_Revenue

FROM sales

GROUP BY
Order_Year,
Order_Month;


--16. How has revenue changed compared to the previous month?
WITH monthly_sales AS
(
SELECT

Order_Year,
Order_Month,

SUM(Final_Amount) AS Revenue

FROM sales

GROUP BY
Order_Year,
Order_Month
)

SELECT

*,

Revenue -
LAG(Revenue)
OVER
(
ORDER BY
Order_Year,
Order_Month
)
AS Revenue_Growth

FROM monthly_sales;

--17. How does this month's revenue compare with the next month?
WITH monthly_sales AS
(
SELECT

Order_Year,
Order_Month,

SUM(Final_Amount) AS Revenue

FROM sales

GROUP BY
Order_Year,
Order_Month
)

SELECT

*,

LEAD(Revenue)
OVER
(
ORDER BY
Order_Year,
Order_Month
)
AS Next_Month_Revenue

FROM monthly_sales;

--18. Classify each product based on total profit?
SELECT

Product_Name,

SUM(Profit) AS Total_Profit,

CASE

WHEN SUM(Profit)>=500000
THEN 'High Profit'

WHEN SUM(Profit)>=200000
THEN 'Medium Profit'

ELSE 'Low Profit'

END AS Profit_Category

FROM sales

GROUP BY Product_Name;

--19. Which products generate more revenue than the average product revenue?
SELECT
Product_Name,
SUM(Final_Amount) AS Revenue
FROM sales
GROUP BY Product_Name
HAVING SUM(Final_Amount) >

(
SELECT
AVG(product_revenue)
FROM
	(
	SELECT
	SUM(Final_Amount) AS product_revenue
	FROM sales
	GROUP BY Product_Name
	) x
)
ORDER BY Revenue DESC;

--20. How can customers be segmented into four spending groups?
WITH customer_spending AS
(
SELECT

Customer_ID,
Customer_Name,

SUM(Final_Amount) AS Total_Spending

FROM sales

GROUP BY
Customer_ID,
Customer_Name
)

SELECT

Customer_ID,
Customer_Name,
Total_Spending,

NTILE(4)
OVER
(
ORDER BY Total_Spending DESC
)
AS Spending_Quartile

FROM customer_spending;
