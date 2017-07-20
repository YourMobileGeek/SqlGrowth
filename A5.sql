--A5 MS SQL Server
-- ( not the same , but ) similar to SHOW WARNINGS;
set ANSI_WARNINGS ON; 
GO

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

------------------------------------
-- Table dbo.applicant
------------------------------------

--drop table if exists 
--N=subsequent string may be in Unicode (makes it portable to use with Unicode characters)
--U-only look for objects with this name that are tables 
--*be sure* to use dbo. before *all* table references 
IF OBJECT_ID (N'dbo.applicant',N'U') IS NOT NULL 
DROP TABLE dbo.applicant; 
GO

--create table (can't use unsigned) 
CREATE TABLE dbo.applicant
( 
	app_id SMALLINT not null identity(1,1),
	app_ssn int NOT NULL check (app_ssn > 0 and app_ssn <= 999999999),
	app_state_id VARCHAR(45) NOT NULL,
	app_fname VARCHAR(15) NOT NULL,
	app_lname VARCHAR(30) NOT NULL,
	app_street VARCHAR(30) NOT NULL,
	app_city VARCHAR(30) NOT NULL,
	app_state CHAR(2) NOT NULL default 'FL',
	app_zip int NOT NULL check (app_zip > 0 and app_zip <= 999999999),
	app_email VARCHAR(100) NOT NULL,
	app_dob DATE NOT NULL,
	app_gender CHAR(1) NOT NULL check (app_gender IN ('m','f')), 
	app_bckgd_check CHAR(1) NOT NULL check (app_bckgd_check IN ('y','n')), 
	app_notes VARCHAR(45) NULL,
	primary key(app_id),

	-- make sure SSNs and State IDs are unique
	CONSTRAINT ux_app_ssn unique nonclustered (app_ssn ASC), 
	CONSTRAINT ux_app_state_id unique nonclustered (app_state_id ASC)
);

	-- nonclustered by default

------------------------------------
-- Table dbo.property
------------------------------------

IF OBJECT_ID (N'dbo.property',N'U') IS NOT NULL 
DROP TABLE dbo.property; 
GO

--create table (can't use unsigned) 
CREATE TABLE dbo.property
( 
	prp_id SMALLINT not null identity(1,1),
	prp_street VARCHAR(30) NOT NULL,
	prp_city VARCHAR(30) NOT NULL,
	prp_state CHAR(2) NOT NULL default 'FL',
	prp_zip int NOT NULL check (prp_zip > 0 and prp_zip <= 999999999),
	prp_type VARCHAR(15) NOT NULL check,
		(prp_type IN('house','condo','townhouse','duplex','apt','mobile home','room')),
	prp_rental_rate DECIMAL (7,2) NOT NULL CHECK (prp_rental_rate > 0),
	prp_status CHAR(1) NOT NULL check (prp_status IN ('a','u')),
	prp_notes VARCHAR(255) NULL,
	primary key(prp_id);

);

------------------------------------
-- Table dbo.agreement
------------------------------------

IF OBJECT_ID (N'dbo.agreement',N'U') IS NOT NULL 
DROP TABLE dbo.agreement; 
GO

--create table (can't use unsigned) 
CREATE TABLE dbo.agreement
( 
	agr_id SMALLINT not null identity(1,1),
	prp_id SMALLINT not null,
	app_id SMALLINT not null,  
	agr_signed DATE not null, 
	agr_start DATE NOT NULL,
	agr_end DATE not null, 
	agr_amt DECIMAL (7,2) NOT null check (agr_amt > 0), 
	agr_notes VARCHAR(255) NULL,
	primary key(agr_id),

-- make sure combination of prp_id, app_id, and agr_signed is unique
	CONSTRAINT ux_prp_id_app_id_agr_signed unique nonclustered
	(prp_id ASC, app_id ASC, agr_signed ASC),

	CONSTRAINT fk_agreement_property
		FOREIGN KEY (prp_id)
		REFERENCES dbo.property (prp_id) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,

	CONSTRAINT fk_agreement_applicant
		FOREIGN KEY (app_id)
		REFERENCES dbo.applicant (app_id) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
);

------------------------------------
-- Table dbo.feature
------------------------------------

IF OBJECT_ID (N'dbo.feature',N'U') IS NOT NULL 
DROP TABLE dbo.feature; 
GO

--create table (can't use unsigned) 
CREATE TABLE dbo.feature
( 
	ftr_id TINYINT not null identity(1,1),
	ftr_type VARCHAR(45)not null,
	ftr_notes VARCHAR(255) NULL,
	primary key(ftr_id);
);



------------------------------------
-- Table dbo.prop_feature
------------------------------------

IF OBJECT_ID (N'dbo.prop_feature',N'U') IS NOT NULL 
DROP TABLE dbo.prop_feature; 
GO

--create table (can't use unsigned) 
CREATE TABLE dbo.prop_feature
( 
	pft_id SMALLINT not null identity(1,1),
	prp_id SMALLINT not null,
	ftr_id TINYINT not null. 
	pft_notes VARCHAR(255) NULL,
	primary key(pft_id),

-- make sure combination of prp_id, app_id, and agr_signed is unique
	CONSTRAINT ux_prp_id_ftr_id unique nonclustered (prp_id ASC, ftr_id ASC),

	CONSTRAINT fk_prop_feat_property
		FOREIGN KEY (prp_id)
		REFERENCES dbo.property (prp_id) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,

	CONSTRAINT fk_prop_feat_feature
		FOREIGN KEY (ftr_id)
		REFERENCES dbo.feature (ftr_id) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
);


------------------------------------
-- Table dbo.occupant
------------------------------------

IF OBJECT_ID (N'dbo.occupant',N'U') IS NOT NULL 
DROP TABLE dbo.occupant; 
GO

--create table (can't use unsigned) 
CREATE TABLE dbo.occupant
( 
	ocp_id SMALLINT not null identity(1,1),
	app_id SMALLINT NOT NULL,
	ocp_ssn int NOT NULL check (ocp_ssn > 0 and ocp_ssn <= 999999999),
	ocp_state_id VARCHAR(45) NOT NULL,
	ocp_fname VARCHAR(15) NOT NULL,
	ocp_lname VARCHAR(30) NOT NULL,
	ocp_email VARCHAR(100) NOT NULL,
	ocp_dob DATE NOT NULL,
	ocp_gender CHAR(1) NOT NULL check (ocp_gender IN ('m','f')), 
	ocp_bckgd_check CHAR(1) NOT NULL check (ocp_bckgd_check IN ('y','n')), 
	ocp_notes VARCHAR(45) NULL,
	primary key(ocp_id);

	-- make sure SSNs and State IDs are unique
	CONSTRAINT ux_ocp_ssn unique nonclustered (ocp_ssn ASC), 
	CONSTRAINT ux_ocp_state_id unique nonclustered (ocp_state_id ASC)

	CONSTRAINT fk_occupant_applicant
		FOREIGN KEY (app_id)
		REFERENCES dbo.applicant (app_id) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
);
	
------------------------------------
-- Table dbo.phone
------------------------------------

IF OBJECT_ID (N'dbo.phone',N'U') IS NOT NULL 
DROP TABLE dbo.phone; 
GO

--create table (can't use unsigned) 
CREATE TABLE dbo.phone
( 
	phn_id SMALLINT not null identity(1,1),
	app_id SMALLINT NOT NULL,
	ocp_id SMALLINT NULL,
	phn_num bigint NOT NULL check (phn_num > 0 and phn_num <= 9999999999 ),
	phn_type CHAR(1) NOT NULL CHECK (phn_type IN('c','h','w','f')),
	phn_notes VARCHAR(45) NULL,
	PRIMARY KEY (phn_id), 

	-- make sure combination of app_id and phn_num is unique 
	CONSTRAINT ux_app_id_phn_num unique nonclustered (app_id ASC, phn_num ASC), 

	-- make sure combination of ocp_id and phn_num is unique 
	CONSTRAINT ux_app_id_phn_num unique nonclustered (app_id ASC, phn_num ASC), 

	CONSTRAINT fk_phone_applicant 
		FOREIGN KEY (app_id)
		REFERENCES dbo.applicant (app_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE, 


	CONSTRAINT fk_phone_occupant 
		FOREIGN KEY (ocp_id)
		REFERENCES dbo.occupant (ocp_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION 

);

------------------------------------
-- Table dbo.room_type
------------------------------------

IF OBJECT_ID (N'dbo.room_type',N'U') IS NOT NULL 
DROP TABLE dbo.room_type; 
GO

--create table (can't use unsigned) 
CREATE TABLE dbo.room_type
( 
	rtp_id TINYINT not null identity(1,1),
	rtp_name VARCHAR(45) NOT NULL,
	rtp_notes VARCHAR(45) NULL,
	primary key(rtp_id)

);


------------------------------------
-- Table dbo.room
------------------------------------

IF OBJECT_ID (N'dbo.room',N'U') IS NOT NULL 
DROP TABLE dbo.room; 

CREATE TABLE dbo.room
( 
	rom_id SMALLINT not null identity(1,1),
	prp_id SMALLINT NOT NULL,
	rtp_id TINYINT not null,
	rom_size VARCHAR(45) not null,
	rom_notes VARCHAR(255) NULL, 
	PRIMARY KEY (rom_id),
	
-- can have duplicate room types in same property 
-- make sure combinations of prp_id and rtp_id is unique
-- CONSTRAINT ux_prp_id_rtp_id unique nonclustered (prp_id ASC, rtp_id ASC),

	CONSTRAINT fk_room_property 
		FOREIGN KEY (prp_id)
		REFERENCES dbo.property (prp_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE, 

	CONSTRAINT fk_room_roomtype
		FOREIGN KEY (rtp_id)
		REFERENCES dbo.room (rtp_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE 
);

-- show tables 
SELECT * FROM information_schema.tables; 

-- disable all constraints (must do this *after* table creation, but *before* inserts)
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

------------------------------------
-- Data for table dbo.feature 
------------------------------------
INSERT INTO dbo.feature
(ftr_type, ftr_notes)

VALUES
('Central A/C', NULL),
('Pool', NULL),
('Close to school', NULL),
('Furnished', NULL),
('Cable', NULL),
('Washer / Dryer', NULL),
('Refrigerator', NULL),
('Microwave', NULL),
('Oven', NULL),
('1-car garage', NULL),
('2-car garage', NULL),
('Sprinkler system', NULL),
('Security', NULL),
('Wi-Fi', NULL),
('Storage', NULL),
('Fireplace', NULL);

------------------------------------
-- Data for table dbo.room_type
------------------------------------
INSERT INTO dbo.feature
(rtp_name, rtp_notes)

VALUES
('Bed', NULL),
('Bath', NULL),
('Kitchen', NULL),
('Lanai', NULL),
('Dining', NULL),
('Living', NULL),
('Basement', NULL),
('Office', NULL);

------------------------------------
-- Data for dbo.room ( escape single quotation mark by doubling single quotation mark )
------------------------------------
INSERT INTO dbo.room
(prp_id, rtp_id, rom_size, rom_notes)

VALUES
( 1,1, '10" x 10"' , NULL),
( 3,2, '20" x 15"' , NULL),
( 4,3, '8" x   8"' , NULL),
( 5,4, '50" x 50"' , NULL),
( 2,5, '30" x 30"' , NULL);

------------------------------------
-- Data for table dbo.property ( will work with zip code centered as string value )
------------------------------------
INSERT INTO dbo.property
(prp_street, prp_city, prp_state, prp_zip, prp_type, prp_rental_rate, prp_status, prp_notes )

VALUES
('5133 3rd Road', 'Lake Worth', 'FL', '334671234', 'house', 1800.00, 'u', NULL), 
('92E Blah Way', 'Tallahassee', 'FL', '323011234', 'apt', 641.00, 'u', NULL), 
('756 Diet Coke Lane', 'Panama City', 'FL', '342001234', 'condo', 2400.00, 'a', NULL), 
('574 Doritos Circle', 'Jacksonville', 'FL', '365231234', 'townhouse', 1942.99, 'a', NULL), 
('2241 W. Pensacola Street', 'Tallahassee', 'FL', '323041234', 'apt', 610.00, 'u', NULL); 

------------------------------------
-- Data for table applicant 
------------------------------------
INSERT INTO dbo.applicant
(app_ssn, app_state_id, app_fname, app_lname, app_street, app_city, app_state, app_zip, app_email, app_dob, app_gender, app_bckgd_check, app_notes )

VALUES
('123456789', 'A12C34S56Q78', 'Carla', 'Vanderbilt', '5133 3rd Road', 'Lake Worth', 'FL', '334671234', 'csweeney@yahoo.com', '1961-11-26', 'F', 'y', NULL), 
('590123654', 'B123A456D789', 'Amanda', 'Lindell', '2241 W. Pensacola Street', 'Tallahasee', 'FL', '323041234', 'acc10c@my.fsu.edu', '1981-04-04', 'F', 'y', NULL), 
('987456321', 'dfed66532sedd', 'David', 'Stephens', '1293 Banana Code Drive', 'Panama City', 'FL', '323081234', 'mjowett@comcast.net', '1965-05-15', 'M', 'n', NULL), 
('3265214986', 'dgfgr56597224', 'Chris', 'Thrombough', '987 Learning Drive', 'Tallahassee', 'FL', '323011234', 'landbeck@fsu.edu', '1969-07-25', 'M', 'y', NULL), 
('326598236', 'yadayada4517', 'Spencer', 'Moore', '787 Tharpe Road', 'Tallahassee', 'FL', '323061234', 'spencer@my.fsu.edu', '1990-08-14', 'M', 'n', NULL); 
 
------------------------------------
-- Data for dbo.agreement
------------------------------------
INSERT INTO dbo.agreement
(prp_id, app_id, agr_signed, agr_start, agr_end, agr_amt, agr_notes)

VALUES
( 3,4, '2011-12-01', '2012-01-01', '2012-12-31', 1000.00, NULL),
( 1,1, '1983-01-01', '1983-01-01', '1987-12-31', 800.00, NULL),
( 4,2, '1999-12-31', '2000-01-01', '2004-12-31', 1200.00, NULL),
( 5,3, '1999-07-31', '1999-08-01', '2004-07-31', 750.00, NULL),
( 2,5, '2011-01-01', '2011-01-01', '2013-012-31', 900.00, NULL);

------------------------------------
-- Data for table dbo.occupant
------------------------------------
INSERT INTO dbo.occupant
( app_id , ocp_ssn, ocp_state_id, ocp_fname, ocp_lname, ocp_email, ocp_dob, ocp_gender, ocp_bckgd_check, ocp_notes )

VALUES
( 1, '326532165', 'okd557ig4125', 'Bridget', 'Case-Sweeney', 'bcs10c@gmail.com', '1988-03-23', 'F', 'y', NULL), 
( 1, '187452457', 'uhtoooold', 'Brian', 'Sweeney', 'brian@sweeney.com', '1956-07-28', 'M', 'y', NULL), 
( 2, '123456780', 'thisisdoggie', 'Skittles', 'McGoobs', 'skittles@wags.com', '2011-01-01', 'F', 'n', NULL),  
( 2, '098123664', 'thisisskitty', 'Smalls', 'Balls', 'smalls@meanie.com', '1988-03-05', 'M', 'n', NULL), 
( 5, '857694032', 'thisbaby324', 'Baby', 'Girl', 'baby@girl.com', '2013-04-08', 'F', 'n', NULL); 

------------------------------------
-- Data for dbo.phone
------------------------------------
INSERT INTO dbo.phone
(app_id, ocp_id, phn_num, phn_type, phn_notes)

VALUES
( 1, NULL, '5615233044', 'H', NULL),
( 2, NULL, '5616859976', 'C', NULL),
( 5, 5, '8504569872', 'H', NULL),
( 1, 1, '5613080898', 'F', NULL),
( 3, NULL, '8504152365', 'W', NULL);

--enable all constraints 
exec sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"

/* 
NOTE: both CHECKs needed: 
1) first CHECK belongs WITH 
(ensures data gets checked for consistency when activating constraint)

2) second CHECK with CONSTRAINT
(type of constraint)
*/

--show data
select * from dbo.feature; 
select * from dbo.prop_feature; 
select * from dbo.room_type;
select * from dbo.room;
select * from dbo.property;
select * from dbo.applicant;
select * from dbo.agreement;
select * from dbo.occupant;