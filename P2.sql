 <! -- THURSSDAY APR 20th --> 

--> >>>>>>>>>>>>>>>>>>>>>>>>>>>>> P2 Reports <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
-- MS SQL Server Solutions (remember , can't use Natural Join or Join Using 

-- a
use amd14b; 
go 

begin transaction; 
	select pat_fname , pat_lname , pat_notes , med_name , med_price , med_shelf_life , pre_dosage , pre_num_refills
	from medication m 
	join prescription pr on pr.med_id = m.med_id
	join patient p on pr.pat_id = p.pat_id
	order by med_price desc; 
commit; 
 



-- b
-- old - style join 
IF OBJECT_ID (N'dbo.v_physician_patient_treatments',N'V') IS NOT NULL
drop view if exists v_physician_patient_treatments; 
GO 

create view dbo.v_physician_patient_treatments as 
	select phy_fname , phy_lname , trt_name , trt_price , ptr_results , ptr_date , ptr_start , ptr_end
	from physician p, patient_treatment pt , treatment t
	where p.phy_id=pt.phy_id
	and pt.trt_id=t.rt_id; 
go   

select * from dbo.v_physician_patient_treatments order by trt_price desc;
go



-- c 
IF OBJECT_ID ('AddRecord') IS NOT NULL
DROP PROCEDURE AddRecord; 
go

CREATE PROCEDURE AddRecord AS 
	insert into dbo.patient_treatment
	(pat_id, phy_id, trt_id, ptr_date, ptr_start, ptr_end, ptr_results, ptr_notes )
	values (5,5,5, '2013-04-23','11:00:00', '12:30:00', 'released', 'ok');
select * from dbo.v_physician_patient_treatments; 
go

EXEC AddRecord;



--d 
begin transaction; 
	select * from dbo.administration_lu; 
	delete from dbo.administration_lu where pre_id = 5 and ptr_id = 10;
	select * from dbo.administration_lu; 
commit



--e 
use amd14b; 

IF OBJECT_ID('dbo.UpdatePatient') IS NOT NULL 
	DROP PROCEDURE dbo.UpdatePatient as 

select * from dbo.patient; 
update dbo.patient
set pat_lname = 'Vanderbilt'
where pat_id = 3; 

select * from dbo.patient;
go 

EXEC dbo.UpdatePatient; 
go 



--f 
EXEC sp_help 'dbo.patient_treatment';
ALTER TABLE dbo.patient_treatment add ptr_prognosis varchar(255) NULL default 'testing'; 
EXEC sp_help 'dbo.patient_treatment';




-- extra credit
CREATE PROCEDURE dbo.AddShowRecords AS 

-- check data before / after 
select * from dbo.patient

insert into dbo.patient
( pat_ssn , pat_fname, pat_lname, pat_street, pat_city, pat_state , pat_zip, pat_phone, pat_email, pat_dob, pat_gender, pat_notes)
values ( 756889432 , 'John' , 'Doe', '123 Main Street', 'Tallahassee', 'FL', '323405', '8507863241', 'jdoe@fsu.edu', '1999-05-10','M', 'testing notes');

-- check data before/after
select * from dbo.patient;

select phy_fname , phy_lname , pat_fname , pat_lname , trt_name , ptr_start , ptr_end , ptr_date
from dbo.patient p 
	join dbo.patient_treatment pt on p.pat_id=pt.pat_id
	join dbo.physician pn on pn.phy_id=pt.phy_id 
	join dbo.treatment t on t.trt_id=pt.trt_id 
order by ptr_date desc; 

EXEC dbo.AddShowRecords
go