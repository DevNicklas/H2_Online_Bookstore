DROP PROCEDURE GetAllBooks;
DROP PROCEDURE GetBookByTitle;
DROP PROCEDURE CreateCustomer;
DROP PROCEDURE DeleteCustomer;
DROP PROCEDURE CreateLogin;
DROP PROCEDURE UpdateLogin;
DROP PROCEDURE DeleteLogin;
DROP PROCEDURE GetLogin;
DROP PROCEDURE AddPurchase;
DROP PROCEDURE DeleteCustomerPurchaseLog;

DELIMITER //

CREATE PROCEDURE GetAllBooks()
BEGIN
	SELECT * FROM Books;
END//

CREATE PROCEDURE GetBookByTitle(
	IN bookTitle VARCHAR(50)
)
BEGIN
	SELECT * FROM Books WHERE Title = bookTitle;
END//


CREATE PROCEDURE GetCustomerByLoginID(
    IN local_LoginID INT
)
BEGIN
    DECLARE customerExists INT UNSIGNED DEFAULT 0;

    -- Check if customer exists with the given LoginID
    SELECT COUNT(*) INTO customerExists
    FROM Customers
    WHERE LoginID = local_LoginID;

    -- If customer exists, return customer details
    IF customerExists > 0 THEN
        SELECT *
        FROM Customers
        WHERE LoginID = local_LoginID;
    ELSE
        -- If no customer found, return an empty result set
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No customer found with the provided LoginID';
    END IF;
END//


CREATE PROCEDURE CreateCustomer(
    IN local_FirstName VARCHAR(30),
    IN local_LastName VARCHAR(100),
    IN local_Email VARCHAR(255),
    IN local_PhoneNumber VARCHAR(15),
    IN local_Country VARCHAR(100),
    IN local_Region VARCHAR(50),
    IN local_PostalCode VARCHAR(15),
    IN local_StreetAddress VARCHAR(255),
    IN local_Username VARCHAR(30),
    IN local_PasswordHash VARCHAR(1023),
    IN local_Salt VARCHAR(255)
)
BEGIN
    DECLARE v_LoginID INT;

    -- Check if PostalCode exists in Cities table
    DECLARE v_Exists INT DEFAULT 0;
    SELECT COUNT(*) INTO v_Exists FROM Citys WHERE PostalCode = local_PostalCode;
    
    IF v_Exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PostalCode does not exist in Cities table';
    ELSE
        -- Insert into LoginInfo table
        CALL CreateLogin(local_Username, local_PasswordHash, local_Salt);

        -- Get the generated LoginID
        SET v_LoginID = LAST_INSERT_ID();

        -- Insert into Customers table
        INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, Country, Region, PostalCode, StreetAddress, LoginID)
        VALUES (local_FirstName, local_LastName, local_Email, local_PhoneNumber, local_Country, local_Region, local_PostalCode, local_StreetAddress, v_LoginID);
    END IF;
END//

CREATE PROCEDURE DeleteCustomer(
	IN inCustomerID INT
)
BEGIN
	DECLARE customerExists INT UNSIGNED DEFAULT 0;
    DECLARE loginID INT;
    
    SELECT COUNT(*) INTO customerExists
    FROM Customers
    WHERE CustomerID = inCustomerID;
    
    IF customerExists != 0 THEN
        
		SELECT LoginID INTO loginID
        FROM Customers
        WHERE CustomerID = inCustomerID;
        
        CALL DeleteLogin(loginID);
        CALL DeleteCustomerPurchaseLog(inCustomerID);
    
		-- Delete a customer by ID
		DELETE FROM Customers
        WHERE CustomerID = inCustomerID;
    ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CustomerID does not exist in LoginInfo table';
    END IF;
END//

-- Create a login using Username, Password and Salt
CREATE PROCEDURE CreateLogin(
	IN inUsername VARCHAR(30),
    IN inPasswordHash VARCHAR(1023),
    IN inSalt VARCHAR(255)
)
BEGIN
	
    -- Insert login information into LoginInfo table
	INSERT INTO LoginInfo (Username, PasswordHash, Salt)
    VALUES (inUsername, inPasswordHash, inSalt);
END//

-- Update a login information by LoginID using Username, Password and Salt
CREATE PROCEDURE UpdateLogin(
	IN inLoginID INT,
	IN inNewUsername VARCHAR(30),
    IN inNewPasswordHash VARCHAR(1023),
    IN inNewSalt VARCHAR(255)
)
BEGIN
	DECLARE idExists INT UNSIGNED DEFAULT 0;
    
    -- Check if LoginID exists in LoginInfo table
    SELECT COUNT(*) INTO idExists
    FROM LoginInfo
    WHERE LoginID = inLoginID;
    
    IF idExists != 0 THEN
    
		-- Update login by LoginID using new login information
		UPDATE LoginInfo
        SET
			Username = inNewUsername,
            PasswordHash = inNewPasswordHash,
            Salt = inNewSalt
		WHERE LoginID = inLogidIN;
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LoginID does not exist in LoginInfo table';
    END IF;
END//

-- Delete a login by a loginID
CREATE PROCEDURE DeleteLogin(
	IN inLoginID INT
)
BEGIN
	DECLARE idExists INT UNSIGNED DEFAULT 0;
    
    -- Check if LoginID exists in LoginInfo table
    SELECT COUNT(*) INTO idExists
    FROM LoginInfo
    WHERE LoginID = inLoginID;
    
    IF idExists != 0 THEN
    
		-- Delete login from LoginInfo by LoginID
		DELETE FROM LoginInfo
		WHERE LoginID = inLoginID;
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LoginID does not exist in LoginInfo table';
    END IF;
END//

-- Retrieve Login if it exists
CREATE PROCEDURE GetLogin(
    IN inUsername VARCHAR(30)
)
BEGIN
    DECLARE usernameExists INT UNSIGNED DEFAULT 0;
 
	-- Check if username exists in LoginInfo table
    SELECT COUNT(*) INTO usernameExists
    FROM LoginInfo
    WHERE Username = inUsername;
     
    IF usernameExists != 0 THEN
    
		-- Selects PasswordHash and Salt of the login
		SELECT PasswordHash, Salt
        FROM LoginInfo
        WHERE Username = inUsername;
    ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username does not exist in LoginInfo table';
    END IF;
END//

-- Add a purchase from a customer to PurchaseLog table
CREATE PROCEDURE AddPurchase(
	IN inCustomerID INT,
    IN inISBN CHAR(17)
)
BEGIN
	DECLARE customerExists INT UNSIGNED DEFAULT 0;
    DECLARE bookExists INT UNSIGNED DEFAULT 0;
    
	SELECT COUNT(*) INTO customerExists
    FROM Customers
    WHERE CustomerID = inCustomerID;
    
    SELECT COUNT(*) INTO bookExists
    FROM Books
    WHERE ISBN = inISBN;
    
    IF customerExists != 0 AND bookExists != 0 THEN
		INSERT INTO PurchaseLog(CustomerID, ISBN, PurchaseDate)
        VALUES (inCustomerID, inISBN, CURDATE());
    ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CustomerID or ISBN could not be found';
    END IF;
END//

-- Remove a purchase from a customer from PurchaseLog table

-- Remove all purchases from a customer from PurchaseLog table
CREATE PROCEDURE DeleteCustomerPurchaseLog(
    IN inCustomerID INT
)
BEGIN
    DECLARE customerExists INT UNSIGNED DEFAULT 0;
    DECLARE customerPurchaseLogExists INT UNSIGNED DEFAULT 0;

    SELECT COUNT(*) INTO customerExists
    FROM Customers
    WHERE CustomerID = inCustomerID;

    SELECT COUNT(*) INTO customerPurchaseLogExists
    FROM PurchaseLog
    WHERE CustomerID = inCustomerID;

	-- Check if the customer exists and the customer has any record in the PurchaseLog table
    IF customerExists > 0 THEN
        IF customerPurchaseLogExists > 0 THEN
        
			-- Delete all existing records which has the customer's id from the PurchaseLog table
            DELETE FROM PurchaseLog
            WHERE CustomerID = inCustomerID;
		ELSE
			SELECT 'Customer does not have a purchase log';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer does not exist';
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
CALL GetCustomerByLoginID(2);
SELECT * FROM Customers;
SELECT * FROM PurchaseLog;
SELECT * FROM LoginInfo;
SELECT * FROM Books;

CALL AddPurchase(3, '978-87-28-00129-6');
-- CALL RemoveCustomerPurchaseLog(1);
-- CALL CreateLogin('per', '421', 'ma');
-- CALL GetLogin('nick');
CALL DeleteLogin(2);
CALL CreateCustomer('1', 'Gustavsen', 'testmail', '+45 22222222', 'Denmark', null, '4100', 'Ahorn Alle 3', 'peter', 'ok', 'fedtsalt');
CALL DeleteCustomer(3);
