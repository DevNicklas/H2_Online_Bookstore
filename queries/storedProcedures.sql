DROP PROCEDURE IF EXISTS GetAllBooks;
DROP PROCEDURE IF EXISTS GetBookByTitle;
DROP PROCEDURE IF EXISTS CreateCustomer;
DROP PROCEDURE IF EXISTS DeleteCustomer;
DROP PROCEDURE IF EXISTS GetCustomerByLoginID;
DROP PROCEDURE IF EXISTS CreateLogin;
DROP PROCEDURE IF EXISTS UpdateLogin;
DROP PROCEDURE IF EXISTS DeleteLogin;
DROP PROCEDURE IF EXISTS GetLogin;
DROP PROCEDURE IF EXISTS AddPurchase;
DROP PROCEDURE IF EXISTS DeleteCustomerPurchaseLog;

DELIMITER //

-- Create Book
CREATE PROCEDURE IF NOT EXISTS CreateBook(
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
    IN in_price_purchase DECIMAL(6,2),
    IN in_price_sales DECIMAL(6,2),
    IN in_book_pricing_detail_id INT
)
BEGIN
    DECLARE local_existing_author_id INT;
    DECLARE local_existing_book_count INT;
    DECLARE local_existing_price_id INT;
    DECLARE local_existing_author_count INT;
    DECLARE local_existing_price_count INT;

    -- Check if the book already exists
    SELECT COUNT(*) INTO local_existing_book_count FROM Books WHERE ISBN = in_book_isbn;
    
    -- If the book already exists, return error
    IF local_existing_book_count > 0 THEN
        SELECT CONCAT('The book with ISBN ', in_book_isbn, ' already exists');
    ELSE
        -- Check if the author already exists
        SELECT COUNT(*) INTO local_existing_author_count
        FROM Authors
        WHERE FirstName = in_book_author_first_name AND LastName = in_book_author_last_name;
        
        -- If author doesn't exist, create new author
        IF local_existing_author_count = 0 THEN
            -- Check if bookAuthorDateOfDeath is null
            IF in_book_author_date_of_death IS NULL THEN
                CALL CreateAuthor(in_book_author_first_name, in_book_author_last_name, in_book_author_nationality, in_book_author_birthday, NULL);
            ELSE
                CALL CreateAuthor(in_book_author_first_name, in_book_author_last_name, in_book_author_nationality, in_book_author_birthday, in_book_author_date_of_Death);
            END IF;
        END IF;

        -- Check if the price details already exist
        SELECT COUNT(*) INTO local_existing_price_count FROM PriceDetails WHERE PurchasePrice = in_price_purchase AND SalesPrice = in_price_sales;
        
        -- If price details don't exist, create new price details
        IF local_existing_price_count = 0 THEN
            INSERT INTO PriceDetails(PurchasePrice, SalesPrice) VALUES (in_price_purchase, in_price_sales);
        END IF;

        -- Get the author ID
        SELECT AuthorID INTO local_existing_author_id
        FROM Authors
        WHERE FirstName = in_book_author_first_name AND LastName = in_book_author_last_name;

        -- Get the price details ID
        SELECT PricingDetailID INTO local_existing_price_id
        FROM PriceDetails
        WHERE PurchasePrice = in_price_purchase AND SalesPrice = in_price_sales;
        
        -- Insert the book using the author's ID and price details ID
        INSERT INTO Books(ISBN, Title, Genre, ReleaseDate, PageAmount, AuthorID, PricingDetailID)
        VALUES(in_book_isbn, in_book_title, in_book_genre, in_book_release_date, in_book_page_amount, local_existing_author_id, local_existing_price_id);
        
        SELECT CONCAT('Book with ISBN ', in_book_isbn, ' created successfully');
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
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LoginID does not exist in LoginInfo table';
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
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LoginID does not exist in LoginInfo table';
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
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username does not exist in LoginInfo table';
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
    
    -- Check if customer and book exists
    IF local_customer_exists != 0 AND local_book_exists != 0 THEN
    
		-- Insert purchase into PurchaseLog table
		INSERT INTO PurchaseLog(CustomerID, ISBN, PurchaseDate)
        VALUES (in_customer_id, in_isbn, CURDATE());
    ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CustomerID or ISBN could not be found';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer does not exist';
    END IF;
END//

-- Create Author
CREATE PROCEDURE IF NOT EXISTS CreateAuthor(
    IN in_author_first_name VARCHAR(30),
    IN in_author_last_name VARCHAR(100),
    IN in_author_nationality VARCHAR(100),
    IN in_author_birthday DATE,
    IN in_author_date_of_death DATE  -- No default value specified
)
BEGIN
    DECLARE local_existing_count INT;
    
    -- Check if author exists
    SELECT COUNT(*) INTO local_existing_count
    FROM Authors
    WHERE FirstName = in_author_first_name AND LastName = in_author_last_name;
    
    IF local_existing_count = 0 THEN
        -- Insert new author
        INSERT INTO Authors(FirstName, LastName, Nationality, Birthday, DateOfDeath)
        VALUES(in_author_first_name, in_author_last_name, in_author_nationality, in_author_birthday, IFNULL(in_author_date_of_death, NULL));
    ELSE
        SELECT 'Forfatteren eksistere allerede';
    END IF;
END//

-- Create Price
CREATE PROCEDURE IF NOT EXISTS CreatePrice(
    IN in_price_purchase DECIMAL(6,2),
    IN in_price_sales DECIMAL(6,2)
)
BEGIN
    DECLARE local_existing_count INT;
    
    -- Check if price details already exist
    SELECT COUNT(*) INTO local_existing_count
    FROM PriceDetails
    WHERE PurchasePrice = in_price_purchase AND SalesPrice = in_price_sales;
    
    IF local_existing_count = 0 THEN
        -- Insert new price details
        INSERT INTO PriceDetails(PurchasePrice, SalesPrice)
        VALUES(in_price_purchase, in_price_sales);
    ELSE
        SELECT 'Price details already exist';
    END IF;
END//
	
-- Retrieve a customer's purchase log from PurchaseLog table

-- To show we meet the goals
CREATE PROCEDURE TestProcedure()
BEGIN
	SELECT * FROM Books;
END//
    
DELIMITER ;

-- Drop TestProcedure because we don't need it, but just want to show we meet the goals
DROP PROCEDURE TestProcedure;
