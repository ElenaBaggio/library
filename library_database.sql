create database library;

use library;

-- tinyint should be replaced with int
create table customers (
id int primary key auto_increment,
member_number varchar(10)not null,
name varchar(50) not null, 
email varchar(50) not null, 
phone_number tinyint(11),
age tinyint(3),
books_checked_out tinyint(2) not null, 
fines_status enum("NULL", "DUE"), 
address varchar(100)); 

create table books(
id int primary key auto_increment,
author varchar(100) not null, 
genre set("Children tales", "Feminism", "Teen fiction", "Educational") not null, 
release_date year not null, 
number_of_times_checked_out int not null,
number_of_current_reservations tinyint not null, 
location set("Children section", "Activism", "Teen section", "Education") not null); 

create table events_timetable(
id int primary key auto_increment,
event_name varchar(100) not null, 
duration varchar(10) not null);

insert into customers value(1, "A123", "Livi", "livi@me.com", 123, 29, 10, "NULL", "95 Court, Birmingham"); 
 
 insert into books value(1, "Brothers Grimm", "Children tales", 1970, 3, 0, "Children section");
 
create table checkout(
id int primary key auto_increment,
checked_out_date datetime not null, 
return_due_date date not null, 
book_returned enum("Y", "N") not null,
book_returned_date datetime, 
overdue_status enum("Y", "N"), 
customer_id int not null,
book_id int not null, 
foreign key (customer_id) references customers(id), 
foreign key (book_id) references books(id));

insert into checkout values(1, "2022-02-02 10:30:00", "2022-03-02", "Y", "2022-03-01 10:30:05", "N", 1, 1); 

show tables;

select * from checkout;





 













 
 
