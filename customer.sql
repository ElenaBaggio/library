use library;

-- as a customer, see my reserved book, know when my books are in
select books.id, book_name, checkout.book_id, book_returned from books inner join checkout on books.id = checkout.book_id;
select books.id, book_name, checkout.book_id, book_returned from books inner join checkout on books.id = checkout.book_id where book_returned = 'Y';

