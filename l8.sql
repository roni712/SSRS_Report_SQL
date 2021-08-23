
create view dbo.vmGetEmployeeSales
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


use WonderfulWheelsDW
go
declare @FirstName varchar(50),
		@LastName Varchar(50),
		@Year int,
		@Month int
			set @FirstName=''
			set @LastName =''
			set @Year = null
			set @Month = null

			select * from dbo.vmGetEmployeeSales
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

Select * from dbo.vmGetEmployeeSales
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

