use library;

-- implement user stories
-- as a librarian, search books, to find books
select book_name, author, location from books;

-- as a librarian, catalogue books, add new books into the catalogue
insert into books(book_name, author, genre, release_date, location) values('Harry Potter', 'J.K. Rowling', 'Teen fiction', '2001', 'Teen section');
select * from books;

-- as a librarian, check user accounts, administer fees
-- pull out customer iD from fines table and connect to customers table to get name and email
select customers.id, name, email, fine_amount from customers inner join fines on customers.id = fines.customer_id;


