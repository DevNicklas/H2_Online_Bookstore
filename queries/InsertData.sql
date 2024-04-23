USE online_book_store;

LOAD DATA INFILE 'C:/Users/zbc23jakl/Desktop/XAMPP/mysql/data/Danske_postnumre.csv'
INTO TABLE Citys
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(PostalCode, CityName);

SELECT * FROM Citys