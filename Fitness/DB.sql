CREATE TABLE Users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
);

INSERT INTO Users (name, email) VALUES
('Alice Smith', 'alice@example.com'),
('Bob Johnson', 'bob@example.com'),
('Charlie Brown', 'charlie@example.com');

CREATE TABLE Classes (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    instructor_id INTEGER,
    date DATE NOT NULL,
    max_seats INTEGER NOT NULL
);

CREATE TABLE Instructors (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

INSERT INTO Instructors (name) VALUES
('David Lee'),
('Eva Martinez');

INSERT INTO Classes (name, instructor_id, date, max_seats) VALUES
('Yoga', 1, '2023-10-20', 20),
('Pilates', 2, '2023-10-21', 15),
('Zumba', 1, '2023-10-22', 25);

CREATE TABLE Bookings (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    class_id INTEGER,
    booking_date DATE NOT NULL
);

INSERT INTO Bookings (user_id, class_id, booking_date) VALUES
(1, 1, '2023-10-19'),
(2, 2, '2023-10-19'),
(3, 3, '2023-10-19');

CREATE TABLE Attendance (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    class_id INTEGER,
    attended INTEGER DEFAULT 0
);

INSERT INTO Attendance (user_id, class_id, attended) VALUES
(1, 1, 1),
(2, 2, 0),
(3, 3, 1);

CREATE TABLE Payments (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    amount DECIMAL(10, 2),
    payment_date DATE NOT NULL
);

INSERT INTO Payments (user_id, amount, payment_date) VALUES
(1, 15.00, '2023-10-19'),
(2, 20.00, '2023-10-19'),
(3, 15.00, '2023-10-19');

-- Questions

-- Q1: How many seats are left for a specific class?
SELECT c.name, c.max_seats - COUNT(b.id) AS seats_left 
FROM Classes c
LEFT JOIN Bookings b ON c.id = b.class_id
WHERE c.name = 'Yoga';

-- Q2: How much has a user spent in the past month?
SELECT SUM(p.amount)
FROM Payments p
WHERE p.user_id = 1 AND strftime('%Y-%m', p.payment_date) = strftime('%Y-%m', 'now');

-- Q3: Which classes has a user booked but not attended?
SELECT c.name 
FROM Classes c
JOIN Bookings b ON c.id = b.class_id
LEFT JOIN Attendance a ON b.user_id = a.user_id AND b.class_id = a.class_id
WHERE b.user_id = 1 AND (a.attended IS NULL OR a.attended = 0);

-- Q4: Who are the instructors and what classes do they teach?
SELECT i.name AS instructor, GROUP_CONCAT(c.name) AS classes_taught
FROM Instructors i
JOIN Classes c ON i.id = c.instructor_id
GROUP BY i.id;

-- Q5: How many users have booked a class but not paid?
SELECT COUNT(DISTINCT b.user_id)
FROM Bookings b
LEFT JOIN Payments p ON b.user_id = p.user_id
WHERE p.id IS NULL;

