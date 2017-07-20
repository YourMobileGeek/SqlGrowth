<!-- Practice --> 

<! -- TUESDAY FEB 7TH --> 

/* List all faculty members’ first and last names, full addresses, salaries, and hire dates. */

<! -- old style join --> 
select p.per_id , per_fname , per_lname , per_street , per_city , per_state , emp_salary , fac_start_date 
from person as p , employee as e , faculty as f
where p.per_id = e.per_id
  and e.per_id = f.per_id; 

<! -- join on --> 
select p.per_id , per_fname , per_lname , per_street , per_city , per_state , emp_salary , fac_start_date 
from person as p 
 join employee e on p.per_id = e.per_id
 join faculty f on e.per_id = f.per_id; 

<! -- join using --> 
select p.per_id , per_fname , per_lname , per_street , per_city , per_state , emp_salary , fac_start_date 
from person as p 
 join employee using (per_id)
 join faculty using (per_id);

<!-- natural join --> 
select p.per_id , per_fname , per_lname , per_street , per_city , per_state , emp_salary , fac_start_date 
from person p 
natural join employee
natural join faculty; 

<!-- Possibilities -->
/*a - incorrect , b - incorrect , c - good , d - good , e - incorrect , f - incorrect */


/* List the first 10 alumni’s names, genders, date of births, degree types, areas, and dates. */
select p.per_id , per_fname , per_lname , per_gender , per_dob , deg_type , deg _ area , deg_date 
from person p , alumnus a , degree d 
where p.per_id = a.per_id
 and a.per_id = d.per_id
limit 0, 10; 


/* List the last 20 undergraduate names, majors, tests, scores, and standings.  */
select p.per_id , per_fname , per_lname , stu_major , ugd_test , ugd _score , ugd_standing 
from person p , student s , undergrad u 
where p.per_id = s.per_id
 and s.per_id = u.per_id
order by per_id desc 
limit 0,20


/* Remove the first 10 staff members; after which, display the remaining staff members’ names and positions.  */
select * from staff; 

delete by per_id limit 10; 

select  * from staff; 


/* Update one graduate student’s test score (only one score) by 10%. Display the before and after values to verify that it was updated.  */
select * from grad;

update grad
set grd_score = grd_score * 1.10 
where per_id = 75 and grd_test='gmat'; 


/* Add two new alumni, using only one SQL statement (include attributes). Then, verify that two records have been added.  */
select * from alumnus; 

insert into alumnus (per_id , alm_notes)
values ( 97, "testing 1"), (98, "testing 2"); 

select * from alumnus;

insert into alumnus
values (99,"testing 1"),
(100 , "testing 2");
