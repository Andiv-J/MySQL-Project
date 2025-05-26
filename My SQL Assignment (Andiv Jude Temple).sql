create database classicmodels;
use classicmodels;

###=============================================================================================================================================================================

## Q1. SELECT clause with WHERE, AND, DISTINCT, Wild Card (LIKE)

## ANSWER (1.a) -

Select * from employees;

select employeeNumber, firstName, lastName from employees where reportsTo = 1102;

#--------------------------------------------------------------------------------------------------------------------

## ANSWER (1.b) -

Select * from products;

select distinct productLine from products
where productLine like '%Cars';

###==============================================================================================================================================================================

## Q2.CASE STATEMENTS for Segmentation

## ANSWER (2.a) -

Select * from customers;

select customerNumber, customerName,
case when country = "USA" or "Canada" Then "North America"
when country = "UK" or "France" or "Germany" Then "Europe" 
else "Other"
end as customerSegment
from customers;

###=============================================================================================================================================================================

## Q3.Group By with Aggregation functions and Having clause, Date and Time functions -

## ANSWER (3.a) -

select * from orderdetails;

select productCode, sum(quantityOrdered)total_ordered from orderdetails
group by 1 order by 2 desc
limit 10;

#------------------------------------------------------------------------------------------------------------

## ANSWER (3.b) -

select * from payments;

select date_format(paymentDate,'%M')payment_month, 
count(customerNumber)num_payments from payments
group by 1
having num_payments > 20
order by 2 desc;

###============================================================================================================================================================================

## Q4.CONSTRAINTS: Primary, key, foreign key, Unique, check, not null, default -

create database Customers_Orders;
use Customers_Orders;

## ANSWER (4.a) -

create table Customers(
customer_id int primary key auto_increment, 
first_name varchar(50) not null, 
last_name varchar(50) not null,
email varchar(255) unique,
phone_number varchar(20));

#------------------------------------------------------------------------------------------

## ANSWER (4.b) -

create table Orders(
order_id int primary key auto_increment,
customer_id int references Customers(customer_id),
order_date date,
total_amount decimal(10,2) check(total_amount>=0));

###=====================================================================================================================================

## Q5. JOINS - 

## ANSWER (5.a) -

use classicmodels;

select * from customers;
select * from orders;

select customers.country,count(orders.customernumber) as order_count
from orders inner join customers
on orders.customernumber=customers.customernumber
group by 1
order by 2 desc
limit 5;

###=====================================================================================================================================

## Q6.SELF JOIN -

## ANSWER (6.a) -

create table project(
EmployeeID int primary key auto_increment,
FullName varchar(50) not null,
Gender enum('Male','Female'),
ManagerID int);

insert into project values
(1,"Pranaya","Male",3),
(2,"Priyanka","Female",1),
(3,"Preety","Female",null),
(4,"Anurag","Male",1),
(5,"Sambit","Male",1),
(6,"Rajesh","Male",3),
(7,"Hina","Female",3);

#Find out the names of employees and their related managers. 

select * from project;

select a.FullName as "Manager Name", b.FullName as "Emp Name" from 
project as a inner join project as b
on b.managerid=a.employeeid;

###=====================================================================================================================================

## Q7. DDL Commands: Create, Alter, Rename -

## ANSWER (7.a) -

Create table facility(Facility_ID int, Name varchar(30), State varchar(30), Country varchar(30));

select * from facility;

alter table facility 
modify Facility_ID int primary key auto_increment;

alter table facility
add column city varchar(30) not null after Name;

describe facility;
#------------------------------------------------------------------------------------------------------------
drop table facility;
#------------------------------------------------------------------------------------------------------------
Create table facility(Facility_ID int, Name varchar(100), State varchar(100), Country varchar(100));

select * from facility;

alter table facility 
modify Facility_ID int primary key auto_increment;

alter table facility
add column City varchar(100) not null after Name;

describe facility;

###=====================================================================================================================================

## Q8.Views in SQL

## ANSWER (8.a) -

select * from Products;
select * from orders;
select * from orderdetails;
select * from productLines;

create view product_category_sales as
select products.productLine, 
sum(orderdetails.quantityordered*orderdetails.priceeach)total_sales,
count(distinct orders.ordernumber)number_of_orders 
from ((orderdetails
inner join products on orderdetails.productcode=products.productcode)
inner join orders on orderdetails.ordernumber=orders.ordernumber)
group by 1;

select * from product_category_sales;

###============================================================================================================================================================================
use classicmodels;
##=============================================================================================================================================================================

## Q9.Stored Procedures in SQL with parameters - 

## ANSWER (9.a) -

Call Get_country_payments(2003, 'france');

###============================================================================================================================================================================

## Q10.Window functions - Rank, dense_rank, lead and lag -

## ANSWER (10.a) -

select * from customers;
select * from orders;

select customerName,count(orders.customernumber)Order_count,
dense_rank() over (order by count(orders.customernumber) desc)order_frequency_rnk
from customers inner join orders 
on customers.customernumber=orders.customernumber
group by orders.customernumber
having order_count>3
order by order_frequency_rnk;

#-------------------------------------------------------------------------------------------------

## ANSWER (10.b) -

select * from orders;

WITH YearMonthTotalOrders AS (
SELECT YEAR(orderDate)Year,MONTHNAME(orderDate)Month, MONTH(orderDate)MonthNumber,COUNT(orderNumber)TotalOrders
FROM orders GROUP BY 1, 2, 3),
YoYCalculation AS (
SELECT Year,Month,MonthNumber,TotalOrders,
LAG(TotalOrders, 1) OVER (ORDER BY Year) AS PreviousYearTotalOrders FROM YearMonthTotalOrders)
SELECT Year,Month,TotalOrders,
CASE WHEN PreviousYearTotalOrders IS NULL THEN 'N/A'
ELSE CONCAT(format((TotalOrders - PreviousYearTotalOrders) * 100.0 / PreviousYearTotalOrders, 0), '%')
END AS YOYChange
FROM YoYCalculation
ORDER BY 1, 3;

###============================================================================================================================================================================

## Q11.Subqueries and their applications

## ANSWER (11. a) -

Select * from products;

select productLine, count(buyPrice)Total from products
where buyPrice>(select avg(buyPrice) from products)
group by 1 order by 2 desc;

###============================================================================================================================================================================

## Q12.ERROR HANDLING in SQL

create table Emp_EH(EmpID int primary key, EmpName varchar(100), EmailAddress varchar(100));

call Error_Table_Emp_EH(1, 'Rahul', 'rahulraj@gmail.com');
call Error_Table_Emp_EH(2, 'Ajay', 'ajayraj@gmail.com');
call Error_Table_Emp_EH(3, 'Ajay', 'ajayraj21@gmail.com');

###============================================================================================================================================================================

## Q13.TRIGGERS - 

create table Emp_BIT(Name varchar(50),Occupation varchar(50), Working_date date, Working_hours int);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

insert into Emp_BIT values('Salman', 'Business', '2020-10-05', -18);

select * from Emp_BIT;


###############################################################################################################################################################################