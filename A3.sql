 <! -- THURSDAY FEB 15TH / TUESDAY FEB 21ST --> 

/* 1. List the members' first and last names, book ISBNs and titles, loan and due dates, and authors' first and last names sorted in descending order of due dates */
select mem_fname , mem_lname , b.bok_isbn , bok_title , lon_loan_date , lon_due_date , aut_fname , aut_lname 
from member m , loaner l , book b , attribution at , author a 
where m.mem_id = l.mem_id 
	and l.bok_isbn=b.bok_isbn 
	and b.bok_isbn=at.bok_isbn
	and at.aut_id=a.aut_id
order by lon_due_date desc; 

-- or
select mem_fname , mem_lname , b.bok_isbn , bok_title , lon_loan_date , lon_due_date , aut_fname , aut_lname 
from member m 
	join loaner l on m.mem_id = l.mem_id
	join book b on l.bok_isbn=b.bok_isbn
	join attribution at on b.bok_isbn=at.bok_isbn
	join author a on at.aut_id=a.aut_id 
order by lon_due_date desc;

--join using 
select mem_fname , mem_lname , b.bok_isbn , bok_title , lon_loan_date , lon_due_date , aut_fname , aut_lname 
from member 
	join loaner using (mem_id)
	join book using (bok_isbn)
	join attribution using (bok_isbn)
	join author using (aut_id)
order by lon_due_date desc;

--natural join 
select mem_fname , mem_lname , b.bok_isbn , bok_title , lon_loan_date , lon_due_date , aut_fname , aut_lname 
from member 
	natural	join loaner
	natural	join book
	natural	join attribution
	natural	join author
order by lon_due_date desc;	


/* 2. List an unstored derived attribute called "book sale price," that displays the current price, which is marked down 15% from the original book price (format the number to two decimal places, and include a dollar sign).*/
-- Step #1 calculate 15% discount and format to two decimal places 
select bok_price, bok_price * .85, format (bok_price * .85,2)
from book;

-- Step #2 add dollar ($), and alias
select concat('$',format(bok_price * .85,2)) as book_sale_price
from book;

-- alias ( with space ): back ticks
select concat('$',format(bok_price * .85,2)) as 'book sale price'
from book; 


/* 3. Create a stored derived attribute based upon the calculation above for the second book in the book table, and place the results in member #3's notes attribute. */
select * from member; 

--Step #1 
select bok_price, bok_price * .85 
from book 
where bok_isbn='1234567890123'

--Step #2
select concat ('Purchased book at discounted price:' , '$', format(bok_price * .85,2))
from book 
where bok_isbn='1234567890123'

--Step #3
select * from member
set mem_notes = 
(
	select concat ('Purchased book at discounted price:' , '$', format(bok_price * .85,2))
	from book 
	where bok_isbn='1234567890123'
)
where mem_id = 3; 

select * from member; 

--an update that modifies two attributes
update member
set mem_notes = 

/* 4. Using only SQL, add a test table inside of your database with the following attribute definitions. */
--a. create test table 
show tables 
drop table if exist test; 
CREATE TABLE if not exists test 
( 
	tst_id unsigned NOT NULL AUTO_INCREMENT 
	tst_fname varchar(15) NOT NULL 
	tst_lname varchar(30) NOT NULL 
	tst_street varchar(30) NOT NULL 
	tst_city varchar(30) NOT NULL 
	tst_state char(2) NOT NULL DEFAULT 'FL',
	tst_zip int unsigned NOT NULL,
	tst_phone bigint unsigned NOT NULL COMMENT 'otherwise , cannot make contact', 
	tst_email varchar(100) DEFAULT NULL, 
	tst_notes varchar(255) DEFAULT NULL, 
	PRIMARY KEY (tst_id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_general_ci;

/* 5. Insert data into test table from member table  */

select * from test; 

insert into test 
( tst_id , tst_fname , tst_lname , tst_street , tst_city , tst_state , tst_zip , tst_phone , tst_email , tst_notes )
select mem_id , mem_fname , mem_lname , mem_street , mem_city , mem_state , mem_zip , mem_phone , mem_email , mem_notes 
from member; 

select * from test; 

-- also 
select * from test limit 5; 
select * from member limit 5; 


/* 6. Alter the last name attribute in test table to the following options  */

Alter table table_name CHANGE old_att_name new_att_name datatype (length) any additional options 

show create table test; 
show full columnss from test; 

describe test; 
alter table test change tst_lname tst_last varchar(35) not null DEFAULT 'Doe' COMMENT 'testing'
describe test; 

show create table test; 
show full columnss from test; 

--List the publishers' names and address , book titles , publication dates , page numbers and category types , sorted in ascending order of category types , displaying only the frist 3 records. 

-- Extra Credit
select pub_name , pub _street , pub _ city , pub_state , pub _ zip , bok_title , bok_pub_
from publisher p 
	join book b on pub.pub_id = b.pub_id 
	join book 
