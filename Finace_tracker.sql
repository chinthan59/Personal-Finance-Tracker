-- Create Database
CREATE DATABASE FinanceDB;
USE FinanceDB;

-- Table: Users
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Table: Categories
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

-- Table: Income
CREATE TABLE Income (
    income_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10,2),
    source VARCHAR(50),
    income_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Table: Expenses
CREATE TABLE Expenses (
    expense_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    category_id INT,
    amount DECIMAL(10,2),
    expense_date DATE,
    description VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Users
INSERT INTO Users (name, email) VALUES
('Chinthan', 'chinthan@example.com'),
('Keerthana', 'seethamma@example.com');

-- Categories
INSERT INTO Categories (category_name) VALUES
('Food'),
('Transport'),
('Shopping'),
('Bills'),
('Entertainment');

-- Income
INSERT INTO Income (user_id, amount, source, income_date) VALUES
(1, 50000, 'Salary', '2025-10-01'),
(1, 2000, 'Freelance', '2025-10-10'),
(2, 45000, 'Salary', '2025-10-01');

-- Expenses
INSERT INTO Expenses (user_id, category_id, amount, expense_date, description) VALUES
(1, 1, 1200, '2025-10-05', 'Groceries'),
(1, 2, 600, '2025-10-07', 'Cab Ride'),
(1, 3, 2000, '2025-10-10', 'Clothes'),
(1, 4, 1500, '2025-10-15', 'Electricity Bill'),
(2, 1, 1000, '2025-10-05', 'Lunch'),
(2, 5, 700, '2025-10-08', 'Movie');

SELECT 
    u.name AS user,
    c.category_name,
    SUM(e.amount) AS total_spent
FROM Expenses e
JOIN Users u ON e.user_id = u.user_id
JOIN Categories c ON e.category_id = c.category_id
GROUP BY u.name, c.category_name
ORDER BY u.name, total_spent DESC;

CREATE VIEW BalanceView AS
SELECT 
    u.name AS user,
    IFNULL(SUM(i.amount), 0) AS total_income,
    IFNULL(SUM(e.amount), 0) AS total_expense,
    (IFNULL(SUM(i.amount), 0) - IFNULL(SUM(e.amount), 0)) AS balance
FROM Users u
LEFT JOIN Income i ON u.user_id = i.user_id
LEFT JOIN Expenses e ON u.user_id = e.user_id
GROUP BY u.name;
SELECT * FROM BalanceView;

SELECT * FROM BalanceView
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/monthly_report.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';







