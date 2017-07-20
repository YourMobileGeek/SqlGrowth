 <! -- THURSDAY MAR 30th --> 

/* 5a. Create a view that only dsiplays users' ids, first and last names, phone numbers and email address, sort in ascending order bu user last name ( name it v_user_info): */
drop view if exists v_user_info; 
create view v_user_info as 
	select usr_id, usr_fname, usr_lname, 
	CONCAT('(',substring(usr_phone,1,3), ')', substring(usr_phone,4,3), '-', substring(usr_phone,7,4)) as usr_phone, 
	usr_email 
	from user
	order by usr_lname asc; 


/* 5b. Create a view that only displays */
drop view if exists v_institution_info; 
create view v_institution_info as 
	select ins_name 
	CONCAT(ins_street,",", ins_city, ",", ins_state, ",", substring(ins_zip,1,5), '-' substring(ins_zip,6,4)) as address, 
	CONCAT('(',substring(ins_phone,1,3), ')', substring(ins_phone,4,3), '-', substring(ins_phone,7,4)) as ins_phone,
	ins_email, ins_url
	from instiution
	order by ins_name asc;


/* 5c. Create a view that only displays *unique* category types used (i.e., in transactions), not all of the category types available (name it v_category_types): */ 
drop view if exists v_category_types; 
create view v_category_types as 
select distinct cat_id , cat_type 
from transaction
	natural join category; 

select * from v_category_types;


/* 5d. Create a stored procedure that accepts a user’s id, and displays a user’s name, the institution names, and the account types to which that user is associated, sort in  descending order by account type. (name it UserInstitutionAccountInfo): */ 
DROP PROCEDURE IF EXISTS UserInstitutionAccountInfo; 
DELIMITER // 
CREATE PROCEDURE UserInstitutionAccountInfo (IN usrid INT)
BEGIN 
	select usr_fname, usr_lname, ins_name, act_type
	from user u 
		join source s on u.usr_id=s.usr_id 
		join instiution i on s.ins_id=i.ins_id
		join account a on s.act_id=a.act_id
		where u.usr_id = usrid
	order by act_type desc; 
END //
DELIMITER;


/* 5e. Create a stored procedure that only displays users' names, account types, and
transactions for each account (include transaction type, method, amount, and
date/time), (include date/time under one header) for each user, sort in descending
order by user last name, ascending order of amount
(name it UserAccountTransactionInfo): */
DROP PROCEDURE IF EXISTS UserInstitutionAccountInfo; 
DELIMITER // 
CREATE PROCEDURE UserInstitutionAccountInfo ()
BEGIN 

	select usr_fname, usr_lname, act_type, trn_type, trn_method,
	CONCAT('$',FORMAT(trn_amt,2)) as trn_amount,
	DATE_FORMAT(trm_date,'%c%/%e/%y %r') trn_timestamp,
	trn_notes 
	from user 
		natural join source 
		natural join transaction
		natural join account
	order by usr_lname desc, trn_amt; 
END//

CALL UserInstitutionAccountInfo();

DROP PROCEDURE IF EXISTS UserInstitutionAccountInfo;

/* 5f. Create a view that only displays users' names and total of all debits, for each user,
sort in descending order by total debits (name it v_user_debits_info): */
drop view if exists v_user_debits_info; 
create view v_user_debits_info as 
	select usr_fname, usr_lname, act_type, trn_type, concat('$',format(trn_amt,2)) as debit_amt
	from user 
		natural join source
		natural join transaction
	where trn_type='debit'
	group by usr_id
	order by sum(trn_amt) desc;
	

/* 5g. Create a transaction that inserts a record in the transaction table, updates it, and
then removes it. */ 
select * from transaction; 

insert into transaction
(trn_id , src_id, cat_id, trn_type, trn_method, trn_amt, trn_date, trn_notes)
VALUES 
(NULL,2,1,'credit','auto',2235.09,'2002-01-07 11:59:59',NULL)

select * from transaction; 

select @tid := max(trn_id) from transaction; 

update transaction
set trn_notes='transaction has been updated'
where trn_id = @tid; 

select * from transaction; 

delete from transaction
where trn_id = @tid;

select * from transaction; 


/* Extra Credit */ 
drop view if exists v_finance_info; 
create view v_finance_info as 
	select usr_fname, usr_lname, 
CONCAT('(', substring(usr_phone,1,3), ')', substring(usr_phone,4,3),'-', substring(usr_phone,7,4)) as usr_phone, 
ins_name, 
CONCAT('(', substring(usr_phone,1,3), ')', substring(usr_phone,4,3),'-', substring(usr_phone,7,4)) as ins_phone, 
ins_contact,act_type
DATE_FORMAT(src_start_date, '%c%/%e/%y') act_start_date, 
trn_id, trn_type, trn_method, 
CONCAT('$',FORMAT(trn_amt, 2)) as trn_amount,
DATE_FORMAT(trn_date, '%c%/%e/%y %r') trn_timestamp,
cat_type,
trn_notes
from user 
	natural join source 
	natural join institution
	natural join category
	natural join account
order by usr_lname asc;

select * from v_finance_info; 


