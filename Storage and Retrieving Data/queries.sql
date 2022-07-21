-- 1) List all the customer’s names, dates, and products 
-- or services used/booked/rented/bought by
-- these customers in a range of two dates.

select c.client_name as `Client`, 
date(o.date_order) as `Date`, b.title as Book			        				      			
from `client` c
join orders o on c.account_id=o.account_id
join order_itens i on i.order_id = o.order_id
join book b on b.isbn=i.isbn
where o.date_order between '2021-01-01' and '2021-12-31';

-- ---------------------------------------------------------------

-- 2) List the best three customers/products/services/places 
-- (you are free to define the criteria for
-- what means “best”)

-- Here best means the customers who spent the most

select c.client_name as `Client`,
round(sum(i.quantity*((1-b.discount)*b.price)*(1-c.extra_discount)),2) AS Total_Spent
from `client` c
join orders o on c.account_id=o.account_id
join order_itens i on i.order_id=o.order_id
join book b on b.isbn=i.isbn
group by `Client`
order by Total_Spent desc
limit 3;

-- Here best means the books with better rating

select b.title AS Book, 
round(avg(co.rating),1) AS Rating
FROM book b
join commentary co on b.isbn=co.book_isbn
join `client` c on c.account_id=co.account_id
group by Book
order by Rating desc
limit 3;

-- ---------------------------------------------------------------

-- 3) Get the average amount of sales/bookings/rents/deliveries
-- for a period that involves 2 or more
-- years, as in the following example.

select '01/01/2010 - 12/12/2021' as PeriodOfSales,
concat(round(sum(y.total_sales),2),'€') as TotalSales,
concat(round(avg(y.average_sales),2),'€') as YearlyAverage, 
concat(round(avg(m.average_sales),2),'€') as MonthlyAverage
from (select sum(y1.sales) as total_sales, avg(y1.sales) as average_sales
	from (
			select sum(i.quantity*((1-b.discount)*b.price)*(1-c.extra_discount)) as sales
							from  `client` c 
							join orders o on c.account_id=o.account_id
							join order_itens i on i.order_id=o.order_id
							join book b on b.isbn=i.isbn
							where o.date_order between '2010-01-01' and '2021-12-12'
							group by year(o.date_order)) y1
		  ) y,
		 (
			select avg(m1.sales) as average_sales from 
							(select sum(i.quantity*((1-b.discount)*b.price)*(1-c.extra_discount)) as sales
							from  `client` c 
							join orders o on c.account_id=o.account_id
							join order_itens i on i.order_id=o.order_id
							join book b on b.isbn=i.isbn
							where o.date_order between '2010-01-01' and '2021-12-12'
							group by month(o.date_order)) m1
		   ) m;
	
-- ---------------------------------------------------------------

-- 4) Get the total sales/bookings/rents/deliveries by 
-- geographical location (city/country).

-- Total sales by geographical location

select l.country as Country, l.city as City,
round(sum(i.quantity*((1-b.discount)*b.price)*(1-c.extra_discount)),2) as Total_Sales
from location l
join `client` c on c.zipcode=l.zipcode
join orders o on o.account_id=c.account_id
join order_itens i on i.order_id=o.order_id
join book b on b.isbn=i.isbn
group by l.country, l.city;

-- Total deliveries/orders by geographical location

select l.country as Country, l.city as City, count(o.order_id) as Total_Deliveries
from location l
join `client` c on c.zipcode=l.zipcode
join orders o on o.account_id=c.account_id
group by l.city, l.country;

-- ---------------------------------------------------------------

-- 5) List all the locations where products/services 
-- were sold, and the product has customer’s ratings
-- (Yes, your ERD must consider that customers can give ratings).

select distinct(CONCAT(l.city, ', ', l.country)) as Location
from location l
join client c on c.zipcode=l.zipcode
join orders o on o.account_id=c.account_id
join order_itens i on i.order_id=o.order_id
join book b on b.isbn=i.isbn
join commentary co on b.isbn=co.book_isbn;

-- ---------------------------------------------------------------
