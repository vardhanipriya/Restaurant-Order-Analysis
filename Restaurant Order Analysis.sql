/*Restaurant Order Analysis
View the menu_items table and write a query to find the number of items on the menu*/

select * from menu_items;
select distinct count(item_name) from menu_items;

/*What are the least and most expensive items on the menu?*/
select min(price) from menu_items;
select max(price) from menu_items;
/* most expensive item*/
select item_name,price 
from menu_items 
order by price 
desc limit 1;

/* least expensive item*/
select item_name,price 
from menu_items 
order by price asc 
limit 1;

/*How many Italian dishes are on the menu? 
What are the least and most expensive Italian dishes on the menu?*/

select distinct count(item_name) as italian_dishes_on_the_menu 
from menu_items
where category = 'Italian';

/* most expensive italian item*/
select item_name,price from menu_items 
where category = 'Italian'
order by price desc limit 1;

/* least expensive italan item*/
select item_name,price from menu_items 
where category = 'Italian'
order by price asc limit 1;

/*How many dishes are in each category? 
What is the average dish price within each category?*/

select category, count(menu_item_id) 
from menu_items
group by category;

select category, avg(price)
from menu_items
group by category;

/*View the order_details table. What is the date range of the table?*/

select * from order_details;
select min(order_date) , max(order_date)
from order_details;

/*How many orders were made within this date range?2023-01-01 and 2023-03-31 
How many items were ordered within this date range?*/

select count(distinct order_id)
from order_details
where order_date between '2023-01-01' and '2023-03-31' ; 

select count(distinct order_details_id)
from order_details
where order_date between '2023-01-01' and '2023-03-31' ; 

select item_id, count(order_details_id) as c
from order_details
group by item_id;

select sum(tab.c)
from (select item_id, count(order_details_id) as c
from order_details
group by item_id )as tab ;

/*Which orders had the most number of items?*/

select order_id, count(item_id)
from order_details
group by order_id
having count(item_id) >=(select distinct count(order_details_id) 
from order_details
group by order_id
order by 1 desc
limit 1)
order by 2 desc
;
/*How many orders had more than 12 items?*/
select count(*) as orders_morethan_12_items
from 
(select order_id, count(item_id)
from order_details
group by order_id
having count(item_id) >12
order by 2 desc) as num_orders
;

/*Combine the menu_items and order_details tables into a single table*/

select * 
from order_details
left join menu_items
on order_details.item_id= menu_items.menu_item_id;

/*What were the least and most ordered items? What categories were they in?*/

select menu_items.item_name, count(order_details.order_details_id)
from order_details
left join menu_items
on order_details.item_id= menu_items.menu_item_id
group by menu_items.item_name
order by 2
limit 1 ;

select menu_items.item_name, count(order_details.order_details_id)
from order_details
left join menu_items
on order_details.item_id= menu_items.menu_item_id
group by menu_items.item_name
order by 2 desc
limit 1 ;

/*What were the top 5 orders that spent the most money?*/

select order_details.order_id, sum(menu_items.price)
from order_details
left join menu_items
on order_details.item_id= menu_items.menu_item_id
group by 1
order by 2 desc
limit 5;

/*View the details of the highest spend order. Which specific items were purchased?*/
/*highest spend order*/
select order_details.order_id
from order_details
left join menu_items
on order_details.item_id= menu_items.menu_item_id
group by 1
order by sum(menu_items.price) desc
limit 1;

select * 
from order_details
where order_id = (select order_details.order_id
from order_details
left join menu_items
on order_details.item_id= menu_items.menu_item_id
group by 1
order by sum(menu_items.price) desc
limit 1);
/*Which specific items were purchased?*/
select  order_details.order_id,menu_items.item_name
from order_details
left join menu_items
on order_details.item_id= menu_items.menu_item_id
where order_id = (select order_details.order_id
from order_details
left join menu_items
on order_details.item_id= menu_items.menu_item_id
group by 1
order by sum(menu_items.price) desc
limit 1);

/*View the details of the top 5 highest spent orders*/
create temporary table
top_5_highest_spent_orders as 
select order_details.order_id
from order_details
left join menu_items
on order_details.item_id= menu_items.menu_item_id
group by 1
order by sum(menu_items.price) desc
limit 5;

select * from top_5_highest_spent_orders;

create temporary table 
detailed_orders as 
select * 
from order_details
left join menu_items
on order_details.item_id= menu_items.menu_item_id;

select * from detailed_orders;

select detailed_orders.order_id,detailed_orders.category,count(detailed_orders.item_id)
from detailed_orders
inner join top_5_highest_spent_orders
on top_5_highest_spent_orders.order_id = detailed_orders.order_id
group by 1,2;
