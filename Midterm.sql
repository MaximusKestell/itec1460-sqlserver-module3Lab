/* 1. SQL SELECT:

You're giving awards to employees based on the year they started working at Northwind.
Write a query to list all employees (FirstName, LastName) along with their start date. */

SELECT FirstName, LastName, HireDate
FROM Employees;

/* 2. SQL JOIN:

Create a simple report showing which employees are handling orders. Write a query that:

1. Lists employee names (FirstName and LastName)
2. Shows the OrderID for each order they've processed
3. Shows the OrderDate
4. Sorts the results by EmployeeID and then OrderDate

This basic report will help us see which employees are actively processing orders in the Northwing system. */

SELECT e.FirstName, e.LastName, o.OrderID, o.OrderDate
FROM Employees e 
JOIN Orders o ON e.EmployeeID = o.EmployeeID
ORDER BY e.EmployeeID, o.OrderDate;


/* 3. Functions and GROUP BY:

Create a simple report showing total sales by product category. 
Include the CategoryName and TotalSales (calculated as the sum 
of UnitPrice * Quantity). Sort your results by TotalSales in descending order. */

SELECT e.FirstName, e.LastName, o.OrderID, o.OrderDate
FROM Employees e 
JOIN Orders o ON e.EmployeeID = o.EmployeeID
ORDER BY e.EmployeeID, o.OrderDate;

/* 4. SQL Insert Statements:

Complete the following tasks:

Insert a new supplier named "Northwind Traders" based in Seattle, USA.
Create a new category called "Organic Products".
Update all products from supplier "Exotic Liquids" to belong to the new "Organic Products" category.
Insert a new product called "Minneapolis Pizza". You can choose the category, supplier, and other values. */

/* a */ 
INSERT INTO Suppliers (CompanyName, City, Country)
VALUES ('Northwind Traders', 'Seattle', 'USA');

/* b*/ 
INSERT INTO Categories (CategoryName, Description)
VALUES ('Organic Products', 'Products made with organic ingredients.');

/* c */ 
UPDATE Products 
SET CategoryID = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Organic Products')
WHERE SupplierID = 1;

/* d */ 
INSERT INTO Products (ProductName, SupplierID, CategoryID, UnitPrice)
VALUES ('Minneapolis Pizza', 1, 1, 12.99);

/* 5. SQL Update Statement:

Update all products from supplier "Exotic Liquids" to belong 
to the new "Organic Products" category. */

UPDATE Products
SET CategoryID = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Organic Products')
WHERE SupplierID = (SELECT SupplierID FROM Suppliers WHERE CompanyName = 'Exotic Liquids');

/* 6. SQL Delete Statement:

Remove the product "Minneapolis Pizza". */ 

DELETE FROM Products
WHERE ProductName = 'Minneapolis Pizza';

/* 7. Creating Tables and Constraints:

Create a new table named "EmployeePerformance" with the following columns:

PerformanceID (int, primary key, auto-increment)
EmployeeID (int, foreign key referencing Employees table)
Year (int)
Quarter (int)
SalesTarget (decimal(15,2))
ActualSales (decimal(15,2)) */
GO

CREATE TABLE EmployeePreformance (
    PerformanceID INT PRIMARY KEY,
    EmployeeID INT,
    Year INT,
    Quarter INT,
    SalesTarget DECIMAL(15,2),
    ActualSales DECIMAL(15,2),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


/* 8. Creating Views:

Create a view named "vw_ProductInventory" that shows ProductName,
 CategoryName, UnitsInStock, and UnitsOnOrder for all products.  */ 

USE Northwind; 

GO 

CREATE VIEW vw_ProductInventory AS
SELECT p.ProductName, c.CategoryName, p.UnitsInStock, p.UnitsOnOrder
FROM Products p 
JOIN Categories c ON p.CategoryID = c.CategoryID;


/* 9. Stored Procedures:

Create a stored procedure called "sp_UpdateProductInventory" that:

Takes two inputs: ProductID and NewStockLevel
Updates the UnitsInStock value for the product you specify
Makes sure the stock level is never less than zero  */ 

USE Northwind;

GO

CREATE PROCEDURE sp_UpdateProductInventory
    @ProductID INT,
    @NewStockLevel INT 
AS
BEGIN 
    IF @NewStockLevel < 0
    BEGIN
        PRINT 'Stock level can not be less then 0';
        RETURN;
    END

    UPDATE Products
    SET UnitsInStock = @NewStockLevel
    WHERE ProductID = @ProductID;

    PRINT 'Product inventory updated sucessfully.'
END;
GO 

/* Complex Query:

Write a query to find the top 5 customers by 
total freight costs. Include CustomerID, TotalFreightCost, 
NumberOfOrders, and AverageFreightPerOrder.   */ 

USE Northwind;

GO 

SELECT TOP 5
    o.CustomerID,
    SUM(o.Freight) AS TotalFrieghtCosts,
    COUNT(o.OrderID) AS NumberOfOrders,
    AVG(o.Freight) AS AverageFreightPerOrder
FROM Orders o 
GROUP BY o.CustomerID
ORDER BY TotalFreightCost DESC;
