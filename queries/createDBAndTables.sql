-- Create a database
DROP DATABASE IF EXISTS online_book_store;
CREATE DATABASE online_book_store;

-- Create a user since the database owner isn't a built-in concept in MySQL
-- Grant all privileges to the user, which is the closest to a "database owner"
DROP USER IF EXISTS 'dbowner'@'localhost';
CREATE USER 'dbowner'@'localhost' IDENTIFIED BY 'RWAORL;akstakO1023?alooriA';
GRANT ALL PRIVILEGES ON online_book_store.* TO 'dbowner'@'localhost';

-- Create all tables within the newly created database "online_book_store"
USE online_book_store;

CREATE TABLE PriceDetails(
    PricingDetailID INT AUTO_INCREMENT PRIMARY KEY,
    PurchasePrice DECIMAL(6,2) NOT NULL,
    SalesPrice DECIMAL(6,2) NOT NULL
);

CREATE TABLE Authors(
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(30) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Nationality VARCHAR(100) NOT NULL,
    Birthday DATE,
    DateOfDeath DATE
);

CREATE TABLE Books(
    ISBN CHAR(17) PRIMARY KEY,
    Title VARCHAR(50) NOT NULL,
    Genre VARCHAR(50) NOT NULL,
    ReleaseDate DATE NOT NULL,
    PageAmount SMALLINT UNSIGNED NOT NULL,
    AuthorID INT, 
    PricingDetailID INT, 
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (PricingDetailID) REFERENCES PriceDetails(PricingDetailID)
);

CREATE TABLE BookAuthors (
    AuthorID INT,
    ISBN CHAR(17),
    PRIMARY KEY (AuthorID, ISBN),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN)
);

CREATE TABLE Storage(
    ISBN CHAR(17),
    StorageLocation VARCHAR(50),
    Quantity SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (ISBN, StorageLocation),
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN)
);

CREATE TABLE Citys (
	PostalCode VARCHAR(15) PRIMARY KEY,
    CityName VARCHAR(255) NOT NULL
);

CREATE TABLE LoginInfo (
	LoginID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(30) NOT NULL,
    PasswordHash VARCHAR(1023) NOT NULL,
    Salt VARCHAR(255) NOT NULL
);

CREATE TABLE Customers (
	CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(30) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(15),
    Country VARCHAR(100) NOT NULL,
    Region VARCHAR(50),
    PostalCode VARCHAR(15),
    StreetAddress VARCHAR(255) NOT NULL,
    LoginID INT,
    FOREIGN KEY (PostalCode) REFERENCES Citys(PostalCode),
    FOREIGN KEY (LoginID) REFERENCES LoginInfo(LoginID)
);

CREATE TABLE PurchaseLog (
	PurchaseID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    ISBN CHAR(17),
    PurchaseDate DATE NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN)
);

CREATE TABLE BogredenLog (
	LogID INT AUTO_INCREMENT PRIMARY KEY,
    Stamp DATETIME NOT NULL,
    Log TEXT NOT NULL
);

CREATE INDEX idxPriceDetailsAllColumns ON PriceDetails(PurchasePrice, SalesPrice);
CREATE INDEX idxAuthorsAllColumns ON Authors (FirstName, LastName, Nationality, Birthday, DateOfDeath);
CREATE INDEX idxBooksAllColumns ON Books(Title, Genre, ReleaseDate, PageAmount, AuthorID, PricingDetailID);
CREATE INDEX idxStorage ON Storage(Quantity);
CREATE INDEX idxCitys ON Citys(CityName);
CREATE INDEX idxLoginInfo ON LoginInfo(Username, PasswordHash, Salt);
CREATE INDEX idxCustomersAllColumns ON Customers(FirstName, LastName, Email, PhoneNumber, Country, Region, PostalCode, StreetAddress, LoginID);
CREATE INDEX idxPurchaseLog ON PurchaseLog(CustomerID, ISBN, PurhcaseDate);
CREATE INDEX idxBogredenLog ON BogredenLog(Stamp, Log);
