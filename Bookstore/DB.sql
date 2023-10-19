-- Create Authors table
CREATE TABLE Authors (
    author_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

-- Create Genres table
CREATE TABLE Genres (
    genre_id INTEGER PRIMARY KEY,
    genre_name TEXT NOT NULL
);

-- Create Books table
CREATE TABLE Books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES Authors(author_id),
    genre_id INTEGER REFERENCES Genres(genre_id),
    price REAL NOT NULL,
    stock INTEGER NOT NULL
);

-- Create Customers table
CREATE TABLE Customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES Customers(customer_id),
    date_ordered DATE NOT NULL
);

-- Create OrderDetails table
CREATE TABLE OrderDetails (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES Orders(order_id),
    book_id INTEGER REFERENCES Books(book_id),
    quantity INTEGER NOT NULL
);

-- Create Suppliers table
CREATE TABLE Suppliers (
    supplier_id INTEGER PRIMARY KEY,
    supplier_name TEXT NOT NULL UNIQUE
);

-- Create BookSuppliers table
CREATE TABLE BookSuppliers (
    book_supplier_id INTEGER PRIMARY KEY,
    book_id INTEGER REFERENCES Books(book_id),
    supplier_id INTEGER REFERENCES Suppliers(supplier_id),
    date_supplied DATE NOT NULL,
    quantity_supplied INTEGER NOT NULL
);

--Inserting Data

-- Authors
INSERT INTO Authors (author_id, name) VALUES
(1, 'J.K. Rowling'),
(2, 'Suzanne Collins'),
(3, 'George Orwell');

-- Genres
INSERT INTO Genres (genre_id, genre_name) VALUES
(1, 'Fantasy'),
(2, 'Dystopian'),
(3, 'Classic');

-- Books
INSERT INTO Books (book_id, title, author_id, genre_id, price, stock) VALUES
(1, 'Harry Potter', 1, 1, 20.99, 100),
(2, 'Hunger Games', 2, 2, 14.99, 75),
(3, '1984', 3, 3, 10.99, 50);

-- Customers
INSERT INTO Customers (customer_id, name, email) VALUES
(1, 'John Doe', 'john@example.com'),
(2, 'Jane Smith', 'jane@example.com');

-- Orders
INSERT INTO Orders (order_id, customer_id, date_ordered) VALUES
(1, 1, '2023-10-18'),
(2, 2, '2023-10-15');

-- OrderDetails
INSERT INTO OrderDetails (order_detail_id, order_id, book_id, quantity) VALUES
(1, 1, 1, 2),
(2, 2, 2, 1),
(3, 2, 3, 1);

-- Suppliers
INSERT INTO Suppliers (supplier_id, supplier_name) VALUES
(1, 'SupplyCo'),
(2, 'ReadsWell');

-- BookSuppliers
INSERT INTO BookSuppliers (book_supplier_id, book_id, supplier_id, date_supplied, quantity_supplied) VALUES
(1, 1, 1, '2023-09-01', 50),
(2, 2, 1, '2023-09-05', 40),
(3, 3, 2, '2023-09-10', 30);

-- Questions

--What is the total monthly spend of a particular customer? 
SELECT c.name, SUM(b.price * od.quantity) AS monthly_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Books b ON od.book_id = b.book_id
WHERE c.customer_id = [CUSTOMER_ID] AND strftime('%Y-%m', date_ordered) = '2023-10'
GROUP BY c.name;

-- Which genre is most popular based on sales
SELECT g.genre_name, SUM(od.quantity) AS total_sold
FROM Genres g
JOIN Books b ON g.genre_id = b.genre_id
JOIN OrderDetails od ON b.book_id = od.book_id
GROUP BY g.genre_name
ORDER BY total_sold DESC
LIMIT 1;

-- Which supplier has supplied the most books?
SELECT s.supplier_name, SUM(bs.quantity_supplied) AS total_supplied
FROM Suppliers s
JOIN BookSuppliers bs ON s.supplier_id = bs.supplier_id
GROUP BY s.supplier_name
ORDER BY total_supplied DESC;




