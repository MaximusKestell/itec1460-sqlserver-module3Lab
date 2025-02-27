-- create a new stored procedure that calsulates the total ammount 
--for an order
-- our store procedure accepts two parameters as input 
-- Accepts the order id and the total amountm then 
-- returns updated total as output. 
CREATE OR ALTER PROCEDURE CalculateOrderTotal
    @OrderID INT, 
    @TotalAmmount MONEY OUTPUT
AS 
BEGIN
    Set NOCOUNT ON;

    -- Calculate the total amount for given order
    SELECT @TotalAmmount = SUM(UnitPrice * Quantity * (1 - Discount))
    FROM [Order Details]
    WHERE OrderID = @OrderID

    -- check order exists - handle errror condition if orderid doesnt 
    --  match any items in order details table
    IF @TotalAmmount IS NULL
    BEGIN   
        SET @TotalAmmount = 0;
        PRINT 'Order ' + CAST(@OrderID AS NVARCHAR(10)) + ' not found.';
        RETURN;
    END

    -- output total ammount for order
    PRINT 'The total ammount for Order ' + CAST(@OrderID AS NVARCHAR(10)) + ' is $' + 
     CAST(@TotalAmmount AS NVARCHAR(20));
END
-- go causes stored procedure to run after its altered or created
GO


-- tests the stored procedure with a valid order
-- first declare the variables
DECLARE @OrderID INT = 10248;
DECLARE @TotalAmmount MONEY;

-- Call the stored procedure
EXEC CalculateOrderTotal
    @OrderID = @OrderID,
    @TotalAmmount = @TotalAmmount OUTPUT;


-- Print the results of the stored procedure
PRINT 'Returned total ammount: $' + CAST(ISNULL(@TotalAmmount, 0) AS NVARCHAR(20));

-- test with an invalid order

SET @OrderID = 99999;
SET @TotalAmmount = NULL;

EXEC CalculateOrderTotal
    @OrderID = @OrderID,
    @TotalAmmount = @TotalAmmount OUTPUT;

PRINT 'Returned total ammount: $' + CAST(ISNULL(@TotalAmmount, 0) AS NVARCHAR(20));


