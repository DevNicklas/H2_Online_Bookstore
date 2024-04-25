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

CREATE PROCEDURE CreateCustomer(
    IN p_FirstName VARCHAR(30),
    IN p_LastName VARCHAR(100),
    IN p_Email VARCHAR(255),
    IN p_PhoneNumber VARCHAR(15),
    IN p_Country VARCHAR(100),
    IN p_Region VARCHAR(50),
    IN p_PostalCode VARCHAR(15),
    IN p_StreetAddress VARCHAR(255),
    IN p_Username VARCHAR(30),
    IN p_PasswordHash VARCHAR(1023),
    IN p_Salt VARCHAR(255)
)
BEGIN
    DECLARE v_LoginID INT;

    -- Check if PostalCode exists in Cities table
    DECLARE v_Exists INT DEFAULT 0;
    SELECT COUNT(*) INTO v_Exists FROM Citys WHERE PostalCode = p_PostalCode;
    
    IF v_Exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PostalCode does not exist in Cities table';
    ELSE
        -- Insert into LoginInfo table
        CALL CreateLogin(p_Username, p_PasswordHash, p_Salt);

        -- Get the generated LoginID
        SET v_LoginID = LAST_INSERT_ID();

        -- Insert into Customers table
        INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, Country, Region, PostalCode, StreetAddress, LoginID)
        VALUES (p_FirstName, p_LastName, p_Email, p_PhoneNumber, p_Country, p_Region, p_PostalCode, p_StreetAddress, v_LoginID);
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

CREATE PROCEDURE GetCustomerByLoginID(
    IN p_LoginID INT
)
BEGIN
    DECLARE customerExists INT UNSIGNED DEFAULT 0;

    -- Check if customer exists with the given LoginID
    SELECT COUNT(*) INTO customerExists
    FROM Customers
    WHERE LoginID = p_LoginID;

    -- If customer exists, return customer details
    IF customerExists > 0 THEN
        SELECT *
        FROM Customers
        WHERE LoginID = p_LoginID;
    ELSE
        -- If no customer found, return an empty result set
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No customer found with the provided LoginID';
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

SELECT * FROM Customers;
SELECT * FROM PurchaseLog;
SELECT * FROM LoginInfo;
SELECT * FROM Books;

CALL AddPurchase(3, '978-87-28-00129-6');
-- CALL RemoveCustomerPurchaseLog(1);
-- CALL CreateLogin('per', '421', 'ma');
-- CALL GetLogin('nick');
CALL DeleteLogin(2);
CALL CreateCustomer('Peter', 'Gustavsen', 'testmail', '+45 22222222', 'Denmark', 'Sjælland', '4100', 'Ahorn Alle 3', 'peter', 'ok', 'fedtsalt');
CALL DeleteCustomer(3);
