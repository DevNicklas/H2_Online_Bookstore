DELIMITER //

CREATE PROCEDURE IF NOT EXISTS GetAllBooks()
BEGIN
	SELECT * FROM Books;
END//

CREATE PROCEDURE IF NOT EXISTS GetBookByTitle(
	IN bookTitle VARCHAR(50)
)
BEGIN
	SELECT * FROM Books WHERE Title = bookTitle;
END//

CREATE PROCEDURE IF NOT EXISTS CreateCustomer(
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
        INSERT INTO LoginInfo (Username, PasswordHash, Salt)
        VALUES (p_Username, p_PasswordHash, p_Salt);

        -- Get the generated LoginID
        SET v_LoginID = LAST_INSERT_ID();

        -- Insert into Customers table
        INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, Country, Region, PostalCode, StreetAddress, LoginID)
        VALUES (p_FirstName, p_LastName, p_Email, p_PhoneNumber, p_Country, p_Region, p_PostalCode, p_StreetAddress, v_LoginID);
    END IF;
END//

-- Retrieve Login if it exists
CREATE PROCEDURE IF NOT EXISTS GetLoginInfo(
    IN inUsername VARCHAR(30),
    OUT outExists BOOLEAN,
    OUT outHashedPassword VARCHAR(1023),
    OUT outSalt VARCHAR(255)
)
BEGIN
    DECLARE usernameCount INT UNSIGNED;
 
    SELECT COUNT(*) INTO usernameCount
    FROM LoginInfo
    WHERE Username = inUsername;
     
    IF usernameCount > 0 THEN
        SELECT PasswordHash, Salt INTO outHashedPassword, outSalt
        FROM LoginInfo
        WHERE Username = inUsername;
        SET outExists = TRUE;
    ELSE
        SET outExists = FALSE;
    END IF;
END //

-- To show we meet the goals

CREATE PROCEDURE TestProcedure()
BEGIN
	SELECT * FROM Books;
END//
    
DELIMITER ;

-- Drop TestProcedure because we don't need it, but just want to show we meet the goals
DROP PROCEDURE TestProcedure;
