--A4 practice 
--avoids error that user kept db connection open 
use master; 
GO

--drop existing database if it exists (use *your* username ) 
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'amd14b')
DROP DATABASE amd14b;
GO 

--create database if not exists (use *your* username)   
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'amd14b')
CREATE DATABASE amd14b; 
GO 

use amd14b;
GO 

--drop table if exists 
--N=subsequent string may be in Unicode (makes it portable to use with Unicode characters)
--U-only look for objects with this name that are tables 
--*be sure* to use dbo. before *all* table references 
IF OBJECT_ID (N'dbo.slsrep',N'U') IS NOT NULL 
DROP TABLE dbo.slsrep; 
GO

--create table (can't use unsigned) 
CREATE TABLE dbo.slsrep 
( 
	srp_id SMALLINT not null identity(1,1),
	srp_fname VARCHAR(15) NOT NULL,
	srp_lname VARCHAR(30) NOT NULL,
	srp_sex CHAR(1) NOT NULL CHECK (srp_sex IN('m','f')),
	srp_age TINYINT NOT NULL check (srp_age >= 18 and srp_age <= 70), 
	srp_street VARCHAR(30) NOT NULL,
	srp_city VARCHAR(30) NOT NULL,
	srp_state CHAR(2) NOT NULL default 'FL',
	srp_zip int NOT NULL check (srp_zip > 0 and srp_zip <= 999999999), 
	srp_phone bigint NOT NULL check (srp_phone > 0 and srp_phone <= 9999999999), 
	srp_email VARCHAR(100) NOT NULL, 
	srp_url VARCHAR(100) NOT NULL, 
	srp_tot_sales DECIMAL(10,2) NOT NULL check (srp_tot_sales > 0), 
	srp_comm DECIMAL(3,2) NOT NULL check (srp_comm >= 0 and srp_comm <= 1.00),
	srp_notes VARCHAR(255) NULL, 
	-- example to create unique constraint on SSN
	-- CONSTRAINT ux_srp_ssn UNIQUE(srp_ssn)
	primary key(srp_id)
);

SELECT * FROM information_schema.tables; 

--don't include identity (auto-increment column) 
insert into dbo.slsrep
(srp_fname,srp_lname,srp_sex,srp_age,srp_street,srp_city,srp_state,srp_zip,srp_phone,srp_email,srp_url,srp_tot_sales,srp_comm,srp_notes)
values 
('John','Doe','m',18,'123 Main','Tallahassee','FL','999999999','8503457621','jdoe@aol.com','jdoe.com',1000.00,.10,'testing');

select * from dbo.slsrep;

--drop table if exists
IF OBJECT_ID (N'dbo.slsrep',N'U') IS NOT NULL 
DROP TABLE dbo.slsrep; 
GO

CREATE TABLE dbo.custsomer 
( 
	cus_id SMALLINT not null identity(1,1),
	srp_id SMALLINT not null identity(1,1),
	cus_fname VARCHAR(15) NOT NULL,
	cus_lname VARCHAR(30) NOT NULL,
	cus_sex CHAR(1) NOT NULL CHECK (cus_sex IN('m','f')),
	cus_age TINYINT NOT NULL check (cus_age >= 18 and cus_age <= 120), 
	cus_street VARCHAR(30) NOT NULL,
	cus_city VARCHAR(30) NOT NULL,
	cus_state CHAR(2) NOT NULL default 'FL',
	cus_zip int NOT NULL check (cus_zip > 0 and cus_zip <= 999999999), 
	cus_phone bigint NOT NULL check (cus_phone > 0 and cus_phone <= 9999999999),
	cus_email VARCHAR(100) NOT NULL, 
	cus_url VARCHAR(100) NOT NULL, 
	cus_balance DECIMAL(7,2) NOT NULL check (cus_balance > 0), 
	cus_tot_sales DECIMAL(10,2) NOT NULL check (cus_tot_sales > 0), 
	cus_notes VARCHAR(255) NULL, 
	PRIMARY KEY(cus_id),
	CONSTRAINT fk_cus_slsrep 
		FOREIGN KEY (srp_id) 
		REFERENCES dbo.slsrep (srp_id)
		ON DELETE CASCADE 
		ON UPDATE CASCADE 
); 

SELECT * FROM information_schema.tables; 

--get table info , including foreign keys: 
--EXEC sp_help 'tablename'; 
EXEC sp_help 'dbo.customer';
