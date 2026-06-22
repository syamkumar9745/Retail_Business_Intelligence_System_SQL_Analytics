-- Q1. Which products sell the most?

SELECT p.[Product Name], SUM(s.[Units Sold]) AS Total_Units_Sold
FROM Sales_Data s
JOIN Product_Information p ON s.[Product ID] = p.[Product ID]
GROUP BY p.[Product Name]
ORDER BY Total_Units_Sold DESC;

-- Q2. Which categories generate the highest revenue?

SELECT p.Category, SUM(s.Revenue) AS Total_Revenue
FROM Sales_Data s
JOIN Product_Information p ON s.[Product ID] = p.[Product ID]
GROUP BY p.Category
ORDER BY Total_Revenue DESC;

-- Q3. Which stores perform best?

SELECT st.[Site Name], SUM(s.Revenue) AS Revenue
FROM Sales_Data s
JOIN Site_Details st ON s.[Site ID] = st.[Site ID]
GROUP BY st.[Site Name]
ORDER BY Revenue DESC;

-- Q4. Which regions perform poorly?

SELECT st.Region, SUM(s.Revenue) AS Revenue
FROM Sales_Data s
JOIN Site_Details st ON s.[Site ID] = st.[Site ID]
GROUP BY st.Region
ORDER BY Revenue ASC;


-- Q5. Products close to stockout

SELECT p.[Product Name], i.[Ending Inventory] FROM Inventory_Data i JOIN Product_Information p ON i.[Product ID]=p.[Product ID] WHERE i.[Ending Inventory] < 20 ORDER BY i.[Ending Inventory];

-- Q6. Overstocked products

SELECT p.[Product Name], i.[Ending Inventory] FROM Inventory_Data i JOIN Product_Information p ON i.[Product ID]=p.[Product ID] WHERE i.[Ending Inventory] > 500 ORDER BY i.[Ending Inventory] DESC;

-- Q7. Products needing replenishment

SELECT p.[Product Name], i.Replenishment FROM Inventory_Data i JOIN Product_Information p ON i.[Product ID]=p.[Product ID] WHERE i.Replenishment > 0;

-- Q8. Stockout count

SELECT COUNT(*) AS Stockout_Count FROM Inventory_Data WHERE [Stockout Flag]='Yes';

-- Q9. Highest profit products

SELECT p.[Product Name], SUM(s.Revenue-(p.[Unit Cost]*s.[Units Sold])) AS Profit FROM Sales_Data s JOIN Product_Information p ON s.[Product ID]=p.[Product ID] GROUP BY p.[Product Name] ORDER BY Profit DESC;

-- Q10. Highest profit categories

SELECT p.Category, SUM(s.Revenue-(p.[Unit Cost]*s.[Units Sold])) AS Profit FROM Sales_Data s JOIN Product_Information p ON s.[Product ID]=p.[Product ID] GROUP BY p.Category ORDER BY Profit DESC;

-- Q11. High revenue but low profit products

SELECT p.[Product Name], SUM(s.Revenue) Revenue, SUM(s.Revenue-(p.[Unit Cost]*s.[Units Sold])) Profit FROM Sales_Data s JOIN Product_Information p ON s.[Product ID]=p.[Product ID] GROUP BY p.[Product Name] HAVING SUM(s.Revenue)>1000 ORDER BY Profit ASC;

-- Q12. Promotions that worked

SELECT pr.[Promotion ID], SUM(s.Revenue) Revenue FROM Promotions_and_Discounts pr JOIN Sales_Data s ON pr.[Product ID]=s.[Product ID] GROUP BY pr.[Promotion ID] ORDER BY Revenue DESC;

-- Q13. Promotions that failed

SELECT pr.[Promotion ID], SUM(s.Revenue) Revenue FROM Promotions_and_Discounts pr JOIN Sales_Data s ON pr.[Product ID]=s.[Product ID] GROUP BY pr.[Promotion ID] ORDER BY Revenue ASC;

-- Q14. Discount impact

SELECT AVG(Discounts) AS Avg_Discount, AVG([Units Sold]) AS Avg_Units_Sold FROM Sales_Data;

-- Q15. Most used discount type

SELECT [Discount Type], COUNT(*) AS Frequency FROM Promotions_and_Discounts GROUP BY [Discount Type] ORDER BY Frequency DESC;


-- Q16. High-value customers

SELECT c.[Customer ID], SUM(s.Revenue) AS Total_Spent FROM Customer_Demographics c JOIN Sales_Data s ON c.[Customer ID]=s.[Customer ID] GROUP BY c.[Customer ID] ORDER BY Total_Spent DESC;

-- Q17. Income group spending

SELECT c.[Income Bracket], SUM(s.Revenue) AS Total_Spend FROM Customer_Demographics c JOIN Sales_Data s ON c.[Customer ID]=s.[Customer ID] GROUP BY c.[Income Bracket] ORDER BY Total_Spend DESC;

-- Q18. Age group purchases

SELECT CASE WHEN Age<25 THEN '18-24' WHEN Age BETWEEN 25 AND 34 THEN '25-34' WHEN Age BETWEEN 35 AND 44 THEN '35-44' ELSE '45+' END AS Age_Group, SUM(s.Revenue) Revenue FROM Customer_Demographics c JOIN Sales_Data s ON c.[Customer ID]=s.[Customer ID] GROUP BY CASE WHEN Age<25 THEN '18-24' WHEN Age BETWEEN 25 AND 34 THEN '25-34' WHEN Age BETWEEN 35 AND 44 THEN '35-44' ELSE '45+' END ORDER BY Revenue DESC;
Advanced SQL

-- Q19. Top 5 Products Using Window Function

SELECT * FROM (SELECT p.[Product Name], SUM(s.Revenue) Revenue, RANK() OVER(ORDER BY SUM(s.Revenue) DESC) AS Product_Rank FROM Sales_Data s JOIN Product_Information p ON s.[Product ID]=p.[Product ID] GROUP BY p.[Product Name]) x WHERE Product_Rank <= 5;

-- Q20. Revenue Contribution Percentage

SELECT p.Category, SUM(s.Revenue) Revenue, ROUND(100.0 * SUM(s.Revenue)/SUM(SUM(s.Revenue)) OVER(),2) AS Revenue_Percentage FROM Sales_Data s JOIN Product_Information p ON s.[Product ID]=p.[Product ID] GROUP BY p.Category;