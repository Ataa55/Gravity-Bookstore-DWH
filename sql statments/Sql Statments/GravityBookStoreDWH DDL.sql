create table Dim_Book(
book_id_sk int primary key identity,
book_id_bk int,
title nvarchar(400),
num_pages int,
publication_date datetime, 
publisher_name nvarchar(400),
author_name nvarchar(400),
language_code nvarchar(8),
language_name nvarchar(50),
valid_from datetime,
valid_to datetime
);
create table Dim_customer(
customer_sk int primary key identity,
customer_bk int,
first_name nvarchar(200),
last_name nvarchar(200),
email nvarchar(30),
address_status varchar(30),
country_name varchar(200),
street_number varchar(10),
street_name nvarchar(200),
city nvarchar(100),
valid_from datetime,
valid_to datetime
);

CREATE TABLE [dbo].[Dim_Date](
	[Date_SK] [int] primary key NOT NULL,
	[Day] [varchar](10) NOT NULL,
	[Month] [varchar](10) NOT NULL,
	[Quarter] [varchar](10) NOT NULL,
	[Year] [int] NOT NULL,
	[CDate] [datetime] NOT NULL
);
CREATE PROCEDURE [dbo].[D_Time_Populate] @NextDays Int = 0
AS
Begin
	DECLARE @DateDifference	INT;
	DECLARE @Counter	INT;
	DECLARE @Day		VARCHAR(10);
	DECLARE @Month		VARCHAR(10);
	DECLARE @Quarter	VARCHAR(10);
	DECLARE @Year		INT;
	DECLARE @Date_SK	INT;
	DECLARE @CDate		DateTime;
	DECLARE @CompanyStartDate Date;
	
	If @NextDays < 1
	Begin
		SET @NextDays = 0;
	End
	SET @CDate = DATEADD(DAY, @NextDays, GetDate());
	SET @CompanyStartDate = '2005-04-12';	-- Change this date as per your requirement.
	Set @DateDifference = DATEDIFF(Day, @CompanyStartDate, @CDate);
	Set @Counter = 0;
	
	Truncate Table Dim_Date;
	
	Insert Into Dim_Date (Date_SK, Day, Month, Quarter, Year, CDate)
	Values (19000101, 1, 'Jan 1900', 'Q1 1900', 1900, '1900-01-01 00:00:00.000');
	
	While @Counter <= @DateDifference
	Begin
		SET @CDate = DATEADD(Day, @Counter, '2005-04-12');
		SET @Year = DATEPART("YYYY", @CDate);
		SET @Quarter = 'Q'+Cast(DATEPART("QQ", @CDate) As VARCHAR)+' '+CAST(@Year AS VARCHAR);
		SET @Month = LEFT(DATENAME("MM", @CDate), 3)+' '+CAST(@Year AS VARCHAR);
		SET @Day = CAST(DATEPART("DD", @CDate) AS VARCHAR)+' '+LEFT(DATENAME("MM", @CDate), 3);
		SET @Date_SK = CONVERT(VARCHAR(8), @CDate, 112);
		
		Insert Into Dim_Date (Date_SK, Day, Month, Quarter, Year, CDate)
		Values (@Date_SK, @Day, @Month, @Quarter, @Year, @CDate);

		Set @Counter = @Counter + 1;
	End
End

D_Time_Populate

create table fact_order(
book_id_sk int,
customer_sk int,
Date_SK int,
total_price int,
total_shipping int,
total_amount int, 
CONSTRAINT fk_book FOREIGN KEY (book_id_sk) REFERENCES Dim_Book (book_id_sk),
CONSTRAINT fk_customer FOREIGN KEY (customer_sk) REFERENCES Dim_customer (customer_sk),
CONSTRAINT fk_date FOREIGN KEY (Date_SK) REFERENCES Dim_Date (Date_SK)
);