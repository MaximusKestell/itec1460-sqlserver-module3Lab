/* -- query to see all customers (left table) and the orders (right table)
-- uses left JOIN (order date will be null if cx exists but has no orders)
SELECT c.CustomerID, c.CompanyName, o.OrderID, o.OrderDate
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID; 

QUESTIONS
- Why are none of my commands working
-





SQL SELECT Statements: Write a query to list all products 
(ProductName) with their CategoryName and SupplierName. */

SELECT p.ProductName, c.CategoryName, s.CompanyName AS SupplierName
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN Suppliers s ON p.SupplierID = s.SupplierID;


/* SQL JOINs: Find all customers who have never placed an order. 
Display the CustomerID and CompanyName. */

SELECT c.CustomerID, c.CompanyName
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

SELECT Customers.CustomerID, Customers.CompanyName FROM Customers LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID WHERE Orders.OrderID IS NULL



/* Write select statement, common sense its FROM Employees. 
e.EmployeeID = o.EmployeeID (Matches the row in employees 
table with the corresponding rows in the Orders table where 
the EmployeeID values are the same)
(goes to below)
*/
/* Functions and GROUP BY: List the top 5 employees by total sales 
amount. Include EmployeeID, FirstName, LastName, and TotalSales. */


SELECT TOP 5 e.EmployeeID, e.FirstName, e.LastName,
ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalSales
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY TotalSales DESC;

/* SQL Insert Statement: Add a new product to the Products table with the following details:
ProductName: "Northwind Coffee"
SupplierID: 1
CategoryID: 1
QuantityPerUnit: "10 boxes x 20 bags"
UnitPrice: 18.00
UnitsInStock: 39
UnitsOnOrder: 0
ReorderLevel: 10
Discontinued: 0 */

INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
VALUES ('Northwind Coffee', 1, 1, '10 boxes X 20 bags', 18.00, 39, 0, 10, 0);

/* SQL Update Statement: Increase the UnitPrice of all 
products in the "Beverages" category by 10%. */

UPDATE Products
SET UnitPrice = ROUND(UnitPrice * 1.10, 2)
WHERE CategoryID = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Beverages');

/* SQL Insert and Delete Statements:
a) Insert a new order for customer VINET with today's date.
b) Delete the order you just created. */ 

INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipCountry)
VALUES ('VINET', 1, GETDATE(), 'USA');

SELECT TOP 1 OrderID FROM Orders WHERE CustomerID = 'VINET' ORDER BY OrderID DESC;

/* Creating Tables: Create a new table named "ProductReviews" with the following columns:

ReviewID (int, primary key)
ProductID (int, foreign key referencing Products table)
CustomerID (nchar(5), foreign key referencing Customers table)
Rating (int)
ReviewText (nvarchar(max))
ReviewDate (datetime) */ 

CREATE TABLE ProductReviews (
    ReviewID INT PRIMARY KEY,
    ProductID INT, 
    CustomerID NCHAR(5),
    Rating INT,
    ReviewText NVARCHAR(MAX),
    ReviewDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

/* Creating Views: Create a view named "vw_ProductSales" that shows ProductName, 
CategoryName, and TotalSales (sum of UnitPrice * Quantity) for each product. */

CREATE VIEW vw_ProductSales AS
SELECT 
    p.ProductName,
    c.CategoryName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalSales
FROM Products p 
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName, c.CategoryName;

/* Stored Procedures: Write a stored procedure named "sp_TopCustomersByCountry" that 
takes a country name as input and returns the top 3 customers by total order amount for 
that country. */ 

CREATE PROCEDURE sp_TopCustomersByCountry
    @Country NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON; 

    SELECT TOP 3
        c.CustomerID,
        c.CompanyName,
        ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalOrderAmount
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE o.ShipCountry = @Country
    GROUP BY c.CustomerID, c.CompanyName
    ORDER BY TotalOrderAmount DESC;
END;
GO







