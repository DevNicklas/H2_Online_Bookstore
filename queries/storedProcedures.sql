USE online_book_store;

DROP PROCEDURE IF EXISTS CreateBook;
DROP PROCEDURE IF EXISTS GetAllBooks;
DROP PROCEDURE IF EXISTS GetBookByTitle;
DROP PROCEDURE IF EXISTS AddExistingBookToStorage;
DROP PROCEDURE IF EXISTS CreateCustomer;
DROP PROCEDURE IF EXISTS DeleteCustomer;
DROP PROCEDURE IF EXISTS GetCustomerByLoginID;
DROP PROCEDURE IF EXISTS CreateLogin;
DROP PROCEDURE IF EXISTS UpdateLogin;
DROP PROCEDURE IF EXISTS DeleteLogin;
DROP PROCEDURE IF EXISTS GetLogin;
DROP PROCEDURE IF EXISTS AddPurchase;
DROP PROCEDURE IF EXISTS DeleteCustomerPurchaseLog;
DROP PROCEDURE IF EXISTS CreatePrice;
DROP PROCEDURE IF EXISTS DeletePrice;
DROP PROCEDURE IF EXISTS CreateAuthor;
DROP PROCEDURE IF EXISTS DeleteAuthor;
DROP PROCEDURE IF EXISTS GetPurchaseLogByCustomerID;

DELIMITER //

-- Create a procedure which creates a book
-- The procedure has to create an author and a price as well
CREATE PROCEDURE CreateBook(
    IN in_book_isbn CHAR(17),
    IN in_book_title VARCHAR(50),
    IN in_book_genre VARCHAR(50),
    IN in_book_release_date DATE,
    IN in_book_page_amount SMALLINT UNSIGNED,
    IN in_book_author_first_name VARCHAR(30),
    IN in_book_author_last_name VARCHAR(100),
    IN in_book_author_nationality VARCHAR(100),
    IN in_book_author_birthday DATE,
    IN in_book_author_date_of_death DATE,
    IN in_price_purchase DECIMAL(8,2),
    IN in_price_sales DECIMAL(8,2)
)
BEGIN
    DECLARE local_book_exists INT;
    DECLARE local_author_id INT;
    DECLARE local_price_details_id INT;

    -- Check if the book already exists
    SELECT COUNT(*) INTO local_book_exists
    FROM Books 
    WHERE ISBN = in_book_isbn;
    
    -- If the book already exists, return error
    IF local_book_exists > 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ISBN does already exist in Books table';
    ELSE
    
		-- Create author for book
		CALL CreateAuthor(in_book_author_first_name, in_book_author_last_name, in_book_author_nationality, in_book_author_birthday, in_book_author_date_of_Death);
        SET local_author_id = LAST_INSERT_ID();
        
        -- Add price to PriceDetails table
		CALL CreatePrice(in_price_purchase, in_price_sales);
        SET local_price_details_id = LAST_INSERT_ID();
        
        -- Insert the book using the author's ID and price details ID
        INSERT INTO Books(ISBN, Title, Genre, ReleaseDate, PageAmount, AuthorID, PricingDetailID)
        VALUES(in_book_isbn, in_book_title, in_book_genre, in_book_release_date, in_book_page_amount, local_author_id, local_price_details_id);
        
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ISBN does not exist in Books table';
	ELSE
    
		-- Check if ISBN exists in Storage table
		SELECT COUNT(*) INTO local_isbn_exists 
		FROM Books 
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
    IN in_country VARCHAR(100),
    IN in_region VARCHAR(50),
    IN in_postal_code VARCHAR(15),
    IN in_street_address VARCHAR(255),
    IN in_username VARCHAR(30),
    IN in_password_hash VARCHAR(1023),
    IN in_salt VARCHAR(255)
)
BEGIN
    DECLARE local_login_id INT;

    -- Check if PostalCode exists in Cities table
    DECLARE local_postal_code_exists INT DEFAULT 0;
    SELECT COUNT(*) INTO local_postal_code_exists FROM Citys WHERE PostalCode = in_postal_code;
    
    IF local_postal_code_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PostalCode does not exist in Cities table';
    ELSE
        -- Insert into LoginInfo table
        CALL CreateLogin(in_username, in_password_hash, in_salt);

        -- Get the generated LoginID
        SET local_login_id = LAST_INSERT_ID();

        -- Insert into Customers table
        INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, Country, Region, PostalCode, StreetAddress, LoginID)
        VALUES (in_first_name, in_last_name, in_email, in_phone_number, in_country, in_region, in_postal_code, in_street_address, local_login_id);
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
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CustomerID does not exist in LoginInfo table';
    END IF;
END//

-- Use to get a Customer by the LoginID
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
        SELECT *
        FROM Customers
        WHERE LoginID = in_login_id;
    ELSE
        -- If no customer found, return an empty result set
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No customer found with the provided LoginID';
    END IF;
END//

	
-- Create a login using Username, Password and Salt
CREATE PROCEDURE CreateLogin(
	IN in_username VARCHAR(30),
    IN in_hashed_password VARCHAR(1023),
    IN in_salt VARCHAR(255)
)
BEGIN
	
    -- Insert login information into LoginInfo table
	INSERT INTO LoginInfo (Username, PasswordHash, Salt)
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
    
    -- Check if LoginID exists in LoginInfo table
    SELECT COUNT(*) INTO local_id_exists
    FROM LoginInfo
    WHERE LoginID = in_login_id;
    
    IF local_id_exists != 0 THEN
    
		-- Update login by LoginID using new login information
		UPDATE LoginInfo
        SET
			Username = in_new_username,
            PasswordHash = in_new_hashed_password,
            Salt = in_new_salt
		WHERE LoginID = in_login_id;
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not update login (LoginID does not exist in LoginInfo table)';
    END IF;
END//

-- Delete a login by a loginID
CREATE PROCEDURE DeleteLogin(
	IN in_login_id INT
)
BEGIN
	DECLARE local_id_exists INT UNSIGNED DEFAULT 0;
    
    -- Check if LoginID exists in LoginInfo table
    SELECT COUNT(*) INTO local_id_exists
    FROM LoginInfo
    WHERE LoginID = in_login_id;
    
    IF local_id_exists != 0 THEN
    
		-- Delete login from LoginInfo by LoginID
		DELETE FROM LoginInfo
		WHERE LoginID = in_login_id;
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not delete login (LoginID does not exist in LoginInfo table)';
    END IF;
END//

-- Retrieve Login if it exists
CREATE PROCEDURE GetLogin(
    IN in_username VARCHAR(30)
)
BEGIN
    DECLARE local_username_exists INT UNSIGNED DEFAULT 0;
 
	-- Check if username exists in LoginInfo table
    SELECT COUNT(*) INTO local_username_exists
    FROM LoginInfo
    WHERE Username = in_username;
     
    IF local_username_exists != 0 THEN
    
		-- Selects PasswordHash and Salt of the login
		SELECT PasswordHash, Salt
        FROM LoginInfo
        WHERE Username = in_username;
    ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not retrieve login (Username does not exist in LoginInfo table)';
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
CREATE PROCEDURE IF NOT EXISTS GetPurchaseLogByCustomerID(
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
		SELECT ISBN, PurchaseDate
		FROM PurchaseLog
		WHERE CustomerID = in_customer_id;
	ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Can not fetch purchase log (CustomerID does not exist in Customers table)';
	END IF;
END//

-- To show we meet the goals
CREATE PROCEDURE TestProcedure()
BEGIN
	SELECT * FROM Books;
END//
    
DELIMITER ;

-- Drop TestProcedure because we don't need it, but just want to show we meet the goals
DROP PROCEDURE TestProcedure;
