-- Create a database
DROP DATABASE IF EXISTS online_book_store;
CREATE DATABASE online_book_store;

-- Create a user since the database owner isn't a built-in concept in MySQL
-- Grant all privileges to the user, which is the closest to a "database owner"
DROP USER IF EXISTS 'dbowner'@'localhost';
CREATE USER 'dbowner'@'localhost' IDENTIFIED BY 'RWAORLakstakO1023alooriA';
GRANT ALL PRIVILEGES ON online_book_store.* TO 'dbowner'@'localhost';

-- Create all tables within the newly created database "online_book_store"
USE online_book_store;

CREATE TABLE PriceDetails(
    PricingDetailID INT AUTO_INCREMENT PRIMARY KEY,
    PurchasePrice DECIMAL(8,2) NOT NULL,
    SalesPrice DECIMAL(8,2) NOT NULL
);

CREATE TABLE Authors(
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(30) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Nationality VARCHAR(100) NOT NULL,
    Birthday DATE,
    DateOfDeath DATE,
    INDEX idxAuthorLastName (LastName)
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
    FOREIGN KEY (PricingDetailID) REFERENCES PriceDetails(PricingDetailID),
    INDEX idxTitle (Title)
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

CREATE TABLE Countries (
	CountryCode CHAR(2) PRIMARY KEY,
    CountryName VARCHAR(100) NOT NULL
);

CREATE TABLE Logins (
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
    CountryCode CHAR(2),
    Region VARCHAR(50),
    PostalCode VARCHAR(15),
    StreetAddress VARCHAR(255) NOT NULL,
    LoginID INT,
    FOREIGN KEY (CountryCode) REFERENCES Countries(CountryCode),
    FOREIGN KEY (PostalCode) REFERENCES Citys(PostalCode),
    FOREIGN KEY (LoginID) REFERENCES Logins(LoginID),
    INDEX idxCustomerName (FirstName, LastName)
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





-- All triggers





DELIMITER //

-- Trigger for logging insert operations on PriceDetails table
CREATE TRIGGER log_pricedetails_insert
AFTER INSERT ON PriceDetails
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Inserted row into PriceDetails:',
           '\nPricing Detail ID: ', NEW.PricingDetailID,
           '\nPurchase Price: ', NEW.PurchasePrice,
           '\nSales Price: ', NEW.SalesPrice
          )
    );
END//

-- Trigger for logging insert operations on Authors table
CREATE TRIGGER log_authors_insert
AFTER INSERT ON Authors
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Inserted row into Authors:',
           '\nAuthor ID: ', NEW.AuthorID,
           '\nFirst Name: ', NEW.FirstName,
           '\nLast Name: ', NEW.LastName,
           '\nNationality: ', NEW.Nationality,
           '\nBirthday: ', COALESCE(NEW.Birthday, 'N/A'),
           '\nDate of Death: ', COALESCE(NEW.DateOfDeath, 'N/A')
          )
    );
END//

-- Trigger for logging insert operations on Books table
CREATE TRIGGER log_books_insert
AFTER INSERT ON Books
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Inserted row:',
           '\nISBN: ', NEW.ISBN,
           '\nTitle: ', NEW.Title,
           '\nGenre: ', NEW.Genre,
           '\nRelease Date: ', NEW.ReleaseDate,
           '\nPage Amount: ', NEW.PageAmount,
           '\nAuthor ID: ', NEW.AuthorID,
           '\nPricing Detail ID: ', NEW.PricingDetailID
          )
    );
END;

-- Trigger for logging insert operations on Storage table
CREATE TRIGGER log_storage_insert
AFTER INSERT ON Storage
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Inserted row into Storage:',
           '\nISBN: ', NEW.ISBN,
           '\nStorage Location: ', NEW.StorageLocation,
           '\nQuantity: ', NEW.Quantity
          )
    );
END//

-- Trigger for logging insert operations on Citys table
CREATE TRIGGER log_citys_insert
AFTER INSERT ON Citys
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Inserted row into Citys:',
           '\nPostal Code: ', NEW.PostalCode,
           '\nCity Name: ', NEW.CityName
          )
    );
END//

-- Trigger for logging insert operations on Countries table
CREATE TRIGGER log_countries_insert
AFTER INSERT ON Countries
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Inserted row into Countries:',
           '\nConutry Code: ', NEW.CountryCode,
           '\nCountry Name: ', NEW.CountryName
          )
    );
END//

-- Trigger for logging insert operations on Logins table
CREATE TRIGGER log_logins_insert
AFTER INSERT ON Logins
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Inserted row into Logins:',
           '\nLogin ID: ', NEW.LoginID,
           '\nUsername: ', NEW.Username,
           '\nPassword Hash: ', NEW.PasswordHash,
           '\nSalt: ', NEW.Salt
          )
    );
END//

-- Trigger for logging insert operations on Customers table
CREATE TRIGGER log_customers_insert
AFTER INSERT ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Inserted row into Customers:',
           '\nCustomer ID: ', NEW.CustomerID,
           '\nFirst Name: ', NEW.FirstName,
           '\nLast Name: ', NEW.LastName,
           '\nEmail: ', NEW.Email,
           '\nPhone Number: ', COALESCE(NEW.PhoneNumber, 'N/A'),
           '\nCountryCode: ', NEW.CountryCode,
           '\nRegion: ', COALESCE(NEW.Region, 'N/A'), 
           '\nPostal Code: ', NEW.PostalCode, 
           '\nStreet Address: ', NEW.StreetAddress,
           '\nLogin ID: ', NEW.LoginID
          )
    );
END//

-- Trigger for logging insert operations on PurchaseLog table
CREATE TRIGGER log_purchaselog_insert
AFTER INSERT ON PurchaseLog
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Inserted row into PurchaseLog:',
           '\nPurchase ID: ', NEW.PurchaseID,
           '\nCustomer ID: ', NEW.CustomerID,
           '\nISBN: ', NEW.ISBN,
           '\nPurchase Date: ', NEW.PurchaseDate
          )
    );
END//

-- Trigger for logging update operations on PriceDetails table
CREATE TRIGGER log_pricedetails_update
AFTER UPDATE ON PriceDetails
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Updated row with Pricing Detail ID: ', OLD.PricingDetailID,
           '\nChanges:',
           IF(OLD.PurchasePrice <> NEW.PurchasePrice, CONCAT('\nPurchase Price: ', OLD.PurchasePrice, ' -> ', NEW.PurchasePrice), ''),
           IF(OLD.SalesPrice <> NEW.SalesPrice, CONCAT('\nSales Price: ', OLD.SalesPrice, ' -> ', NEW.SalesPrice), '')
          )
    );
END//

-- Trigger for logging update operations on Authors table
CREATE TRIGGER log_authors_update
AFTER UPDATE ON Authors
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Updated row with Author ID: ', OLD.AuthorID,
           '\nChanges:',
           IF(OLD.FirstName <> NEW.FirstName, CONCAT('\nFirst Name: ', OLD.FirstName, ' -> ', NEW.FirstName), ''),
           IF(OLD.LastName <> NEW.LastName, CONCAT('\nLast Name: ', OLD.LastName, ' -> ', NEW.LastName), ''),
           IF(OLD.Nationality <> NEW.Nationality, CONCAT('\nNationality: ', OLD.Nationality, ' -> ', NEW.Nationality), ''),
           IF(OLD.Birthday <> NEW.Birthday, CONCAT('\nBirthday: ', COALESCE(OLD.Birthday, 'N/A'), ' -> ', COALESCE(NEW.Birthday, 'N/A')), ''),
           IF(OLD.DateOfDeath <> NEW.DateOfDeath, CONCAT('\nDate of Death: ', COALESCE(OLD.DateOfDeath, 'N/A'), ' -> ', COALESCE(NEW.DateOfDeath, 'N/A')), '')
          )
    );          
END//

-- Trigger for logging update operations on Books table
CREATE TRIGGER log_books_update
AFTER UPDATE ON Books
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Updated row with ISBN: ', OLD.ISBN,
           '\nChanges:',
           IF(OLD.Title <> NEW.Title, CONCAT('\nTitle: ', OLD.Title, ' -> ', NEW.Title), ''),
           IF(OLD.Genre <> NEW.Genre, CONCAT('\nGenre: ', OLD.Genre, ' -> ', NEW.Genre), ''),
           IF(OLD.ReleaseDate <> NEW.ReleaseDate, CONCAT('\nRelease Date: ', OLD.ReleaseDate, ' -> ', NEW.ReleaseDate), ''),
           IF(OLD.PageAmount <> NEW.PageAmount, CONCAT('\nPage Amount: ', OLD.PageAmount, ' -> ', NEW.PageAmount), ''),
           IF(OLD.AuthorID <> NEW.AuthorID, CONCAT('\nAuthor ID: ', OLD.AuthorID, ' -> ', NEW.AuthorID), ''),
           IF(OLD.PricingDetailID <> NEW.PricingDetailID, CONCAT('\nPricing Detail ID: ', OLD.PricingDetailID, ' -> ', NEW.PricingDetailID), '')
          )
    );
END//

-- Trigger for logging update operations on Storage table
CREATE TRIGGER log_storage_update
AFTER UPDATE ON Storage
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Updated row with ISBN: ', OLD.ISBN, ' and Storage Location: ', OLD.StorageLocation,
           '\nChanges:',
           IF(OLD.Quantity <> NEW.Quantity, CONCAT('\nQuantity: ', OLD.Quantity, ' -> ', NEW.Quantity), '')
          )
    );
END//

-- Trigger for logging update operations on Citys table
CREATE TRIGGER log_citys_update
AFTER UPDATE ON Citys
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Updated row with Postal Code: ', OLD.PostalCode,
           '\nChanges:',
           IF(OLD.CityName <> NEW.CityName, CONCAT('\nCity Name: ', OLD.CityName, ' -> ', NEW.CityName), '')
          )
    );
END//

-- Trigger for logging update operations on Countries table
CREATE TRIGGER log_countries_update
AFTER UPDATE ON Countries
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Updated row with Country Code: ', OLD.CountryCode,
           '\nChanges:',
           IF(OLD.CountryName <> NEW.CountryName, CONCAT('\nCity Name: ', OLD.CountryName, ' -> ', NEW.CountryName), '')
          )
    );
END//

-- Trigger for logging update operations on Logins table
CREATE TRIGGER log_logins_update
AFTER UPDATE ON Logins
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Updated row with Login ID: ', OLD.LoginID,
           '\nChanges:',
           IF(OLD.Username <> NEW.Username, CONCAT('\nUsername: ', OLD.Username, ' -> ', NEW.Username), ''),
           IF(OLD.PasswordHash <> NEW.PasswordHash, CONCAT('\nPassword Hash: ', OLD.PasswordHash, ' -> ', NEW.PasswordHash), ''),
           IF(OLD.Salt <> NEW.Salt, CONCAT('\nSalt: ', OLD.Salt, ' -> ', NEW.Salt), '')
          )
    );
END//

-- Trigger for logging update operations on Customers table
CREATE TRIGGER log_customers_update
AFTER UPDATE ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Updated row with Customer ID: ', OLD.CustomerID,
           '\nChanges:',
           IF(OLD.FirstName <> NEW.FirstName, CONCAT('\nFirst Name: ', OLD.FirstName, ' -> ', NEW.FirstName), ''),
           IF(OLD.LastName <> NEW.LastName, CONCAT('\nLast Name: ', OLD.LastName, ' -> ', NEW.LastName), ''),
           IF(OLD.Email <> NEW.Email, CONCAT('\nEmail: ', OLD.Email, ' -> ', NEW.Email), ''),
           IF(OLD.PhoneNumber <> NEW.PhoneNumber, CONCAT('\nPhone Number: ', COALESCE(OLD.PhoneNumber, 'N/A'), ' -> ', COALESCE(NEW.PhoneNumber, 'N/A')), ''),
           IF(OLD.CountryCode <> NEW.CountryCode, CONCAT('\nCountryCode: ', OLD.CountryCode, ' -> ', NEW.CountryCode), ''),
           IF(OLD.Region <> NEW.Region, CONCAT('\nRegion: ', OLD.Region, ' -> ', NEW.Region), ''),
           IF(OLD.PostalCode <> NEW.PostalCode, CONCAT('\nPostal Code: ', COALESCE(OLD.Region, 'N/A'), ' -> ',COALESCE(NEW.Region, 'N/A')), ''),
           IF(OLD.StreetAddress <> NEW.StreetAddress, CONCAT('\nStreet Address: ', OLD.StreetAddress, ' -> ', NEW.StreetAddress), ''),
           IF(OLD.LoginID <> NEW.LoginID, CONCAT('\nLogin ID: ', OLD.LoginID, ' -> ', NEW.LoginID), '')
          )
    );
END//

-- Trigger for logging update operations on PurchaseLog table
CREATE TRIGGER log_purchaselog_update
AFTER UPDATE ON PurchaseLog
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Updated row with Purchase ID: ', OLD.PurchaseID,
           '\nChanges:',
           IF(OLD.CustomerID <> NEW.CustomerID, CONCAT('\nCustomer ID: ', OLD.CustomerID, ' -> ', NEW.CustomerID), ''),
           IF(OLD.ISBN <> NEW.ISBN, CONCAT('\nISBN: ', OLD.ISBN, ' -> ', NEW.ISBN), ''),
           IF(OLD.PurchaseDate <> NEW.PurchaseDate, CONCAT('\nPurchase Date: ', OLD.PurchaseDate, ' -> ', NEW.PurchaseDate), '')
          )
    );
END//

-- Trigger for logging delete operations on PriceDetails table
CREATE TRIGGER log_pricedetails_delete
AFTER DELETE ON PriceDetails
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Deleted row with Pricing Detail ID: ', OLD.PricingDetailID,
           '\nPurchase Price: ', OLD.PurchasePrice,
           '\nSales Price: ', OLD.SalesPrice
          )
    );
END//

-- Trigger for logging delete operations on Authors table
CREATE TRIGGER log_authors_delete
AFTER DELETE ON Authors
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Deleted row with Author ID: ', OLD.AuthorID,
           '\nFirst Name: ', OLD.FirstName,
           '\nLast Name: ', OLD.LastName,
           '\nNationality: ', OLD.Nationality,
           '\nBirthday: ', COALESCE(OLD.Birthday, 'N/A'),
           '\nDate of Death: ', COALESCE(OLD.DateOfDeath, 'N/A')
          )
    );
END//

-- Trigger for logging delete operations on Books table
CREATE TRIGGER log_books_delete
AFTER DELETE ON Books
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Deleted row',
           '\nISBN: ', OLD.ISBN,
           '\nTitle: ', OLD.Title,
           '\nGenre: ', OLD.Genre,
           '\nRelease Date: ', OLD.ReleaseDate,
           '\nPage Amount: ', OLD.PageAmount,
           '\nAuthor ID: ', OLD.AuthorID,
           '\nPricing Detail ID: ', OLD.PricingDetailID
          )
    );
END//

-- Trigger for logging delete operations on Storage table
CREATE TRIGGER log_storage_delete
AFTER DELETE ON Storage
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Deleted row with ISBN: ', OLD.ISBN, ' and Storage Location: ', OLD.StorageLocation,
           '\nQuantity: ', OLD.Quantity
          )
    );
END//

-- Trigger for logging delete operations on Citys table
CREATE TRIGGER log_citys_delete
AFTER DELETE ON Citys
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Deleted row with Postal Code: ', OLD.PostalCode,
           '\nCity Name: ', OLD.CityName
          )
    );
END//

-- Trigger for logging delete operations on Countries table
CREATE TRIGGER log_countries_delete
AFTER DELETE ON Countries
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Deleted row with Country Code: ', OLD.CountryCode,
           '\nCity Name: ', OLD.CountryName
          )
    );
END//

-- Trigger for logging delete operations on Logins table
CREATE TRIGGER log_logins_delete
AFTER DELETE ON Logins
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Deleted row with Login ID: ', OLD.LoginID,
           '\nUsername: ', OLD.Username,
           '\nPassword Hash: ', OLD.PasswordHash,
           '\nSalt: ', OLD.Salt
          )
    );
END//

-- Trigger for logging delete operations on Customers table
CREATE TRIGGER log_customers_delete
AFTER DELETE ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Deleted row with Customer ID: ', OLD.CustomerID,
           '\nFirst Name: ', OLD.FirstName,
           '\nLast Name: ', OLD.LastName,
           '\nEmail: ', OLD.Email,
           '\nPhone Number: ', COALESCE(OLD.PhoneNumber, 'N/A'),
           '\nCountryCode: ', OLD.CountryCode,
           '\nRegion: ', COALESCE(OLD.Region, 'N/A'),
           '\nPostal Code: ', OLD.PostalCode,
           '\nStreet Address: ', OLD.StreetAddress,
           '\nLogin ID: ', OLD.LoginID
          )
    );
END//

-- Trigger for logging delete operations on PurchaseLog table
CREATE TRIGGER log_purchaselog_delete
AFTER DELETE ON PurchaseLog
FOR EACH ROW
BEGIN
    INSERT INTO BogredenLog (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Deleted row with Purchase ID: ', OLD.PurchaseID,
           '\nCustomer ID: ', OLD.CustomerID,
           '\nISBN: ', OLD.ISBN,
           '\nPurchase Date: ', OLD.PurchaseDate
          )
    );
END// 





-- Stored Procedures





-- Create a procedure which creates a book
CREATE PROCEDURE CreateBook(
    IN in_book_isbn CHAR(17),
    IN in_book_title VARCHAR(50),
    IN in_book_genre VARCHAR(50),
    IN in_book_release_date DATE,
    IN in_book_page_amount SMALLINT UNSIGNED,
    IN in_author_id INT,
    IN in_price_details_id INT
)
BEGIN
    DECLARE local_book_exists INT;

    -- Check if the book already exists
    SELECT COUNT(*) INTO local_book_exists
    FROM Books 
    WHERE ISBN = in_book_isbn;
    
    -- If the book already exists, return error
    IF local_book_exists > 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ISBN does already exist in Books table';
    ELSE
        
        -- Insert the book into the books table
        INSERT INTO Books(ISBN, Title, Genre, ReleaseDate, PageAmount, AuthorID, PricingDetailID)
        VALUES(in_book_isbn, in_book_title, in_book_genre, in_book_release_date, in_book_page_amount, in_author_id, in_price_details_id);
        
        -- Insert quantity into the Storage table
        CALL AddExistingBookToStorage(in_book_isbn, 1);
    END IF;
END //

CREATE PROCEDURE GetAllBooks()
BEGIN
	SELECT * FROM Books;
END//

CREATE PROCEDURE GetBookByTitle(
	IN in_book_title VARCHAR(50)
)
BEGIN
	SELECT * FROM Books WHERE Title = in_book_title;
END//

CREATE PROCEDURE AddExistingBookToStorage(
	IN in_isbn CHAR(17),
    IN in_quantity SMALLINT UNSIGNED
)
BEGIN
	DECLARE local_book_exists_in_storage INT UNSIGNED DEFAULT 0;
    
	-- Check if ISBN exists in Books table
    DECLARE local_isbn_exists INT UNSIGNED DEFAULT 0;
    SELECT COUNT(*) INTO local_isbn_exists 
    FROM Books 
    WHERE ISBN = in_isbn;
    
    IF local_isbn_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not add book to storage (ISBN does not exist in Books table)';
	ELSE
    
		-- Check if ISBN exists in Storage table
		SELECT COUNT(*) INTO local_book_exists_in_storage 
		FROM Storage 
		WHERE ISBN = in_isbn;
    
		IF local_book_exists_in_storage = 0 THEN
			
            -- Insert new book into Storage table, if it doesn't exists
			INSERT INTO Storage(ISBN, StorageLocation, Quantity)
            VALUES (in_isbn, 'Ringsted Lager', in_quantity);
        ELSE
        
			-- Update quantity of book in Storage table
			UPDATE Storage
			SET Quantity = Quantity + in_quantity
            WHERE ISBN = in_isbn;
		END IF;
    END IF;
END//

CREATE PROCEDURE CreateCustomer(
    IN in_first_name VARCHAR(30),
    IN in_last_name VARCHAR(100),
    IN in_email VARCHAR(255),
    IN in_phone_number VARCHAR(15),
    IN in_country_code VARCHAR(100),
    IN in_region VARCHAR(50),
    IN in_postal_code VARCHAR(15),
    IN in_street_address VARCHAR(255),
    IN in_login_id INT
)
BEGIN

    -- Check if PostalCode exists in Cities table
    DECLARE local_postal_code_exists INT DEFAULT 0;
    SELECT COUNT(*) INTO local_postal_code_exists FROM Citys WHERE PostalCode = in_postal_code;
    
    IF local_postal_code_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not create customer (PostalCode does not exist in Citys table)';
    ELSE
    
        -- Insert into Customers table
        INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, CountryCode, Region, PostalCode, StreetAddress, LoginID)
        VALUES (in_first_name, in_last_name, in_email, in_phone_number, in_country_code, in_region, in_postal_code, in_street_address, in_login_id);
    END IF;
END//

CREATE PROCEDURE DeleteCustomer(
	IN in_customer_id INT
)
BEGIN
	DECLARE local_customer_exists INT UNSIGNED DEFAULT 0;
    DECLARE local_login_id INT;
    
    -- Check if customer exists
    SELECT COUNT(*) INTO local_customer_exists
    FROM Customers
    WHERE CustomerID = in_customer_id;
    
    IF local_customer_exists != 0 THEN
        
        -- Fetch customers loginID, since its needed to delete a login
		SELECT LoginID INTO local_login_id
        FROM Customers
        WHERE CustomerID = in_customer_id;
        
        -- Delete customer purchaselog
        CALL DeleteCustomerPurchaseLog(in_customer_id);
    
		-- Delete a customer by ID
		DELETE FROM Customers
        WHERE CustomerID = in_customer_id;
        
        -- Delete customer login
        CALL DeleteLogin(local_login_id);
    ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not delete customer (CustomerID does not exist in Customers table)';
    END IF;
END//

-- Get a Customer by the LoginID
CREATE PROCEDURE GetCustomerByLoginID(
    IN in_login_id INT
)
BEGIN
    DECLARE local_customer_exists INT UNSIGNED DEFAULT 0;

    -- Check if customer exists with the given LoginID
    SELECT COUNT(*) INTO local_customer_exists
    FROM Customers
    WHERE LoginID = in_login_id;

    -- If customer exists, return customer details
    IF local_customer_exists > 0 THEN
        SELECT * FROM Customers
        WHERE LoginID = in_login_id;
    ELSE
        -- If no customer found, return an empty result set
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not retrieve customer information (LoginID does not exist in Customers table)';
    END IF;
END//

	
-- Create a login using Username, Password and Salt
CREATE PROCEDURE CreateLogin(
	IN in_username VARCHAR(30),
    IN in_hashed_password VARCHAR(1023),
    IN in_salt VARCHAR(255)
)
BEGIN
	
    -- Insert login information into Logins table
	INSERT INTO Logins (Username, PasswordHash, Salt)
    VALUES (in_username, in_hashed_password, in_salt);
END//

-- Update a login information by LoginID using Username, Password and Salt
CREATE PROCEDURE UpdateLogin(
	IN in_login_id INT,
	IN in_new_username VARCHAR(30),
    IN in_new_hashed_password VARCHAR(1023),
    IN in_new_salt VARCHAR(255)
)
BEGIN
	DECLARE local_id_exists INT UNSIGNED DEFAULT 0;
    
    -- Check if LoginID exists in Logins table
    SELECT COUNT(*) INTO local_id_exists
    FROM Logins
    WHERE LoginID = in_login_id;
    
    IF local_id_exists != 0 THEN
		IF in_new_hashed_password IS NOT NULL AND in_new_salt IS NOT NULL THEN
		
			-- Update login by LoginID using new login information
			UPDATE Logins
			SET
				Username = IFNULL(in_new_username, Username),
				PasswordHash = in_new_hashed_password,
				Salt = in_new_salt
			WHERE LoginID = in_login_id;
		ELSE
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not update login (Password or salt is null)';
        END IF;
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not update login (LoginID does not exist in Logins table)';
    END IF;
END//

-- Delete a login by a loginID
CREATE PROCEDURE DeleteLogin(
	IN in_login_id INT
)
BEGIN
	DECLARE local_id_exists INT UNSIGNED DEFAULT 0;
    
    -- Check if LoginID exists in Logins table
    SELECT COUNT(*) INTO local_id_exists
    FROM Logins
    WHERE LoginID = in_login_id;
    
    IF local_id_exists != 0 THEN
    
		-- Delete login from Logins by LoginID
		DELETE FROM Logins
		WHERE LoginID = in_login_id;
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not delete login (LoginID does not exist in Logins table)';
    END IF;
END//

-- Retrieve Login if it exists
CREATE PROCEDURE GetLogin(
    IN in_username VARCHAR(30)
)
BEGIN
    DECLARE local_username_exists INT UNSIGNED DEFAULT 0;
 
	-- Check if username exists in Logins table
    SELECT COUNT(*) INTO local_username_exists
    FROM Logins
    WHERE Username = in_username;
     
    IF local_username_exists != 0 THEN
    
		-- Selects PasswordHash and Salt of the login
		SELECT PasswordHash, Salt
        FROM Logins
        WHERE Username = in_username;
    ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not retrieve login (Username does not exist in Logins table)';
    END IF;
END//

-- Add a purchase from a customer to PurchaseLog table
CREATE PROCEDURE AddPurchase(
	IN in_customer_id INT,
    IN in_isbn CHAR(17)
)
BEGIN
	DECLARE local_customer_exists INT UNSIGNED DEFAULT 0;
    DECLARE local_book_exists INT UNSIGNED DEFAULT 0;
    
	SELECT COUNT(*) INTO local_customer_exists
    FROM Customers
    WHERE CustomerID = in_customer_id;
    
    SELECT COUNT(*) INTO local_book_exists
    FROM Books
    WHERE ISBN = in_isbn;
    
    -- Check if customer exists
    IF local_customer_exists > 0 THEN
		-- Check if book exists
		IF local_book_exists > 0 THEN
        
			-- Insert purchase into PurchaseLog table
			INSERT INTO PurchaseLog(CustomerID, ISBN, PurchaseDate)
			VALUES (in_customer_id, in_isbn, CURDATE());
        ELSE
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not delete purchase log (ISBN does not exist in Books table)';
        END IF;
    ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not delete purchase log (CustomerID does not exist in Customers table)';
    END IF;
END//

-- Remove a purchase from a customer from PurchaseLog table
-- If customer has bought more than one of the book, that purchase is removed as well
CREATE PROCEDURE DeleteCustomerPurchaseByISBN(
    IN in_customer_id INT,
    IN in_isbn CHAR(17)
)
BEGIN
    DECLARE local_purchase_exists INT UNSIGNED DEFAULT 0;

    -- Check if the purchase exists in PurchaseLog table
    SELECT COUNT(*) INTO local_purchase_exists
    FROM PurchaseLog
    WHERE CustomerID = in_customer_id AND ISBN = in_isbn;

    -- If the purchase exists, delete it
    IF local_purchase_exists > 0 THEN
        DELETE FROM PurchaseLog
        WHERE CustomerID = in_customer_id AND ISBN = in_isbn;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not delete purchase log (Purchase does not exist)';
    END IF;
END//

-- Remove all purchases from a customer from PurchaseLog table
CREATE PROCEDURE DeleteCustomerPurchaseLog(
    IN in_customer_id INT
)
BEGIN
    DECLARE local_customer_exists INT UNSIGNED DEFAULT 0;
    DECLARE local_customer_purchase_log_exists INT UNSIGNED DEFAULT 0;

    SELECT COUNT(*) INTO local_customer_exists
    FROM Customers
    WHERE CustomerID = in_customer_id;

    SELECT COUNT(*) INTO local_customer_purchase_log_exists
    FROM PurchaseLog
    WHERE CustomerID = in_customer_id;

	-- Check if the customer exists and the customer has any record in the PurchaseLog table
    IF local_customer_exists > 0 THEN
        IF local_customer_purchase_log_exists > 0 THEN
        
			-- Delete all existing records which has the customer's id from the PurchaseLog table
            DELETE FROM PurchaseLog
            WHERE CustomerID = in_customer_id;
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not delete purchase log (CustomerID does not exist in Customers table)';
    END IF;
END//

-- Create Author in Authors table
CREATE PROCEDURE CreateAuthor(
    IN in_author_first_name VARCHAR(30),
    IN in_author_last_name VARCHAR(100),
    IN in_author_nationality VARCHAR(100),
    IN in_author_birthday DATE,
    IN in_author_date_of_death DATE  -- No default value specified
)
BEGIN
	-- Insert new author in Authors table
	INSERT INTO Authors(FirstName, LastName, Nationality, Birthday, DateOfDeath)
	VALUES(in_author_first_name, in_author_last_name, in_author_nationality, in_author_birthday, in_author_date_of_death);
END//

-- Delete Author from Authors table
CREATE PROCEDURE DeleteAuthor(
    IN in_author_id VARCHAR(30)
)
BEGIN
	DECLARE local_author_exists INT UNSIGNED DEFAULT 0;

	-- Check if price detail exists
    SELECT COUNT(*) INTO local_author_exists
    FROM Authors
    WHERE AuthorID = in_author_id;

	IF local_author_exists > 0 THEN

		-- Delete author in Authors table
		DELETE FROM Authors
        WHERE AuthorID = in_author_id;
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not delete author (AuthorID does not exist in Authors table)';
    END IF;
END//

-- Create price in PriceDetails table
CREATE PROCEDURE CreatePrice(
    IN in_price_purchase DECIMAL(8,2),
    IN in_price_sales DECIMAL(8,2)
)
BEGIN

    -- Check if both prices are non-negative
    IF in_price_purchase >= 0 AND in_price_sales >= 0 THEN
    
        -- Check if both prices are under the max
        IF in_price_purchase < 10000000 AND in_price_sales < 10000000 THEN
        
            -- Insert new price in PriceDetails table
            INSERT INTO PriceDetails(PurchasePrice, SalesPrice)
            VALUES(in_price_purchase, in_price_sales);
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not create price (Sale price or purchase price exceeds maximum)';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not create price (Sale price or purchase price is negative)';
    END IF;
END//

-- Delete Price from PriceDetails table
CREATE PROCEDURE DeletePrice(
	IN in_price_detail_id INT
)
BEGIN
	DECLARE local_price_detail_exists INT UNSIGNED DEFAULT 0;

	-- Check if price detail exists
    SELECT COUNT(*) INTO local_price_detail_exists
    FROM PriceDetails
    WHERE PricingDetailID = in_price_detail_id;

	IF local_price_detail_exists > 0 THEN

		-- Delete price details using PricingDetailID
		DELETE FROM PriceDetails
		WHERE PricingDetailID = in_price_detail_id;
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not delete price (PricingDetailID does not exist in PriceDetails table)';
	END IF;
END//
	
-- Retrieve a customer's purchase log from PurchaseLog table
CREATE PROCEDURE GetPurchaseLogByCustomerID(
    IN in_customer_id INT
)
BEGIN
	DECLARE local_customer_exists INT UNSIGNED DEFAULT 0;

	-- Check if customer exists
    SELECT COUNT(*) INTO local_customer_exists
    FROM Customers
    WHERE CustomerID = in_customer_id;

	IF local_customer_exists > 0 THEN
    
		-- Selects ISBN and Purchase from PurchaseLog
		SELECT ISBN, PurchaseDate FROM PurchaseLog
		WHERE CustomerID = in_customer_id;
	ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not fetch purchase log (CustomerID does not exist in Customers table)';
	END IF;
END//

DELIMITER ;





-- Insert of data just dummy data at the moment




-- Deleta data from Citys just to be sure, that nothing is in the table beore loading data in it
DELETE FROM Citys;

LOAD DATA INFILE 'C:\postalCodes.csv'
INTO TABLE Citys
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(PostalCode, CityName);

LOAD DATA INFILE 'C:\countries.csv'
INTO TABLE Countries
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(CountryCode, CountryName);

-- Create authors as dummy data
CALL CreateAuthor('Hans', 'Christian Andersen', 'Danish', '1805-09-07', '1875-08-04');
CALL CreateAuthor('Karen', 'Blixen', 'Danish', '1885-04-17', '1962-09-07');
CALL CreateAuthor('H.C.', 'Branner', 'Danish', '1903-07-22', '1966-06-30');
CALL CreateAuthor('Henrik', 'Pontoppidan', 'Danish', '1857-07-24', '1943-08-21');
CALL CreateAuthor('Suzanne', 'Brøgger', 'Danish', '1944-11-18', NULL);
CALL CreateAuthor('Jens', 'Christian Grøndahl', 'Danish', '1959-11-09', NULL);
CALL CreateAuthor('Jussi', 'Adler-Olsen', 'Danish', '1950-09-02', NULL);
CALL CreateAuthor('Knud', 'Romer', 'Danish', '1951-08-29', NULL);

-- Create price for books as dummy data
CALL CreatePrice(79.95, 60);
CALL CreatePrice(129.95, 110.95);
CALL CreatePrice(249.95, 200.95);
CALL CreatePrice(179.95, 99.95);
CALL CreatePrice(189.95, 100);
CALL CreatePrice(199.95, 110.95);
CALL CreatePrice(219.95, 189.95);
CALL CreatePrice(219.95, 189.95);
CALL CreatePrice(199.95, 110.95);
CALL CreatePrice(219.95, 189.95);

-- Create books as dummy data
CALL CreateBook('978-87-01-31786-3', 'Den lille Havfrue', 'Eventyr', '1837-12-01', 32, 1, 1);
CALL CreateBook('978-87-05-03509-8', 'Babettes gæstebud', 'Novelle', '1958-04-01', 96, 2, 2);
CALL CreateBook('978-87-23-01534-7', 'Væk Fra Danmark', 'Roman', '1930-09-01', 352, 3, 3);
CALL CreateBook('978-87-00-76352-8', 'Lykke-Per', 'Roman', '1898-09-091', 778, 4, 4);
CALL CreateBook('978-87-28-00129-6', 'Creme Fraiche', 'Roman', '1978-09-01', 223, 5, 5);
CALL CreateBook('978-87-00-93811-9', 'Virginia', 'Roman', '2002-08-01', 200, 6, 6);
CALL CreateBook('978-87-03-04712-1', 'Kvinden i buret', 'Krimi', '2007-06-01', 472, 7, 7);
CALL CreateBook('978-87-02-15554-7', 'Den som blinker er bange for døden', 'Krimi', '2009-10-01', 420, 7, 8);
CALL CreateBook('978-87-03-04694-0', 'Den som blinker er bange for lyset', 'Roman', '2005-06-01', 400, 8, 9);
CALL CreateBook('978-87-78-10285-6', 'Raj Raj Raj', 'Roman', '2019-08-01', 300, 8, 10);

-- Create logins as dummy data
CALL CreateLogin('johndoe', 'password_hash_1', 'salt_1');
CALL CreateLogin('alicesmith', 'password_hash_2', 'salt_2');
CALL CreateLogin('michaeljohnson', 'password_hash_3', 'salt_3');
CALL CreateLogin('emilybrown', 'password_hash_4', 'salt_4');
CALL CreateLogin('danielmartinez', 'password_hash_5', 'salt_5');

-- Create customers as dummy data
CALL CreateCustomer('John', 'Doe', 'john@example.com', '123456789', 'DK', 'Sjælland', '4100', '123 Main St', 1);
CALL CreateCustomer('Alice', 'Smith', 'alice@example.com', '987654321', 'DK', 'Sjælland', '4100', '456 Elm St', 2);
CALL CreateCustomer('Michael', 'Johnson', 'michael@example.com', '111222333', 'DK', 'Sjælland', '4100', '789 Oak St', 3);
CALL CreateCustomer('Emily', 'Brown', 'emily@example.com', '444555666', 'DK', 'Sjælland', '4100', 'Ahorn Allé 1', 4);
CALL CreateCustomer('Daniel', 'Martinez', 'daniel@example.com', '777888999', 'DK', 'Sjælland', '4100', 'Ahone 2', 5);

-- Add purchases to the customers as dummy data
CALL AddPurchase(1, '978-87-01-31786-3');
CALL AddPurchase(4, '978-87-23-01534-7');
CALL AddPurchase(3, '978-87-23-01534-7');
CALL AddPurchase(4, '978-87-00-76352-8');
CALL AddPurchase(5, '978-87-28-00129-6');
CALL AddPurchase(1, '978-87-03-04712-1');
CALL AddPurchase(2, '978-87-01-31786-3');
CALL AddPurchase(3, '978-87-00-93811-9');
CALL AddPurchase(3, '978-87-05-03509-8');
CALL AddPurchase(5, '978-87-02-15554-7');
