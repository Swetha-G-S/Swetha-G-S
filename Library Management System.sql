create database library_management_system;
USE library_management_system;



create table books(
book_id INT auto_increment primary key,
title varchar(255) not null,
author varchar(255) not null,
isbn varchar(13),
available boolean default true
);

CREATE TABLE borrowers (
    borrower_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
    );
    
    CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    borrower_id INT,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (borrower_id) REFERENCES borrowers(borrower_id)
);
INSERT INTO books (title, author, isbn) VALUES
('Harry Potter and the Philosopher''s Stone', 'J.K. Rowling', '9780747532743'),
('To Kill a Mockingbird', 'Harper Lee', '9780061120084'),
('1984', 'George Orwell', '9780452284234');

INSERT INTO borrowers (name, email) VALUES
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com');

INSERT INTO transactions (book_id, borrower_id, issue_date, due_date) VALUES
(1, 1, '2024-02-01', '2024-02-15'),
(2, 2, '2024-02-10', '2024-02-24'),
(3, 1, '2024-02-15', '2024-03-01');

 -- queries--
 -- Question 1 : Retrieve a list of all books in the library. --
 
 
 SELECT * FROM books;
 
 -- Question 2: Find books by a specific author ? --
SELECT * FROM books WHERE author = 'J.K. Rowling';

-- Question 3: Check if a particular book is available ? --
SELECT * FROM books WHERE title = 'Harry Potter and the Philosopher''s Stone' AND available = TRUE;

-- Question 4: List all borrowers who have borrowed books ? --
SELECT * FROM borrowers;

-- Question 5: Calculate the total number of books borrowed by each borrower ? -- 
SELECT borrower_id, COUNT(*) AS total_books_borrowed FROM transactions GROUP BY borrower_id;

--  Question 6: Find books that are overdue ? --
SELECT * FROM transactions WHERE due_date < CURRENT_DATE AND return_date IS NULL;

-- views, stored procedures--
-- View 1: Available Books--

CREATE VIEW available_books AS
SELECT * FROM books WHERE available = TRUE;

-- Stored Procedure 1: Borrow Book --


CREATE PROCEDURE borrow_book(IN book_id INT, IN borrower_id INT, IN issue_date DATE, IN due_date DATE)

    INSERT INTO transactions (book_id, borrower_id, issue_date, due_date) VALUES (book_id, borrower_id, issue_date, due_date);
    UPDATE books SET available = FALSE WHERE book_id = book_id;


-- Stored Procedure 2: Return Book --
CREATE PROCEDURE return_book(IN transaction_id INT, IN return_date DATE)

    UPDATE transactions SET return_date = return_date WHERE transaction_id = transaction_id;
    UPDATE books b
    JOIN transactions t ON b.book_id = t.book_id
    SET b.available = TRUE
    WHERE t.transaction_id = transaction_id;

-- Question 7: Retrieve all borrowed books along with borrower details ? --

SELECT t.transaction_id, b.title, b.author, bo.name AS borrower_name, bo.email AS borrower_email
FROM transactions t
JOIN books b ON t.book_id = b.book_id
JOIN borrowers bo ON t.borrower_id = bo.borrower_id
WHERE t.return_date IS NULL;

-- Question 8: List all overdue books along with borrower details ? --

SELECT t.transaction_id, b.title, b.author, bo.name AS borrower_name, bo.email AS borrower_email
FROM transactions t
JOIN books b ON t.book_id = b.book_id
JOIN borrowers bo ON t.borrower_id = bo.borrower_id
WHERE t.due_date < CURRENT_DATE AND t.return_date IS NULL;

-- Question 9: Retrieve the count of books borrowed by each borrower ? --

SELECT bo.name AS borrower_name, COUNT(*) AS books_borrowed
FROM transactions t
JOIN borrowers bo ON t.borrower_id = bo.borrower_id
GROUP BY bo.borrower_id;

-- Question 10: List all transactions with their details ? --

SELECT t.transaction_id, b.title, b.author, bo.name AS borrower_name, t.issue_date, t.due_date, t.return_date
FROM transactions t
JOIN books b ON t.book_id = b.book_id
JOIN borrowers bo ON t.borrower_id = bo.borrower_id;

-- Security Implementation --
CREATE USER 'library_user'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT ON library_management_system.* TO 'library_user'@'localhost';

--  Indexes -- 
CREATE INDEX idx_books_author ON books(author);
CREATE INDEX idx_transactions_due_date ON transactions(due_date);

-- Data Encryption --
ALTER TABLE borrowers MODIFY COLUMN email VARBINARY(100);

INSERT INTO borrowers (name, email) VALUES ('John Doe', AES_ENCRYPT('john@example.com', 'encryption_key'));
SELECT name, AES_DECRYPT(email, 'encryption_key') AS email FROM borrowers;

 








 