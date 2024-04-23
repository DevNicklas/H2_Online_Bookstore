DROP DATABASE IF EXISTS online_book_store;
CREATE DATABASE online_book_store;

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
    ISBN VARCHAR(13) PRIMARY KEY,
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
    ISBN VARCHAR(13),
    PRIMARY KEY (AuthorID, ISBN),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN)
);

CREATE TABLE Storage(
    ISBN VARCHAR(13),
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
    ISBN VARCHAR(13),
    PurchaseDate DATE NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN)
);

CREATE TABLE Bogreden_Log (
	LogID INT AUTO_INCREMENT PRIMARY KEY,
    Stamp DATETIME NOT NULL,
    Log TEXT NOT NULL
);