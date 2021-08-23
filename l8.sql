
/*=====================================================================*/
/* Lab 8 – Database Warehouse (combination of Lab 5, 6 and 7)          */
/* Name: Ronak											               */
/* Student ID: 8700202                          				       */
/*=====================================================================*/


/*=====================================================================*/
/* Section 1: Lab 5 Create WonderfulWheels databse and requiredtables  */
/*=====================================================================*/

USE master;  --Use Master Database
GO  

--Create WonderfulWheels database, if exist, drop existing databse before creating a new one.

IF DB_ID (N'WonderfulWheels') IS NOT NULL  
DROP DATABASE WonderfulWheels;  
GO  
CREATE DATABASE WonderfulWheels 
GO

--UseWonderfulWheels Database from now on.
USE WonderfulWheels;
GO

--Start creating the table
/*==============================================================*/
/* Table: Location                                              */
/*==============================================================*/
CREATE TABLE [Location] (
   LocationID	int identity(1,1)	NOT NULL,
   StreeAddress	nvarchar(100)	NOT NULL,
   City			nvarchar(50)	NOT NULL,
   Province		char(2)			NOT NULL,
   PostalCode	char(7)			NOT NULL,
   CONSTRAINT PK_LOCATION PRIMARY KEY (LocationID)
)
GO

/*==============================================================*/
/* Table: Dealership                                            */
/*==============================================================*/
CREATE TABLE Dealership (
   DealershipID	int IDENTITY(1,1)	NOT NULL,
   LocationID	int					NOT NULL,
   DealerName	nvarchar(50)		NOT NULL,
   Phone		nvarchar(20)		      NULL,
   CONSTRAINT PK_DEALERSHIP PRIMARY KEY (DealershipID),
   CONSTRAINT FK_DEAL_LOC FOREIGN KEY (LocationID) REFERENCES Location (LocationID)
)
GO

/*==============================================================*/
/* Table: Person                                                */
/*==============================================================*/
CREATE TABLE Person (
   PersonID		int IDENTITY(1000,1)	NOT NULL,
   FirstName	nvarchar(50)	NOT NULL,
   LastName		nvarchar(50)	NOT NULL,
   Phone		nvarchar(20)	NULL,
   Email		nvarchar(100)	NULL,
   PerLocID	int				NOT NULL,
   DateofBirth	date			NULL,
   Title		char(2)			NULL,
   CONSTRAINT PK_PERSON PRIMARY KEY (PersonID),
   CONSTRAINT FK_PER_LOC FOREIGN KEY (PerLocID) REFERENCES Location (LocationID),
   CONSTRAINT CHK_TITLE	CHECK (Title='Mr' OR Title ='Ms')	
)
GO
/*==============================================================*/
/* Index: IndexPersonName                                       */
/*==============================================================*/
CREATE INDEX IndexPersonName ON Person ( FirstName ASC, LastName ASC)
GO

/*==============================================================*/
/* Table: Customer                                              */
/*==============================================================*/
CREATE TABLE Customer (
   CustomerID		int				NOT NULL,
   RegDate			date			NOT NULL,
   CONSTRAINT PK_CUSTOMER PRIMARY KEY (CustomerID),
   CONSTRAINT FK_CUS_PER FOREIGN KEY (CustomerID) REFERENCES Person (PersonID)
)
GO

/*==============================================================*/
/* Table: Employee                                              */
/*==============================================================*/
CREATE TABLE Employee (
   EmployeeID		int				NOT NULL,
   EmpDealID		int				NOT NULL,
   HireDate			date			NOT NULL,
   EmpRole			nvarchar(50)	NOT NULL,
   ManagerID		int				NULL, 
   CONSTRAINT PK_EMPLOYEE PRIMARY KEY (EmployeeID),
   CONSTRAINT FK_EMP_PER FOREIGN KEY (EmployeeID) REFERENCES Person (PersonID),
   CONSTRAINT FK_EMP_DEAL FOREIGN KEY (EmpDealID) REFERENCES Dealership (DealershipID),
   CONSTRAINT FK_PER_MAN FOREIGN KEY (ManagerID) REFERENCES Employee (EmployeeID)
)
GO

/*==============================================================*/
/* Table: SalaryEmployee                                        */
/* Set Salary to Default 1000 since Check contraint should      */
/* not be less than 1000										*/
/*==============================================================*/
CREATE TABLE SalaryEmployee (
   EmployeeID		int				NOT NULL,
   Salary			decimal(12,2)	NOT NULL DEFAULT 1000.00,
   CONSTRAINT PK_SALEMPLOYEE PRIMARY KEY (EmployeeID),
   CONSTRAINT FK_SEMP_EMP FOREIGN KEY (EmployeeID) REFERENCES Employee (EmployeeID),
   CONSTRAINT CHK_SALARY	CHECK (Salary>=1000)
)
GO

/*==============================================================*/
/* Table: CommissionEmployee                                    */
/* Set Commission to Default 10 since Check contraint should    */
/* not be less than 10  										*/
/*==============================================================*/
CREATE TABLE CommissionEmployee (
   EmployeeID		int				NOT NULL,
   Commission		decimal(12,2)	NOT NULL DEFAULT 10.00,
   CONSTRAINT PK_COMEMPLOYEE PRIMARY KEY (EmployeeID),
   CONSTRAINT FK_CEMP_EMP FOREIGN KEY (EmployeeID) REFERENCES Employee (EmployeeID),
   CONSTRAINT CHK_COMMISSION	CHECK (Commission>=10)
)
GO

/*==============================================================*/
/* Table: Vehicle                                               */
/* Set Price to Default 1 since Check contraint should          */
/* not be less than 1											*/
/* Set VehicleYear Check contraint to be greater than 1800      */
/* and less than current year to capture appropriate Year   	*/
/*==============================================================*/

CREATE TABLE Vehicle (
   VehicleID	int	IDENTITY(100001,1)			NOT NULL,
   Make			nvarchar(50)	NOT NULL,
   Model		nvarchar(50)	NOT NULL,
   VehicleYear	int				NOT NULL,
   Colour		nvarchar(10)	NOT NULL,
   KM			int				NOT NULL,
   Price		decimal(12,2)	NULL DEFAULT 1.00,
   CONSTRAINT PK_VEHICLE PRIMARY KEY (VehicleID),
   CONSTRAINT CHK_PRICE	CHECK (Price>=1),
   CONSTRAINT CHK_YEAR	CHECK (VehicleYear>=1800 AND VehicleYear <= YEAR(GETDATE()))

)
GO

/*==============================================================*/
/* Table: VehicleOrder                                          */
/*==============================================================*/
CREATE TABLE [Order] (
   OrderID		int IDENTITY(1,1)	NOT NULL,
   OrderCustID	int				NOT NULL,
   OrderEmpID	int				NOT NULL,
   OrderDate	date			NOT NULL DEFAULT GetDate(),
   OrderDealID	int				NOT NULL,
   CONSTRAINT PK_ORDER PRIMARY KEY (OrderID),
   CONSTRAINT FK_ORD_CUST FOREIGN KEY (OrderCustID) REFERENCES Customer (CustomerID),
   CONSTRAINT FK_ORD_EMP FOREIGN KEY (OrderEmpID) REFERENCES Employee (EmployeeID),
   CONSTRAINT FK_ORD_DEAL FOREIGN KEY (OrderDealID) REFERENCES Dealership (DealershipID)
)
GO


/*==============================================================*/
/* Table: VOrderItem                                            */
/* Set FinalSalePrice to Default 1 since Check contraint should */
/* not be less than 1											*/
/*==============================================================*/
CREATE TABLE OrderItem (
   OrderID			int		NOT NULL,
   VehicleID		int		NOT NULL,
   FinalSalePrice	decimal(12,2)	NULL DEFAULT 1.00,
   CONSTRAINT PK_ORDERITEM PRIMARY KEY (OrderID, VehicleID),
   CONSTRAINT FK_ORDITM_ORD FOREIGN KEY (OrderID) REFERENCES [Order] (OrderID),
   CONSTRAINT FK_ORDITM_VEHICLE FOREIGN KEY (VehicleID) REFERENCES Vehicle (VehicleID),
   CONSTRAINT CHK_FINALSALEPRICE	CHECK (FinalSalePrice>=1)

)
GO

/*==============================================================*/
/* Table: Account                                               */
/*==============================================================*/
CREATE TABLE Account (
   AccountID			int	IDENTITY(1,1)	NOT NULL,
   CustomerID			int		NOT NULL,
   AccountBalance		decimal(12,2)	NOT NULL DEFAULT 0.00,
   LastPaymentAmount	decimal(12,2)	NOT NULL DEFAULT 0.00,
   LastPaymentDate		date	NULL,
   CONSTRAINT PK_ACCOUNT PRIMARY KEY (AccountID),
   CONSTRAINT FK_ACC_CUST FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID),
   CONSTRAINT CHK_BALANCE	CHECK (AccountBalance>=0),
   CONSTRAINT CHK_AMOUNT	CHECK (LastPaymentAmount>=0)

)
GO


/*=====================================================================*/
/* Section 2: Lab 5 Insert new records into the database tables        */
/*=====================================================================*/
----------------------------------------------------------------------------------------------------
----------------------- Transaction to insert new data into the database ---------------------------

BEGIN TRY

		BEGIN TRANSACTION 

		
		---------------Insert all locations into the Location Table---------------
		INSERT INTO Location ([StreeAddress],[City],[Province],[PostalCode])
		VALUES
		('22 Queen St', 'Waterloo', 'ON', 'N2A48B'),
		('44 King St', 'Guelph', 'ON', 'G2A47U'),
		('55 Krug St', 'Kitchener', 'ON', 'N2A4U7'),
		('77 Lynn Ct', 'Toronto', 'ON', 'M7U4BA'),
		('88 King St', 'Guelph', 'ON', 'G2A47U'),
		('99 Lynn Ct', 'Toronto', 'ON', 'M7U4BA'),
		('44 Cedar St', 'Kitchener', 'ON', 'N2A7L6'),
		('221 Kitng St W', 'Kitchner', 'ON', 'G8B3C6'),
		('77 Victoria St N', 'Campbridge', 'ON', 'N1Z8B8'),
		('100 White Oak Rd', 'London', 'ON', 'L9B1W2')


		

	    --------------------Insert vehicles into the Vehicle Table-------------------------

		INSERT INTO [dbo].[Vehicle]([Make],[Model],[VehicleYear],[Colour],[KM],[Price])
		VALUES
		('Toyota', 'Corola', '2018', 'Silver', '45000', '18000'),
		('Toyota', 'Corola', '2016', 'White', '60000', '15000'),
		('Toyota', 'Corola', '2016', 'Black', '65000', '14000'),
		('Toyota', 'Camry', '2018', 'White', '35000', '22000'),
		('Honda', 'Acord', '2020', 'Gray', '10000', '24000'),
		('Honda', 'Acord', '2015', 'Red', '85000', '16000'),
		('Honda', 'Acord', '2000', 'Gray', '10000', '40000'),
		('Ford', 'Focus', '2017', 'Blue', '40000', '16000')


		---------------Insert Kitchener Dealership into the Dealership Table---------------

		DECLARE @Street INT
		DECLARE @PerID INT
		DECLARE @DealID INT

		SELECT	@Street =  LocationID 
		FROM [Location] 
		WHERE [Location].StreeAddress ='221 Kitng St W'
		
		INSERT INTO Dealership ([LocationID],[DealerName],[Phone])
		VALUES(@Street, 'Kitchener', '519-222-2222')

		SELECT	@Street =  LocationID 
		FROM [Location] 
		WHERE [Location].StreeAddress ='77 Victoria St N'

		INSERT INTO Dealership ([LocationID],[DealerName],[Phone])
		VALUES(@Street, 'Cambrige', '519-222-5555')

		SELECT	@Street =  LocationID 
		FROM [Location] 
		WHERE [Location].StreeAddress ='100 White Oak Rd'

		INSERT INTO Dealership ([LocationID],[DealerName],[Phone])
		VALUES(@Street, 'London', '519-222-4444')
		

		--Select the ID for Kitchener Dealership to be used for all the employees and orders
		SELECT @DealID = DealershipID 
		FROM Dealership  
		WHERE DealerName = 'Kitchener'
		
		---------------Insert Persons into the Person Table, Customer Table, Employee Table---------------
		DECLARE @ManID INT
		--Insert John's details in Person, Employee and Salary Table
		SELECT	@Street =  LocationID 
		FROM [Location] 
		WHERE [Location].StreeAddress ='22 Queen St'
		
		INSERT INTO Person([FirstName],[LastName],[Phone],[Email],[DateofBirth],[Title],[PerLocID])
		VALUES ('John', 'Smith', '519-444-3333', 'jsmtith@email.com', '1968-04-09', 'Mr', @Street)


		SELECT @PerID = PersonID 
		FROM Person 
		WHERE FirstName = 'John' AND LastName ='Smith'

		INSERT INTO [dbo].[Employee]([EmployeeID],[HireDate],[EmpRole],[EmpDealID])
		VALUES (@PerID, '2019-01-01', 'Manager',@DealID)

		INSERT INTO [dbo].[SalaryEmployee]([EmployeeID],[Salary])
		VALUES (@PerID, 95000)


		--Insert Mary's details in Person, Employee and Salary Table
		SELECT	@Street =  LocationID 
		FROM [Location] 
		WHERE [Location].StreeAddress ='44 King St'

		INSERT INTO Person([FirstName],[LastName],[Phone],[Email],[DateofBirth],[Title],[PerLocID])
		VALUES ('Mary', 'Brown', '519-888-3333', 'mbrown@email.com', '1972-02-04', 'Ms', @Street)

		SELECT @PerID = PersonID 
		FROM Person 
		WHERE FirstName = 'Mary' AND LastName ='Brown'

		SELECT @ManID = PersonID 
		FROM Person 
		WHERE FirstName = 'John' AND LastName ='Smith'

		INSERT INTO [dbo].[Employee]([EmployeeID],[HireDate],[EmpRole],[EmpDealID], [ManagerID])
		VALUES (@PerID , '2017-04-01', 'Office Admin', @DealID, @ManID)

		INSERT INTO [dbo].[SalaryEmployee]([EmployeeID],[Salary])
		VALUES (@PerID , 65000)

		
		--Insert Tracy's details in Person, Employee and Salary Table and Customer Table
		SELECT	@Street =  LocationID 
		FROM [Location] 
		WHERE [Location].StreeAddress ='55 Krug St'

		INSERT INTO Person([FirstName],[LastName],[Phone],[Email],[DateofBirth],[Title],[PerLocID])
		VALUES ('Tracy', 'Spencer', '519-888-2222', 'tspencer@email.com', '1998-07-22', 'Ms', @Street)


		SELECT @PerID = PersonID 
		FROM Person 
		WHERE FirstName = 'Tracy' AND LastName ='Spencer'

		INSERT INTO [dbo].[Employee]([EmployeeID],[HireDate],[EmpRole],[EmpDealID], [ManagerID])
		VALUES (@PerID, '2019-08-01', 'Sales', @DealID, @ManID)

		INSERT INTO [dbo].[CommissionEmployee]([EmployeeID],[Commission])
		VALUES (@PerID, '13')

		INSERT INTO [dbo].[Customer]([CustomerID],[RegDate])
		VALUES (@PerID, '2019-12-01')



		--Insert James' details in Person, Employee and Salary Table
		SELECT	@Street =  LocationID 
		FROM [Location] 
		WHERE [Location].StreeAddress ='77 Lynn Ct'
		
		INSERT INTO Person([FirstName],[LastName],[Phone],[Email],[DateofBirth],[Title],[PerLocID])
		VALUES ('James', 'Stewart', '416-888-1111', 'jstewart@email.com', '1996-11-22', 'Mr', @Street)

		SELECT @PerID = PersonID 
		FROM Person 
		WHERE FirstName = 'James' AND LastName ='Stewart'

		INSERT INTO [dbo].[Employee]([EmployeeID],[HireDate],[EmpRole],[EmpDealID], [ManagerID])
		VALUES (@PerID, '2020-01-01', 'Sales', @DealID, @ManID)

		INSERT INTO [dbo].[CommissionEmployee]([EmployeeID],[Commission])
		VALUES (@PerID, '15')



		--Insert Paul's details in Person, Employee and Salary Table
		SELECT	@Street =  LocationID 
		FROM [Location] 
		WHERE [Location].StreeAddress ='55 Krug St'

		INSERT INTO Person([FirstName],[LastName],[Phone],[Email],[DateofBirth],[Title],[PerLocID])
		VALUES ('Paul', 'Newman', '519-888-4444', 'pnewman@email.com', '1992-09-23', 'Mr', @Street)

		SELECT @PerID = PersonID 
		FROM Person 
		WHERE FirstName = 'Paul' AND LastName ='Newman'

		INSERT INTO [dbo].[Employee]([EmployeeID],[HireDate],[EmpRole],[EmpDealID], [ManagerID])
		VALUES (@PerID, '2019-01-01', 'Sales', @DealID, @ManID)

		INSERT INTO [dbo].[CommissionEmployee]([EmployeeID],[Commission])
		VALUES (@PerID, '10')


		--Insert Tom's details in Person and Customer Table
		SELECT	@Street =  LocationID 
		FROM [Location] 
		WHERE [Location].StreeAddress ='55 Krug St'

		INSERT INTO Person([FirstName],[LastName],[Phone],[Email],[DateofBirth],[Title],[PerLocID])
		VALUES ('Tom', 'Cruise', '519-333-2222', 'tcruise@email.com', '1962-03-22', 'Mr', @Street)

		SELECT @PerID = PersonID 
		FROM Person 
		WHERE FirstName = 'Tom' AND LastName ='Cruise'

		INSERT INTO [dbo].[Customer]([CustomerID],[RegDate])
		VALUES (@PerID, '2020-01-01')


		--Insert Bette's details in Person and Customer Table
		SELECT	@Street =  LocationID 
		FROM [Location] 
		WHERE [Location].StreeAddress ='99 Lynn Ct'

		INSERT INTO Person([FirstName],[LastName],[Phone],[Email],[DateofBirth],[Title],[PerLocID])
		VALUES ('Bette', 'Davis', '519-452-1111', 'bdavis@email.com', '1952-09-01', 'Ms', @Street)

		SELECT @PerID = PersonID 
		FROM Person 
		WHERE FirstName = 'Bette' AND LastName ='Davis'

		INSERT INTO [dbo].[Customer]([CustomerID],[RegDate])
		VALUES (@PerID, '2020-02-01')


		--Insert Grace's details in Person and Customer Table
		SELECT	@Street =  LocationID 
		FROM [Location] 
		WHERE [Location].StreeAddress ='88 King St'
		
		INSERT INTO Person([FirstName],[LastName],[Phone],[Email],[DateofBirth],[Title],[PerLocID])
		VALUES ('Grace', 'Kelly', '416-887-2222', 'gkelly@email.com', '1973-06-09', 'Ms', @Street)

		SELECT @PerID = PersonID 
		FROM Person 
		WHERE FirstName = 'Grace' AND LastName ='Kelly'
		
		INSERT INTO [dbo].[Customer]([CustomerID],[RegDate])
		VALUES (@PerID, '2020-10-01')


		--Insert Doris' details in Person and Customer Table
		SELECT	@Street =  LocationID 
		FROM [Location] 
		WHERE [Location].StreeAddress ='44 Cedar St'

		INSERT INTO Person([FirstName],[LastName],[Phone],[Email],[DateofBirth],[Title],[PerLocID])
		VALUES ('Doris', 'Day', '519-888-5456', 'dday@email.com', '1980-05-25', 'Ms', @Street)

		SELECT @PerID = PersonID 
		FROM Person 
		WHERE FirstName = 'Doris' AND LastName ='Day'
		
		INSERT INTO [dbo].[Customer]([CustomerID],[RegDate])
		VALUES (@PerID, '2020-08-08')




		---------------------Insert orders into Order Table-------------------------------------------------
		DECLARE @EmpID INT
		DECLARE @VehID INT
		DECLARE @OrdID INT

		--SELECT @DealID = DealershipID FROM Dealership  WHERE DealerName = 'Kitchener Dealership'

		-----Insert Tom's Order into Order and OrderItem Tables
		SELECT @PerID = CustomerID 
		FROM Customer 
		JOIN Person  ON CustomerID = Person.PersonID 
		WHERE Person.FirstName = 'Tom'

		SELECT @EmpID = EmployeeID 
		FROM Employee 
		JOIN Person  ON EmployeeID = Person.PersonID 
		WHERE Person.FirstName = 'Tracy'

		INSERT INTO [Order]([OrderCustID],[OrderEmpID],[OrderDate],[OrderDealID])
		VALUES (@PerID, @EmpID,'2020-11-01',@DealID)

		SELECT @OrdID = OrderID 
		FROM [ORDER] 
		JOIN Person ON OrderCustID = Person.PersonID 
		WHERE Firstname = 'Tom' AND LastName = 'Cruise'

		SELECT @VehID = VehicleID 
		FROM Vehicle 
		WHERE Make='Toyota' AND Model = 'Corola' AND VehicleYear = '2018' AND Colour = 'Silver'
		
		INSERT INTO OrderItem ([OrderID],[VehicleID],[FinalSalePrice])
		VALUES(@OrdID, @VehID,'17500')

		SELECT @VehID = VehicleID 
		FROM Vehicle 
		WHERE Make='Toyota' AND Model = 'Camry' AND VehicleYear = '2018' AND Colour = 'White'

		INSERT INTO OrderItem ([OrderID],[VehicleID],[FinalSalePrice])
		VALUES(@OrdID, @VehID,'21000')


		-----Insert Bette's Order into Order and OrderItem Tables
		SELECT @PerID = CustomerID 
		FROM Customer 
		JOIN Person  ON CustomerID = Person.PersonID 
		WHERE Person.FirstName = 'Bette'

		INSERT INTO [dbo].[Order]([OrderCustID],[OrderEmpID],[OrderDate],[OrderDealID])
		VALUES (@PerID, @EmpID,'2020-11-04',@DealID)

		SELECT @OrdID = OrderID 
		FROM [ORDER] 
		JOIN Person ON OrderCustID = Person.PersonID 
		WHERE Firstname = 'Bette' AND LastName = 'Davis'

		SELECT @VehID = VehicleID 
		FROM Vehicle 
		WHERE Make='Ford' AND Model = 'Focus' AND VehicleYear = '2017' AND Colour = 'Blue'

		INSERT INTO OrderItem ([OrderID],[VehicleID],[FinalSalePrice])
		VALUES(@OrdID, @VehID,'15000')


		-----Insert Tracy's Order into Order and OrderItem Tables
		SELECT @PerID = CustomerID 
		FROM Customer JOIN Person  ON CustomerID = Person.PersonID 
		WHERE Person.FirstName = 'Tracy'

		SELECT @EmpID = EmployeeID 
		FROM Employee 
		JOIN Person  ON EmployeeID = Person.PersonID 
		WHERE Person.FirstName = 'James'

		INSERT INTO [dbo].[Order]([OrderCustID],[OrderEmpID],[OrderDate],[OrderDealID])
		VALUES (@PerID, @EmpID,'2020-11-05',@DealID)

		SELECT @OrdID = OrderID 
		FROM [ORDER] JOIN Person ON OrderCustID = Person.PersonID 
		WHERE Firstname = 'Tracy' AND LastName = 'Spencer'

		SELECT @VehID = VehicleID 
		FROM Vehicle 
		WHERE Make='Honda' AND Model = 'Acord' AND VehicleYear = '2015' AND Colour = 'Red'

		INSERT INTO OrderItem ([OrderID],[VehicleID],[FinalSalePrice])
		VALUES(@OrdID, @VehID,'15000')

		COMMIT TRANSACTION 

	END TRY
	BEGIN CATCH	

		ROLLBACK TRANSACTION		

		INSERT INTO EventLog.dbo.DbErrorLog (UserName, ErrorNumber, ErrorState, ErrorSeverity, ErrorLine, ErrorProcedure, ErrorMessage)
		VALUES (SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE());		

	END CATCH
GO



/*=====================================================================*/
/* Section 3: Lab 7 Create WonderfulWheels Data Warehouse              */
/*=====================================================================*/

USE master;  --Use Master Database
GO  

--Create WonderfulWheelsDW data warehouse, if exist, drop existing databse before creating a new one.
Use master
go
IF DB_ID (N'WonderfulWheelsDW') IS NOT NULL  
DROP DATABASE WonderfulWheelsDW;  
GO  
CREATE DATABASE WonderfulWheelsDW 
GO
--UseWonderfulWheels Database from now on.
USE WonderfulWheels;
GO

-- Create and Load CommissionEmployee dimension table
	
	SELECT 		
		IDENTITY(INT,1,1) AS EmployeeSK,
		CE.EmployeeID AS EmployeeAK,
		P.Title,
		P.FirstName,
		P.LastName,
		P.DateofBirth,
		P.Phone,
		P.Email,
		E.HireDate,
		E.EmpRole,
		CE.Commission,
		CONCAT(M.FirstName,' ', M.LastName) AS Manager
	INTO [WonderfulWheelsDW].[dbo].[Dim_CommissionEmployee]
	FROM [dbo].[CommissionEmployee] AS CE
		JOIN [dbo].[Employee] AS E ON E.EmployeeID = CE.EmployeeID
		JOIN  [dbo].[Person] AS P on P.PersonID = CE.EmployeeID
		JOIN [dbo].[Employee] AS E2 ON E2.EmployeeID = E.ManagerID
		JOIN  [dbo].[Person] AS M on M.PersonID = E2.EmployeeID

GO

	--Alter the table to make EmployeeSK the Primary Key
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Dim_CommissionEmployee]
	ADD CONSTRAINT PK_DimEmployee
	PRIMARY KEY (EmployeeSK)

GO
	-- Test 
	SELECT * FROM [WonderfulWheelsDW].[dbo].[Dim_CommissionEmployee]

GO


-- Create and Load Customer dimension table
	
	SELECT 		
		IDENTITY(INT,1,1) AS CustomerSK,
		C.CustomerID AS CustomerAK,
		P.Title,
		P.FirstName,
		P.LastName,
		P.DateofBirth,
		P.Phone,
		P.Email,
		C.RegDate
	INTO [WonderfulWheelsDW].[dbo].[Dim_Customer]
	FROM [dbo].[Customer] AS C
		JOIN  [dbo].[Person] AS P on P.PersonID = C.CustomerID

GO

	--Alter the table to make CustomerSK the Primary Key
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Dim_Customer]
	ADD CONSTRAINT PK_DimCustomer
	PRIMARY KEY (CustomerSK)

GO
	-- Test 
	SELECT * FROM [WonderfulWheelsDW].[dbo].[Dim_Customer]

GO

-- Create and Load Vehicle dimension table

CREATE TABLE [WonderfulWheelsDW].[dbo].[Dim_Vehicle] (
   VehicleSK	int	IDENTITY(1,1)			NOT NULL,
   VehicleAK	int NOT NULL,
   Make			nvarchar(50)	NOT NULL,
   Model		nvarchar(50)	NOT NULL,
   VehicleYear	int				NOT NULL,
   Colour		nvarchar(10)	NOT NULL,
   KM			int				NOT NULL,
   Price		decimal(12,2)	NULL,
   CONSTRAINT PK_DimVehicle PRIMARY KEY (VehicleSK)
)
GO

	INSERT INTO [WonderfulWheelsDW].[dbo].[Dim_Vehicle] (VehicleAK, Make, Model, VehicleYear, Colour, KM, Price)
	SELECT
		VehicleID,
		Make,
		Model,
		VehicleYear,
		Colour,
		KM,
		Price 
	FROM [dbo].[Vehicle]
GO
	-- Test 
	SELECT * FROM [WonderfulWheelsDW].[dbo].[Dim_Vehicle]

GO


-- Create and Load Dealership dimension table
	
	SELECT 		
		IDENTITY(INT,1,1) AS DealershipSK,
		DealershipID AS DealershipAK,
		DealerName,
		Phone,
		L.StreeAddress,
		L.City,
		L.Province,
		L.PostalCode
	INTO [WonderfulWheelsDW].[dbo].[Dim_Dealership]
	FROM [dbo].[Dealership] AS D
	JOIN [Location] AS L ON L.LocationID = D.LocationID

GO

	--Alter the table to make DealershipSK the Primary Key
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Dim_Dealership]
	ADD CONSTRAINT PK_DimDealership
	PRIMARY KEY (DealershipSK)

GO
	-- Test 
	SELECT * FROM [WonderfulWheelsDW].[dbo].[Dim_Dealership]

GO

-- Create and Load Date dimension table

declare @StartDate date
declare @EndDate date
declare @TempDate date

set @StartDate = '1990-01-01'	-- Set this to whatever date you like to begin with
set @EndDate = '2049-12-31'	-- Set this to your final date. No date in your systems should exceed this value

declare @Counter int
declare @NumberOfDays int

set @Counter = 0
set @NumberOfDays = datediff(dd,@StartDate,@EndDate)

if not exists (
	select *
	from sys.tables where name = 'Dim_Date'
)
begin

create table [WonderfulWheelsDW].[dbo].[Dim_Date] (
	DateSK int not null,
	[Date] date not null,
	StandardDate varchar(10) not null,
	FullDate varchar(50) not null,
	[Year] int not null,
	[Month] tinyint not null,
	[MonthName] varchar(10) not null,
	[Day] tinyint not null,
	[DayOfWeek] tinyint not null,
	[DayName] varchar(10) not null,
	WeekOfYear tinyint not null,
	[DayOfYear] smallint not null,
	CalendarQuarter tinyint not null
);

end

-- Insert Inferred Member
insert [WonderfulWheelsDW].[dbo].[Dim_Date] (
	DateSK,[Date],StandardDate,FullDate,
	[Year],[Month],[MonthName],[Day],[DayOfWeek],[DayName],
	WeekOfYear,[DayOfYear],CalendarQuarter
) values (
	19000101,'1900-01-01','01/01/1900','January 1, 1900',
	1900,1,'January',1,2,'Monday',
	1,1,1);


set @TempDate = @StartDate

while @Counter <= @NumberOfDays
begin

insert [WonderfulWheelsDW].[dbo].[Dim_Date] (
	DateSK,
	[Date],
	StandardDate,
	FullDate,
	[Year],
	[Month],
	[MonthName],
	[Day],
	[DayOfWeek],
	[DayName],
	WeekOfYear,
	[DayOfYear],
	CalendarQuarter
) 
select year(@TempDate) * 10000 + month(@TempDate) * 100 + day(@TempDate) as DateSK,
	cast(@TempDate as date) as [Date],
	convert(varchar,@TempDate,101) as StandardDate,
	datename(mm,@TempDate) + ' ' + cast(day(@TempDate) as varchar(2)) + ', ' + cast(year(@TempDate) as char(4)) as FullDate,
	year(@TempDate) as [Year],
	month(@TempDate) as [Month],
	datename(mm,@TempDate) as [MonthName],
	day(@TempDate) as [Day],
	datepart(dw,@TempDate) as [DayOfWeek],
	datename(dw,@TempDate) as [DayName],
	datepart(wk,@TempDate) as WeekOfYear,
	datepart(dy,@TempDate) as [DayOfYear],
	case	when month(@TempDate) between 1 and 3 then 1
			when month(@TempDate) between 4 and 6 then 2
			when month(@TempDate) between 7 and 9 then 3
			when month(@TempDate) between 10 and 12 then 4
	end as CalendarQuarter

	set @Counter = @Counter + 1
	set @TempDate = DateAdd(dd,1,@TempDate)

end

if not exists (
select * from sys.indexes
where object_name(object_id) = 'Dim_Date'
and type_desc = 'CLUSTERED'
)
begin
-- Add PK/Clustered Index
alter table [WonderfulWheelsDW].[dbo].[Dim_Date]
add constraint PK_Dim_Date primary key clustered(DateSK);
end

GO
 ---Test
SELECT * FROM [WonderfulWheelsDW].[dbo].[Dim_Date]

GO

-- Create and Load FactSales Fact table
	SELECT DISTINCT 
		O.OrderID, -- This will become the first PK (Since OrderItem table have composite PK)
		OI.VehicleID, --This will become the second PK (Since OrderItem table have composite PK)
		ROW_NUMBER() OVER(PARTITION BY O.OrderID ORDER BY OI.OrderID, OI.VehicleID) AS OrderItemID,
		CAST (REPLACE (O.OrderDate,'-','') AS int) AS OrderDateSK,
		E.EmployeeSK,
		C.CustomerSK,
		V.VehicleSK,
		D.DealershipSK,
		OI.FinalSalePrice,
		CAST((Commission*FinalSalePrice) AS decimal(12,2)) AS CommissionAmount
	INTO [WonderfulWheelsDW].[dbo].[Fact_Sales]
	FROM [dbo].[Order] AS O
	JOIN [dbo].[OrderItem] AS OI ON OI.OrderID= O.OrderID
	LEFT JOIN [WonderfulWheelsDW].[dbo].[Dim_CommissionEmployee] as E ON E.EmployeeAK=O.OrderEmpID
	LEFT JOIN [WonderfulWheelsDW].[dbo].[Dim_Customer] as C ON C.CustomerAK=O.OrderCustID
	LEFT JOIN [WonderfulWheelsDW].[dbo].[Dim_Vehicle]as V ON V.VehicleAK=OI.VehicleID
	LEFT JOIN [WonderfulWheelsDW].[dbo].[Dim_Dealership] AS D ON D.DealershipAK=O.OrderDealID
GO
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Fact_Sales]
	ALTER COLUMN OrderItemID INT NOT NULL
GO

	--Alter the table to make OrderID and VehicleID the Primary Key
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Fact_Sales]
	ADD CONSTRAINT PK_FactSales
	PRIMARY KEY (OrderID, OrderItemID)
GO
    --Alter the table to make DelaershipSK the Foreign Key
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Fact_Sales]
	ADD CONSTRAINT FK_FactSales_DimDealership
	FOREIGN KEY (DealershipSK) REFERENCES Dim_Dealership(DealershipSK)

GO
    --Alter the table to make CustomerSK the Foreign Key
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Fact_Sales]
	ADD CONSTRAINT FK_FactSales_DimCustomer
	FOREIGN KEY (CustomerSK) REFERENCES Dim_Customer(CustomerSK)

GO
	--Alter the table to make EmployeeSK the Foreign Key
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Fact_Sales]
	ADD CONSTRAINT FK_FactSales_DimEmployee
	FOREIGN KEY (EmployeeSK) REFERENCES Dim_CommissionEmployee(EmployeeSK)

GO
	--Alter the table to make VehicleSK the Foreign Key
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Fact_Sales]
	ADD CONSTRAINT FK_FactSales_DimVehicle
	FOREIGN KEY (VehicleSK) REFERENCES Dim_Vehicle(VehicleSK)

GO
--Alter the table to make OrderItemSK the Foreign Key
	ALTER TABLE [WonderfulWheelsDW].[dbo].[Fact_Sales]
	ADD CONSTRAINT FK_FactSales_DimDate
	FOREIGN KEY (OrderDateSK) REFERENCES [WonderfulWheelsDW].[dbo].[Dim_Date](DateSK)

GO
	-- Test 
	SELECT * FROM [WonderfulWheelsDW].[dbo].[Fact_Sales]

GO

use WonderfulWheelsDW
go
create view dbo.vwGetEmployeeSales
as
select e.FirstName,e.LastName,e.Email,
(DATEDIFF(year,e.DateofBirth,getdate()))as age,
(DATEDIFF(year,e.HireDate,getdate())) as [YearsOfservice],
e.Commission as [CommissionPercentage],
isnull(cast(f.CommissionAmount as varchar),'')as [SaleCommission],
isnull((c.FirstName + ' ' + c.LastName),'') as [CustomerName],
isnull(c.RegDate,'')as RegistartionDate,
isnull(c.Title,'') as Title,
isnull(d.DealerName,'')as DelarshipName,
isnull(d.StreeAddress,'')as streetaddress,
isnull(d.City,'')as CityName,
isnull(d.Province,'')as ProvinceName,
isnull(v.Make,'')as Make,
isnull(v.Model,'')as Model,
isnull(v.VehicleYear,'')as [MakeYear],
isnull(v.KM,'')as KM,
isnull(cast(v.Price as varchar),'')as Price,
isnull(cast(FinalSalePrice as varchar),'')as FinalSalePrice,
isnull(dt.Year,'') as Year,
isnull(dt.CalendarQuarter,'') as CalendarQuarter,
isnull(dt.Month,'')as Month
from WonderfulWheelsDW.dbo.Dim_CommissionEmployee as e
left join WonderfulWheelsDW.dbo.Fact_Sales as f on e.EmployeeSK =f.EmployeeSK
left join WonderfulWheelsDW.dbo.Dim_Customer as c on c.CustomerSK =f.CustomerSK
left join WonderfulWheelsDW.dbo.Dim_Dealership as d on d.DealershipSK =f.DealershipSK
left join WonderfulWheelsDW.dbo.Dim_Vehicle as v on v.VehicleSK =f.VehicleSK
left join WonderfulWheelsDW.dbo.Dim_Date as dt on dt.DateSK =f.OrderDateSK
go


declare @FirstName varchar(50),
		@LastName Varchar(50),
		@Year int,
		@Month int
			set @FirstName=''
			set @LastName =''
			set @Year = null
			set @Month = null

			select * from dbo.vwGetEmployeeSales
			where(FirstName=@FirstName or @FirstName='')
			and (LastName = @LastName or @LastName='')
			and (Year=@Year or @Year is null)
			and (Month=@Month or @Month is null)
			order by FirstName, LastName
go

-- creating SP 
create procedure dbo.spGetEmployeeSales
(
		@FirstName varchar(50),
		@LastName Varchar(50),
		@Year int,
		@Month int
)
as
begin

Select * from dbo.vwGetEmployeeSales
where(FirstName like '%'+@FirstName+'%' or @FirstName='')
			and (LastName like '%'+@LastName+'%' or @LastName='')
			and (Year=@Year or @Year is null)
			and (Month=@Month or @Month is null)
order by FirstName, LastName
end
go

-- year for drop down list
select distinct null as value,'All' as label, 0 as sortOrder
union
select distinct [year] as value, cast([YEAR] as varchar(4)) as label ,1
from WonderfulWheelsDW.dbo.dim_Date
order by sortOrder,label

-- month for DropDown List
select distinct null as value,'All' as label, 0 as sortOrder
union
select distinct [Month] as value, cast([MONTH] as varchar(2)) as label ,1
from WonderfulWheelsDW.dbo.dim_Date
order by sortOrder,label



EXEC dbo.spGetEmployeeSales @FirstName = '', @LastName = '', @Year=0  , @Month =0;