USE online_book_store;

DELIMITER //

-- Trigger for logging insert operations on PriceDetails table
CREATE TRIGGER log_pricedetails_insert
AFTER INSERT ON PriceDetails
FOR EACH ROW
BEGIN
    INSERT INTO Bogreden_Log (Stamp, Log)
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
    INSERT INTO Bogreden_Log (Stamp, Log)
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

CREATE TRIGGER log_books_insert
AFTER INSERT ON Books
FOR EACH ROW
BEGIN
    INSERT INTO Bogreden_Log (Stamp, Log)
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

-- Trigger for logging insert operations on BookAuthors table
CREATE TRIGGER log_bookauthors_insert
AFTER INSERT ON BookAuthors
FOR EACH ROW
BEGIN
    INSERT INTO Bogreden_Log (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Inserted row into BookAuthors:',
           '\nAuthor ID: ', NEW.AuthorID,
           '\nISBN: ', NEW.ISBN
          )
    );
END//

-- Trigger for logging insert operations on Storage table
CREATE TRIGGER log_storage_insert
AFTER INSERT ON Storage
FOR EACH ROW
BEGIN
    INSERT INTO Bogreden_Log (Stamp, Log)
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
    INSERT INTO Bogreden_Log (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Inserted row into Citys:',
           '\nPostal Code: ', NEW.PostalCode,
           '\nCity Name: ', NEW.CityName
          )
    );
END//

-- Trigger for logging insert operations on LoginInfo table
CREATE TRIGGER log_logininfo_insert
AFTER INSERT ON LoginInfo
FOR EACH ROW
BEGIN
    INSERT INTO Bogreden_Log (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Inserted row into LoginInfo:',
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
    INSERT INTO Bogreden_Log (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Inserted row into Customers:',
           '\nCustomer ID: ', NEW.CustomerID,
           '\nFirst Name: ', NEW.FirstName,
           '\nLast Name: ', NEW.LastName,
           '\nEmail: ', NEW.Email,
           '\nPhone Number: ', NEW.PhoneNumber,
           '\nCountry: ', NEW.Country,
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
    INSERT INTO Bogreden_Log (Stamp, Log)
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
    INSERT INTO Bogreden_Log (Stamp, Log)
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
    INSERT INTO Bogreden_Log (Stamp, Log)
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

CREATE TRIGGER log_books_update
AFTER UPDATE ON Books
FOR EACH ROW
BEGIN
    INSERT INTO Bogreden_Log (Stamp, Log)
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

-- Trigger for logging update operations on BookAuthors table
CREATE TRIGGER log_bookauthors_update
AFTER UPDATE ON BookAuthors
FOR EACH ROW
BEGIN
    INSERT INTO Bogreden_Log (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Updated row with Author ID: ', OLD.AuthorID, ' and ISBN: ', OLD.ISBN,
           '\nChanges:',
           IF(OLD.AuthorID <> NEW.AuthorID, CONCAT('\nAuthor ID: ', OLD.AuthorID, ' -> ', NEW.AuthorID), ''),
           IF(OLD.ISBN <> NEW.ISBN, CONCAT('\nISBN: ', OLD.ISBN, ' -> ', NEW.ISBN), '')
          )
    );
END//

-- Trigger for logging update operations on Storage table
CREATE TRIGGER log_storage_update
AFTER UPDATE ON Storage
FOR EACH ROW
BEGIN
    INSERT INTO Bogreden_Log (Stamp, Log)
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
    INSERT INTO Bogreden_Log (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Updated row with Postal Code: ', OLD.PostalCode,
           '\nChanges:',
           IF(OLD.CityName <> NEW.CityName, CONCAT('\nCity Name: ', OLD.CityName, ' -> ', NEW.CityName), '')
          )
    );
END//

-- Trigger for logging update operations on LoginInfo table
CREATE TRIGGER log_logininfo_update
AFTER UPDATE ON LoginInfo
FOR EACH ROW
BEGIN
    INSERT INTO Bogreden_Log (Stamp, Log)
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
    INSERT INTO Bogreden_Log (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Updated row with Customer ID: ', OLD.CustomerID,
           '\nChanges:',
           IF(OLD.FirstName <> NEW.FirstName, CONCAT('\nFirst Name: ', OLD.FirstName, ' -> ', NEW.FirstName), ''),
           IF(OLD.LastName <> NEW.LastName, CONCAT('\nLast Name: ', OLD.LastName, ' -> ', NEW.LastName), ''),
           IF(OLD.Email <> NEW.Email, CONCAT('\nEmail: ', OLD.Email, ' -> ', NEW.Email), ''),
           IF(OLD.PhoneNumber <> NEW.PhoneNumber, CONCAT('\nPhone Number: ', OLD.PhoneNumber, ' -> ', NEW.PhoneNumber), ''),
           IF(OLD.Country <> NEW.Country, CONCAT('\nCountry: ', OLD.Country, ' -> ', NEW.Country), ''),
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
    INSERT INTO Bogreden_Log (Stamp, Log)
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
    INSERT INTO Bogreden_Log (Stamp, Log)
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
    INSERT INTO Bogreden_Log (Stamp, Log)
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

CREATE TRIGGER log_books_delete
AFTER DELETE ON Books
FOR EACH ROW
BEGIN
    INSERT INTO Bogreden_Log (Stamp, Log)
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
-- Trigger for logging delete operations on BookAuthors table
CREATE TRIGGER log_bookauthors_delete
AFTER DELETE ON BookAuthors
FOR EACH ROW
BEGIN
    INSERT INTO Bogreden_Log (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Deleted row with Author ID: ', OLD.AuthorID, ' and ISBN: ', OLD.ISBN)
    );
END//

-- Trigger for logging delete operations on Storage table
CREATE TRIGGER log_storage_delete
AFTER DELETE ON Storage
FOR EACH ROW
BEGIN
    INSERT INTO Bogreden_Log (Stamp, Log)
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
    INSERT INTO Bogreden_Log (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Deleted row with Postal Code: ', OLD.PostalCode,
           '\nCity Name: ', OLD.CityName
          )
    );
END//

-- Trigger for logging delete operations on LoginInfo table
CREATE TRIGGER log_logininfo_delete
AFTER DELETE ON LoginInfo
FOR EACH ROW
BEGIN
    INSERT INTO Bogreden_Log (Stamp, Log)
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
    INSERT INTO Bogreden_Log (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Deleted row with Customer ID: ', OLD.CustomerID,
           '\nFirst Name: ', OLD.FirstName,
           '\nLast Name: ', OLD.LastName,
           '\nEmail: ', OLD.Email,
           '\nPhone Number: ', OLD.PhoneNumber,
           '\nCountry: ', OLD.Country,
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
    INSERT INTO Bogreden_Log (Stamp, Log)
    VALUES (NOW(), 
    CONCAT('Deleted row with Purchase ID: ', OLD.PurchaseID,
           '\nCustomer ID: ', OLD.CustomerID,
           '\nISBN: ', OLD.ISBN,
           '\nPurchase Date: ', OLD.PurchaseDate
          )
    );
END// 



DELIMITER ;
