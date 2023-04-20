/*USE TermProject;
SELECT Customer.CustomerID, COUNT(DISTINCT Orders.OrderID) AS [Orders per Customer]
FROM Orders JOIN Customer ON Orders.CustomerID = Customer.CustomerID
GROUP BY Customer.CustomerID
ORDER BY Customer.CustomerID ASC;

USE TermProject;
SELECT COUNT(OrderDetail.ProductID) AS [Items Purchased], Inventory.Product,
SUM(OrderDetail.Quantity)* Inventory.Price AS [Price Total]
FROM OrderDetail JOIN Inventory ON OrderDetail.ProductID = Inventory.ProductID
GROUP BY Inventory.Product, Inventory.Price, OrderDetail.ProductID
ORDER BY OrderDetail.ProductID;

USE TermProject;
SELECT COUNT(OrderDetail.ProductID) AS [Amount of Products Purchased],
AVG(Inventory.Price) AS [Average Price per Product]
FROM OrderDetail JOIN Inventory ON OrderDetail.ProductID = Inventory.ProductID;

SELECT MIN(Inventory.Price) As [Minimum Price],
MAX(Inventory.Price) AS [Maximum Price],
AVG(Inventory.Price) AS [Average Price]
FROM Inventory;*/