<!-- Practice --> 

/*  Show hidden files and folders , Show file extensions */

<! -- TUESDAY JAN 17TH --> 

/* List the customer number , last name , first name , and balance of every customer */
select customer_number as cus_num , last , first , balance as bal 
from customer; 

/* not using " as " keyword */ 
select customer_number cus_num, last , first , balance bal 
from customer; 

/* Same query as above , sort by balance in descending order , and last name in ascending */
select customer_number , last , first , balance
from customer
order by balance desc , last asc; 

/* List the complete PART table */ 
select * 
from part; 

/* What is the name of customer numnber 124 */ 
select last , first 
from customer
where customer_number = '124'; 

/* Find the customer number for every customer whose last name is Adams */ 
select customer_number
from customer 
where last = 'Adams'; 

/* Find the customer number , last name , first name and current balance for every customer whose balance exceeds the credit limit */ 
select customer_number , last , first , balance , credit_limit 
from customer
where balance > credit_limit; 

/* List the description of every part that is in warehouse number 3 and has ore than 100 units on hand */ 
select part_description 
from part 
where warehouse_number = '3'; 
and units_on_hand > 100; 

/* List the order line number, part number, number ordered, and quoted price from the ORDER_LINE table in ascending order by quoted price.*/
select customer_number , last , first , balance
from customer
order by balance desc , last asc; 

/* Modify the city, state, and zip code of sales rep number 06. */
update sales_rep 
set city = 'Atlanta' , state = 'GA', zip_code = '30301'
where slsrep_number = '06'; /* Don't forget to add this , Never envoke an update statement w/o a where clause  */ 


/* Add two records to the part table. */ 
select * from part; 

/* Version 1 */
INSERT INTO part (part_number , part_description , units_on_hand, item_class, warehouse_number, unit_price)
VALUES 
('yyy','Widget1','3','AD',1,7.50);
('aaa','Widget2','6','AA',2,9.50);

select * from part; 

INSERT INTO part 
VALUES 
('yyy','Widget1','3','AD',1,7.50);
('aaa','Widget2','6','AA',2,9.50);


<! -- THURSDAY JAN 19TH --> 
/* List the description of every part that is in warehouse number 3 or has more than 100 units on hand*/ 
select part_description
from part
where warehouse_number = '3'
or units_on_hand > 100; 


/* List the description of every part that is not in warehouse number 3*/ 
select part_description
from part 
where warehouse_number != 3; 

/*List the customer number , last name , first name and balance for every customer whose balance is between $500 and $1000 */
select customer_number , last , first, balance
from customer
where balance > = 500 and balance < = 1000; 

/*Find the customer number , last name , first name and available credit for every customer who has a credit limit of at least $1,500*/
select customer_number , last , first, ( credit_limit - balance ) as AVAILABLE_CREDIT
from customer
where credit_limit >= 1500; 

/* List the order line number, part number, number ordered, and quoted price from the ORDER_LINE table in ascending order by quoted price. */
select order_number , part_number , number_ordered , quoted_price
from order_line
order by quoted_price asc; 


<! -- TUESDAY JAN 24TH --> 
/*Find the customer number , last name , first name and available credit for every customer who has at least $1000 of available credit*/
select customer_number , last , first, ( credit_limit - balance ) as AVAILABLE_CREDIT
from customer
where ( credit_limit - balance ) >= 1000;

/*List the customer number , last name , first name and complete address of every customer who lives on Pine ; that is , whose address contains the letters 'Pine'*/
select customer_number , last , first , street , city , state , zip_code
from customer
where street like '%Pine%'; 

/* List the customer number , last name , and first name for every customer with a credit limit of $1,000 , $1,500, or $2,000 */ 
select customer_number, last , first , credit_limit
from customer
where credit_limit IN ( 1000 , 1500 , 2000 )
