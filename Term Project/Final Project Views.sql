/* Final Project Views 

go
create view order_limited_view 
as
Select [Name]
from Customer 
join Orders on Customer.CustomerID = Orders.CustomerID
with check option;

create view Quantity_view
as
select Product
from Inventory
join OrderDetail on Inventory.ProductID = OrderDetail.ProductID
where Quantity > 1

create view ranking_view
as
select [Name]
from Customer
join CustomerRanking on Customer.CustomerID = CustomerRanking.CustomerID
where CustomerRanking = 1

Use TermProject;
go
create view order_view 
as
Select Inventory.Product, Inventory.Price, OrderDetail.Quantity
from Inventory , OrderDetail;



update order_view
set Product = 'Good'
where Quantity > 1;*/