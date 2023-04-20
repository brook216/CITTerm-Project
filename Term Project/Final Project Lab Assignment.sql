/* Final Project Procedures */

USE Northwind;
GO
CREATE PROC spCustomers
AS
SELECT * FROM Customers
ORDER BY CustomerID;
GO

EXEC spCustomers;



-- Takes an input parameter
USE Northwind;
GO
CREATE PROC spGetCustomer
	@CustomerID int
AS
BEGIN
	SELECT * FROM Customers
	WHERE CustomerID = @CustomerID;
END
GO
EXEC spGETCustomer 1


-- Takes one input parameter and returns three output parameters
USE Northwind;
GO
CREATE PROC spCustomerContact
	@CustomerID int,
	@FirstName nvarchar(30) OUTPUT,
	@LastName nvarchar(50) OUTPUT,
	@HomePhone nvarchar(30) OUTPUT 
AS
SELECT @FirstName = FirstName, @LastName = LastName, @HomePhone = HomePhone
FROM Customers 
WHERE CustomerID = @CustomerID;
GO
-- Run the procedure
DECLARE @FirstName nvarchar(30);
DECLARE @LastName nvarchar(50);
DECLARE @HomePhone nvarchar(30);
EXEC spCustomerContact 3, @FirstName OUTPUT, @LastName OUTPUT, @HomePhone OUTPUT;
SELECT @FirstName AS 'First Name', @LastName AS 'Last Name', @HomePhone AS 'Home Phone Number';

-- Stored procedure that has a return value 
USE Northwind;
GO
CREATE PROC spEmployeeCount
AS
DECLARE @EmployeeCount int;
SELECT @EmployeeCount = COUNT(*)
FROM Employees 
RETURN @EmployeeCount;
GO

DECLARE @EmployeeCount int;
EXEC @EmployeeCount = spEmployeeCount;
PRINT 'There are ' + CONVERT(varchar, @EmployeeCount) + ' employees in your database';
GO


/* Final Project User Defined Functions */

-- creates the function
USE Northwind;
GO
CREATE FUNCTION fnGetCategory
    (@CategoryAmount nvarchar(50) = '%')
    RETURNS int
BEGIN
    RETURN (SELECT CategoryName FROM Categories WHERE CategoryName Like @CategoryName);
END; 

-- uses the function
GO
SELECT SupplierID, QuantityPerUnit, UnitPrice FROM Products 
WHERE SupplierID = dbo.fnGetCategory('2%');

USE Northwind;
GO
CREATE FUNCTION fnProducts
	(@ProductName nvarchar(50) = '%')
	RETURNS table
RETURN
	(SELECT * FROM Products WHERE ProductName LIKE @ProductName);
GO
SELECT * FROM dbo.fnProducts('%C%');

 /* Final Project Triggers */

 -- create archive table by copying customer table without any rows
 USE Northwind;
 GO
 SELECT * INTO CustomerQuota
 FROM Customers
 WHERE 1=0;

 -- update CustomerTransaction table and add activity column for status
 ALTER TABLE CustomerQuota
 ADD Progress varchar(50);
 GO

 -- create insert trigger
 CREATE TRIGGER CustomerQuota_INSERT ON Customers
    AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CustomerID int
	DECLARE @CompanyName nvarchar(30)
	DECLARE @ContactName nvarchar(50)
	DECLARE @Address nvarchar(100)
	DECLARE @PostalCode nvarchar(20)
	DECLARE @Phone nvarchar(30)
	DECLARE @Fax nvarchar(10)

    SELECT @CustomerID =INSERTED.CustomerID, @CompanyName = INSERTED.CompanyName, @ContactName = INSERTED.ContactName,
	@Address = INSERTED.Address, @PostalCode = INSERTED.PostalCode, @Phone = INSERTED.Phone, @Fax = INSERTED.Fax
	FROM INSERTED

    INSERT INTO CustomerQuota VALUES(@CustomerID,@CompanyName, @ContactName,@Address, @PostalCode, @Phone, @Fax, 'Inserted' )
END
GO
-- add row into customer to test insert trigger
INSERT INTO Customers VALUES(9,'Unknown','Chandler','101 Central Perk','10012','(231)-123-4567','NULL');
GO
-- view data in customer archive
SELECT * FROM CustomerQuota;
GO
 -- create delete trigger
 CREATE TRIGGER CustomerQuota_Delete ON Customers
    AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CustomerID int
	DECLARE @CompanyName nvarchar(30)
	DECLARE @ContactName nvarchar(50)
	DECLARE @Address nvarchar(100)
	DECLARE @PostalCode nvarchar(20)
	DECLARE @Phone nvarchar(30)
	DECLARE @Fax nvarchar(10)

    SELECT @CustomerID =DELETED.CustomerID, @CompanyName = DELETED.CompanyName, @ContactName = DELETED.ContactName,
	@Address = DELETED.Address,  @PostalCode = DELETED. PostalCode, @Phone = DELETED.Phone, @Fax = DELETED.Fax
	FROM DELETED

    INSERT INTO CustomerQuota VALUES(@CustomerID,@CompanyName, @ContactName,@Address, @PostalCode, @Phone, @Fax, 'Deleted' )
END
GO
-- delete row from customer to test delete trigger
DELETE FROM Customers WHERE CustomerID = 9;
GO

-- view data in customer archive
SELECT * FROM CustomerQuota;

GO
 -- create update trigger
 CREATE TRIGGER CustomerQuota_Update ON Customers
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CustomerID int
	DECLARE @CompanyName nvarchar(30)
	DECLARE @ContactName nvarchar(50)
	DECLARE @Address nvarchar(100)
	DECLARE @PostalCode nvarchar(20)
	DECLARE @Phone nvarchar(30)
	DECLARE @Fax nvarchar(10)

     SELECT @CustomerID =INSERTED.CustomerID, @CompanyName = INSERTED.CompanyName, @ContactName = INSERTED.ContactName,
	@Address = INSERTED.Address, @PostalCode = INSERTED.PostalCode, @Phone = INSERTED.Phone, @Fax = INSERTED.Fax
	FROM INSERTED

	-- Since all the data is being written to the archive table, there is no need to identify what was changed
    INSERT INTO CustomerQuota VALUES(@CustomerID,@CompanyName, @ContactName,@Address, @PostalCode, @Phone, @Fax, 'Updated' )
END
GO
-- insert a new row and then update the row (this will test the insert and update triggers)
INSERT INTO Customers VALUES(10,'Days of Our Lives','Joey','101 Central Perk','10012','(231)-123-4567','NULL');
GO
UPDATE Customers 
SET CompanyName = 'Unknown'
WHERE CustomerID = 10;
GO
-- view data in customer archive
SELECT * FROM CustomerQuota;