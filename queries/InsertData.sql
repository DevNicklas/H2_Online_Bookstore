USE online_book_store;

LOAD DATA INFILE 'C:/Users/zbc23jakl/Desktop/XAMPP/mysql/data/Danske_postnumre.csv'
INTO TABLE Citys
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(PostalCode, CityName);

SELECT * FROM Citys

INSERT INTO PriceDetails(PurchasePrice, SalesPrice)
VALUES
(500, 300),
(400, 150),
(900, 800),
(2000, 2300),
(100, 50),
(2700, 3000),
(1000, 1100),
(3000, 3100),
(4000, 5000),
(500, 400);

SELECT * FROM PriceDetails;

INSERT INTO Authors(FirstName, LastName, Nationality, Birthday, DateOfDeath)
VALUES
('Hans', 'Christian Andersen', 'Danish', '1805-09-07', '1875-08-04'),
('Karen', 'Blixen', 'Danish', '1885-04-17', '1962-09-07'),
('H.C.', 'Branner', 'Danish', '1903-07-22', '1966-06-30'),
('Tom', 'Kristensen', 'Danish', '1893-08-04', '1974-06-02'),
('Tove', 'Ditlevsen', 'Danish', '1917-12-14', '1976-03-07'),
('Henrik', 'Pontoppidan', 'Danish', '1857-07-24', '1943-08-21'),
('Suzanne', 'Brøgger', 'Danish', '1944-11-18', NULL),
('Jens', 'Christian Grøndahl', 'Danish', '1959-11-09', NULL),
('Jussi', 'Adler-Olsen', 'Danish', '1950-09-02', NULL),
('Knud', 'Romer', 'Danish', '1951-08-29', NULL);

SELECT * FROM Authors;

INSERT INTO Books(ISBN, Title, Genre, ReleaseDate, PageAmount, AuthorID, PricingDetailID)
VALUES
('978-87-01-31786-3', 'Den lille Havfrue', 'Eventyr', '1837-12-01', 32, 25, 3),
('978-87-05-03509-8', 'Babettes gæstebud', 'Novelle', '1958-04-01', 96, 26, 4);

SELECT * FROM Books;
