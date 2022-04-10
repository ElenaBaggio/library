create database library;

use library;

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

-- tinyint should be replaced with bigint
ALTER TABLE customers
  modify phone_number bigint(11);
  
insert into customers value(1, "A123", "Livi", "livi@me.com", 123, 29, 10, "NULL", "95 Court, Birmingham"); 
insert into customers value(2, "B123", "Elena", "elena@me.com", 07111222333, 32, 5, "DUE", "123 Park Lane Mayfair");
insert into customers value (3, "C123", "Jo", "jo@me.com", 07999888777, 31, 2, "NULL", "1 The Street, Birmingham, B02 8YT");

-- change phone number
update customers 
set phone_number = 07555111222
where id = 1;

create table books(
id int primary key auto_increment,
author varchar(100) not null, 
genre set("Children tales", "Feminism", "Teen fiction", "Educational") not null, 
release_date year not null, 
number_of_times_checked_out int not null,
number_of_current_reservations tinyint not null, 
location set("Children section", "Activism", "Teen section", "Education") not null); 

-- add book name
alter table books
add book_name varchar(100) not null 
after id;

-- default number of times to 0
alter table books
modify number_of_times_checked_out int default 0;
alter table books
modify number_of_current_reservations int default 0;

insert into books value(1, "Brothers Grimm", "Children tales", 1970, 3, 0, "Children section");
insert into books value(2, "The Guilty Feminist", "Deborah Frances-White", "Feminism", 2019, 200, 100, "Activism");
insert into books value(3, "Vampire Diaries", "S. Myer", "Teen fiction", 2022, 50, 10, "Teen section");
insert into books value(4, "Coding for Beginners", "Martina Yusuf", "Educational", 2022, 16, 25, "Education");

 -- need to add book title for ID1
 update books
 set book_name = "Hansel and Gretel"
 where id = 1;


create table events_timetable(
id int primary key auto_increment,
event_name varchar(100) not null, 
duration varchar(10) not null);

-- edit duration column to varchar(50)
ALTER TABLE events_timetable
  modify duration varchar(50);

-- can you have a duration column? If not, can do two columns start and end datetime. 

insert into events_timetable values(1, "Homework hour", "15.30-16.30");
insert into events_timetable values(2, "Parent reading", "9.00-10.00");
insert into events_timetable values(3, "Teen hour", "16.30-17.00"); 


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

-- change order of columns
alter table checkout
modify customer_id int not null 
after id;

alter table checkout
modify book_id int not null 
after customer_id;

insert into checkout values(1, "2022-02-02 10:30:00", "2022-03-02", "Y", "2022-03-01 10:30:05", "N", 1, 1); 
insert into checkout values(2, 2, 2, "2022-03-25 11:20;00", "2022-04-25", "N", "0000-00-00 00:00:00", "N");
insert into checkout values(3, 2, 1, "2022-02-25 14:40;00", "2022-03-25", "N", "0000-00-00 00:00:00", "Y");

-- insert data and list all columns you are inserting into, don't put the column where you want a null value

-- NOTE: book_returned_date set at datetime, This cannot be NULL. 

create table fines(
id int primary key auto_increment,
customer_id int not null,
checkout_id int not null,
no_of_days_overdue tinyint not null,
fine_amount float not null,
foreign key (customer_id) references customers(id), 
foreign key (checkout_id) references checkout(id));

insert into fines values(1, 2, 3, 2, 1.00);
insert into fines values(2, 3, 3, 3, 1.50);


create table reservation(
id int primary key auto_increment,
customer_id int not null,
book_id int not null,
date_reserved date,
foreign key (customer_id) references customers(id),
foreign key (book_id) references books(id));

insert into reservation values(1, 1, 2, "2022-03-27");

update reservation
set book_id = 3
where id = 1;

create table recently_returned(
id int primary key auto_increment,
book_id int not null,
reservation_id int not null,
foreign key (book_id) references books(id),
foreign key (reservation_id) references reservation(id));

insert into recently_returned values(1, 1, 1);

create table customer_attendance(
id int primary key auto_increment,
customer_id int not null,
event_id int not null,
attendance enum("Y","N") not null,
foreign key (customer_id) references customers(id), 
foreign key (event_id) references events_timetable(id));

insert into customer_attendance values(1, 1, 1, "Y");
insert into customer_attendance(customer_id, event_id, attendance) values(2, 1, "N");
insert into customer_attendance(customer_id, event_id, attendance) values(3, 1, "Y");
insert into customer_attendance(customer_id, event_id, attendance) values(1, 2, "Y");
insert into customer_attendance(customer_id, event_id, attendance) values(2, 2, "Y");
insert into customer_attendance(customer_id, event_id, attendance) values(3, 2, "Y");
insert into customer_attendance(customer_id, event_id, attendance) values(1, 3, "N");
insert into customer_attendance(customer_id, event_id, attendance) values(2, 3, "N");
-- you can insert multiple values by doing this
insert into customer_attendance(customer_id, event_id, attendance) values(3, 3, "Y"), (2, 2, "N"), (3, 2, "Y");

-- remove rows 6-8
-- this causes a gap in the id. 
delete from customer_attendance where id = 6;
delete from customer_attendance where id = 7;
delete from customer_attendance where id = 8;
delete from customer_attendance where id = 13;

-- Livi and I were experimenting here. The first part worked, to highlight duplicates. The second part to delete the duplicates did not work. 
with CTE(customer_id,
event_id,
attendance,
duplicatecount)
as (SELECT customer_id, 
           event_id, 
           attendance, 
           ROW_NUMBER() OVER(PARTITION BY customer_id, 
                                          event_id, 
                                          attendance
           ORDER BY id) AS DuplicateCount
FROM customer_attendance)
SELECT *
FROM CTE;

with CTE(customer_id,
event_id,
attendance,
duplicatecount)
as (SELECT customer_id, 
           event_id, 
           attendance, 
           ROW_NUMBER() OVER(PARTITION BY customer_id, 
                                          event_id, 
                                          attendance
           ORDER BY id) AS DuplicateCount
FROM customer_attendance)
DELETE from CTE
where duplicatecount > 1;

show tables;

select * from customers;
select * from books;
select * from checkout;
select * from fines;
select * from reservation;
select * from recently_returned;
select * from events_timetable;
select * from customer_attendance;

-- access 
create user 'librarian'@'localhost' identified by 'password';
grant select on library.* to 'librarian'@'localhost';
grant insert on library.books to 'librarian'@'localhost';
 



