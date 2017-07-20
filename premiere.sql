set foreign_key_checks=0;

drop table if exists customer;
create table if not exists customer
(
customer_number char(3) not null,
last varchar(10) not null,
first varchar(8) not null,
street varchar(15) DEFAULT NULL,
city varchar(15) DEFAULT NULL,
state char(2) DEFAULT NULL,
zip_code char(5) DEFAULT NULL,
balance decimal(7,2),
credit_limit decimal(6,2),
slsrep_number char(2) DEFAULT NULL,
primary key (customer_number)
)ENGINE=InnoDB;

INSERT INTO customer
VALUES
('124','Adams','Sally','481 Oak','Lansing','MI','49224',818.75,1000,'03');
INSERT INTO customer
VALUES
('256','Samuels','Ann','215 Pete','Grant','MI','49219',21.50,1500,'06');
INSERT INTO customer
VALUES
('311','Charles','Don','48 College','Ira','MI','49034',825.75,1000,'12');
INSERT INTO customer
VALUES
('315','Daniels','Tom','914 Cherry','Kent','MI','48391',770.75,750,'06');
INSERT INTO customer
VALUES
('405','Williams','Al','519 Watson','Grant','MI','49219',402.75,1500,'12');
INSERT INTO customer
VALUES
('412','Adams','Sally','16 Elm','Lansing','MI','49224',1817.50,2000,'03');
INSERT INTO customer
VALUES
('522','Nelson','Mary','108 Pine','Ada','MI','49441',98.75,1500,'12');
INSERT INTO customer
VALUES
('567','Dinh','Tran','808 Ridge','Harper','MI','48421',402.40,750,'06');
INSERT INTO customer
VALUES
('587','Galvez','Mara','512 Pine','Ada','MI','49441',114.60,1000,'06');
INSERT INTO customer
VALUES
('622','Martin','Dan','419 Chip','Grant','MI','49219',1045.75,1000,'03');

drop table if exists sales_rep;
create table if not exists sales_rep
(
slsrep_number char(2) not null,
last varchar(20) not null,
first varchar(15) not null,
street varchar(25) DEFAULT NULL,
city varchar(15) DEFAULT NULL,
state char(2) DEFAULT NULL,
zip_code char(5) DEFAULT NULL,
total_commission decimal(7,2),
commission_rate decimal(3,2),
primary key (slsrep_number)
)engine=InnoDB;

INSERT INTO sales_rep
VALUES
('03','Jones','Mary','123 Main','Grant','MI','49219',2150.00,.05);
INSERT INTO sales_rep
VALUES
('06','Smith','William','102 Raymond','Ada','MI','49441',4912.50,.07);
INSERT INTO sales_rep
VALUES
('12','Diaz','Miguel','419 Harper','Lansing','MI','49224',2150.00,.05);

drop table if exists part;
create table if not exists part
(
part_number char(4) NOT NULL,
part_description varchar(12) DEFAULT NULL,
units_on_hand int(4),
item_class char(2) DEFAULT NULL,
warehouse_number char(1),
unit_price decimal(6,2),
PRIMARY KEY (part_number)
)engine=InnoDB;

INSERT INTO part
VALUES
('AX12','Iron',104,'HW','3',24.95);
INSERT INTO part
VALUES
('AZ52','Dartboard',20,'SG','2',12.95);
INSERT INTO part
VALUES
('BA74','Basketball',40,'SG','1',29.95);
INSERT INTO part
VALUES
('BH22','Cornpopper',95,'HW','3',24.95);
INSERT INTO part
VALUES
('BT04','Gas Grill',11,'AP','2',149.99);
INSERT INTO part
VALUES
('BZ66','Washer',52,'AP','3',399.99);
INSERT INTO part
VALUES
('CA14','Griddle',78,'HW','3',39.99);
INSERT INTO part
VALUES
('CB03','Bike',44,'SG','1',299.99);
INSERT INTO part
VALUES
('CX11','Blender',112,'HW','3',22.95);
INSERT INTO part
VALUES
('CZ81','Treadmill',68,'SG','2',349.95);

drop table if exists orders;
create table if not exists orders
(
order_number char(5) NOT NULL,
order_date date,
customer_number char(3) NOT NULL,
PRIMARY KEY (order_number)
)engine=InnoDB;

insert into orders
values
('12489','2002-09-02','124');
insert into orders
values
('12491','2002-09-02','311');
insert into orders
values
('12494','2002-09-04','315');
insert into orders
values
('12495','2002-09-04','256');
insert into orders
values
('12498','2002-09-05','522');
insert into orders
values
('12500','2002-09-05','124');
insert into orders
values
('12504','2002-09-05','522');

drop table if exists order_line;
create table if not exists order_line
(
order_number char(5) NOT NULL,
part_number char(4) NOT NULL,
number_ordered int(3) DEFAULT 0,
quoted_price decimal(6,2),
primary key (order_number, part_number)
)engine=InnoDB;

INSERT INTO order_line
VALUES
('12489','AX12',11,21.95);
INSERT INTO order_line
VALUES
('12491','BT04',1,149.99);
INSERT INTO order_line
VALUES
('12491','BZ66',1,399.99);
INSERT INTO order_line
VALUES
('12494','CB03',4,279.99);
INSERT INTO order_line
VALUES
('12495','CX11',2,22.95);
INSERT INTO order_line
VALUES
('12498','AZ52',2,12.95);
INSERT INTO order_line
VALUES
('12498','BA74',4,24.95);
INSERT INTO order_line
VALUES
('12500','BT04',1,149.99);
INSERT INTO order_line
VALUES
('12504','CZ81',2,325.99);

set foreign_key_checks=1;
