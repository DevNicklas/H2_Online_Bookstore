USE online_book_store;

LOAD DATA INFILE 'C:\postalCodes.csv'
INTO TABLE Citys
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(PostalCode, CityName);

-- Creats book for test
CALL CreateBook('978-87-01-31786-3', 'Den lille Havfrue', 'Eventyr', '1837-12-01', 32, 'Hans', 'Christian Andersen', 'Danish', '1805-09-07', '1875-08-04', 79.95, 60);
CALL CreateBook('978-87-05-03509-8', 'Babettes gæstebud', 'Novelle', '1958-04-01', 96, 'Karen', 'Blixen', 'Danish', '1885-04-17', '1962-09-07', 129.95, 110.95);
CALL CreateBook('978-87-23-01534-7', 'Væk Fra Danmark', 'Roman', '1930-09-01', 352, 'H.C.', 'Branner', 'Danish', '1903-07-22', '1966-06-30', 249.95, 200.95);
CALL CreateBook('978-87-00-76352-8', 'Lykke-Per', 'Roman', '1898-09-091', 778, 'Henrik', 'Pontoppidan', 'Danish', '1857-07-24', '1943-08-21', 179.95, 99.95);
CALL CreateBook('978-87-28-00129-6', 'Creme Fraiche', 'Roman', '1978-09-01', 223, 'Suzanne', 'Brøgger', 'Danish', '1944-11-18', NULL, 189.95, 100);
CALL CreateBook('978-87-00-93811-9', 'Virginia', 'Roman', '2002-08-01', 200, 'Jens', 'Christian Grøndahl', 'Danish', '1959-11-09', NULL, 199.95, 110.95);
CALL CreateBook('978-87-03-04712-1', 'Kvinden i buret', 'Krimi', '2007-06-01', 472, 'Jussi', 'Adler-Olsen', 'Danish', '1950-09-02', NULL, 219.95, 189.95);
CALL CreateBook('978-87-02-15554-7', 'Den som blinker er bange for døden', 'Krimi', '2009-10-01', 420, 'Jussi', 'Adler-Olsen', 'Danish', '1950-09-02', NULL, 219.95, 189.95);
CALL CreateBook('978-87-03-04694-0', 'Den som blinker er bange for lyset', 'Roman', '2005-06-01', 400, 'Knud', 'Romer', 'Danish', '1951-08-29', NULL, 199.95, 110.95);
CALL CreateBook('978-87-78-10285-6', 'Raj Raj Raj', 'Roman', '2019-08-01', 300, 'Knud', 'Romer', 'Danish', '1951-08-29', NULL, 219.95, 189.95);

-- Creats customers for test
CALL CreateCustomer('John', 'Doe', 'john@example.com', '123456789', 'Danmark', 'Sjæland', '4100', '123 Main St', 'johndoe', 'password_hash_1', 'salt_1');
CALL CreateCustomer('Alice', 'Smith', 'alice@example.com', '987654321', 'Danmark', 'Sjæland', '4100', '456 Elm St', 'alicesmith', 'password_hash_2', 'salt_2');
CALL CreateCustomer('Michael', 'Johnson', 'michael@example.com', '111222333', 'Danmark', 'Sjæland', '4100', '789 Oak St', 'michaeljohnson', 'password_hash_3', 'salt_3');
CALL CreateCustomer('Emily', 'Brown', 'emily@example.com', '444555666', 'Danmark', 'Sjæland', '4100', '1ahorn alle 1', 'emilybrown', 'password_hash_4', 'salt_4');
CALL CreateCustomer('Daniel', 'Martinez', 'daniel@example.com', '777888999', 'Danmark', 'Sjæland', '4100', 'Ahone ', 'danielmartinez', 'password_hash_5', 'salt_5');
CALL CreateCustomer('Sophia', 'Garcia', 'sophia@example.com', '222333444', 'Danmark', 'Sjæland', '4100', 'ahorn alle 2', 'sophiagarcia', 'password_hash_6', 'salt_6');
CALL CreateCustomer('William', 'Lopez', 'william@example.com', '555666777', 'Danmark', 'Sjæland', '4100', '404 Cedar St', 'williamlopez', 'password_hash_7', 'salt_7');
CALL CreateCustomer('Olivia', 'Wilson', 'olivia@example.com', '888999000', 'Danmark', 'Sjæland', '4100', 'ahorn alle 3', 'oliviawilson', 'password_hash_8', 'salt_8');
CALL CreateCustomer('James', 'Anderson', 'james@example.com', '333444555', 'Danmark', 'Sjæland', '4100', '606 Oak St', 'jamesanderson', 'password_hash_9', 'salt_9');
CALL CreateCustomer('Emma', 'Taylor', 'emma@example.com', '000111222', 'Danmark', 'Sjæland', '4100', '707 Pine St', 'emmataylor', 'password_hash_10', 'salt_10');

-- Addes some Purchases to the New Customers
CALL AddPurchase(1, '978-87-01-31786-3');
CALL AddPurchase(2, '978-87-05-03509-8');
CALL AddPurchase(3, '978-87-23-01534-7');
CALL AddPurchase(4, '978-87-00-76352-8');
CALL AddPurchase(5, '978-87-28-00129-6');
CALL AddPurchase(6, '978-87-00-93811-9');
CALL AddPurchase(7, '978-87-03-04712-1');
CALL AddPurchase(8, '978-87-02-15554-7');
CALL AddPurchase(9, '978-87-03-04694-0');
CALL AddPurchase(10, '978-87-78-10285-6');
CALL AddPurchase(1, '978-87-03-04712-1');
CALL AddPurchase(2, '978-87-01-31786-3');
CALL AddPurchase(3, '978-87-00-93811-9');
CALL AddPurchase(4, '978-87-05-03509-8');
CALL AddPurchase(5, '978-87-02-15554-7');
CALL AddPurchase(6, '978-87-00-76352-8');
CALL AddPurchase(7, '978-87-03-04694-0');
CALL AddPurchase(8, '978-87-78-10285-6');
CALL AddPurchase(9, '978-87-23-01534-7');
CALL AddPurchase(10, '978-87-28-00129-6');

SELECT * FROM PriceDetails;
SELECT * FROM Authors;
SELECT * FROM Books;
SELECT * FROM Storage;
SELECT * FROM Citys;
SELECT * FROM LoginInfo;
SELECT * FROM Customers;
SELECT * FROM PurchaseLog;
SELECT * FROM BogredenLog;

CALL UpdateLogin(12, 'rawr', 'hej', 'virkelig');
