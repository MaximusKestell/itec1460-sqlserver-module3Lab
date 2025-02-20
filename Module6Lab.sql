-- Create Authors Table
CREATE TABLE Authors(
    AuthorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Birthdate DATE
);

CREATE TABLE Authors (AuthorID INT PRIMARY KEY, FirstName VARCHAR(50), LastName VARCHAR(50), Birthdate DATE);

-- Create Books table
CREATE TABLE Books (BookID INT PRIMARY KEY, Title VARCHAR(100), AuthorID INT, PublicationYear INT, Price DECIMAL(10,2), FOREIGN KEY (AuthorID) REFERENCES (Authors(AuthorID)));

sqlq "CREATE TABLE Books (BookID INT PRIMARY KEY, Title VARCHAR(100), AuthorID INT, PublicationYear INT, Price DECIMAL(10,2), FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID));"


-- Insert data authors table
INSERT INTO Authors (AuthorID, FirstName, LastName, BirthDate)
VALUES
(1, 'Jane', 'Austin', '1775-12-16'),
(2, 'George', 'Orwell', '1903-06-25'),
(3, 'J.K.', 'Rowling', '1965-07-31'),
(4, 'Ernest', 'Hemingway', '1899-07-21'),
(5, 'Virginia', 'Woolf', '1882-01-25')

INSERT INTO Books (BookID, Title, AuthorID, PublicationYear, Price)
VALUES
(1, 'Pride and Prejudice', 1, 1813, 12.99),
(2, '1984', 2, 1949, 10.99),
(3, 'Harry Potter', 3, 1997, 15.99),
(4, 'The Old Man and the Sea', 4, 1952, 11.99),
(5, 'To the Lighthouse', 5, 1927, 13.99)

-- Create a view that pulls data from authors and books tables
sqlq "CREATE VIEW RecentBooks AS SELECT BookID, Title, PublicationYear, Price FROM Books Where PublicationYear > 1990;"

-- Create a View that vombines info from two tables
sqlq "CREATE VIEW BookDetails AS SELECT b.BookID, b.Title, a.FirstName + ' ' + a.LastName AS AuthorName, b.PublicationYear, b.Price FROM Books b JOIN Authors a ON b.AuthorID = a.AuthorID;"


-- Create a view that shows number of books and avg price of books
sqlq "CREATE VIEW AuthorState AS
SELECT a.AuthorID, a.FirstName + ' ' + a.LastName AS AuthorName,
COUNT(b.BookID) AS BookCount,
AVG(b.Price) AS AverageBookPrice
FROM Authors a LEFT JOIN Books b ON a.AuthorID = b.AuthorID
GROUP BY a.AuthorID, a.FirstName, a.LastName;"

-- a) Retrieve all the records from the BookDetails View
sqlq "SELECT Title, Price FROM BookDetails;"

-- b) list all the books from the recentBooks view
SELECT * FROM RecentBooks;

-- c) Show stats foir authors
SELECT * FROM AuthorStats;

-- Create an updateble view for authors firstname a nd lastname
sqlq "CREATE VIEW AuthorContactInfo AS
SELECT AuthorId, FirstName, LastName
FROM Authors;"

-- Update the authors name through the view
sqlq "UPDATE AuthorContactInfo
SET FirstName = 'Joanne'
WHERE AuthorId = 3;"

-- Query the view
SELECT * FROM AuthorContactInfo;

-- Audit trigger
CREATE TABLE BookPriceAudit (
    AuditId INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT,
    OldPrice DECIMAL(10,2),
    NewPrice DECIMAL(10,2),
    ChangeDate DATETIME DEFAULT GETDATE()
);

-- Create Trigger
CREATE TRIGGER trg_BookPriceChange
ON books
AFTER UPDATE
AS 
BEGIN
    IF UPDATE (Price)
    BEGIN
        INSERT INTO BookPriceAudit (BookID, OldPrice, NewPrice)
        SELECT i.BookID, d.Price, i.Price
        FROM inserted i 
        JOIN deleted d ON i.BookID = d.BookID
    END
END;

-- update book price
sqlq "UPDATE Books SET Price = 14.99 WHERE BookID = 1;"

SELECT * FROM BookPriceAudit;
