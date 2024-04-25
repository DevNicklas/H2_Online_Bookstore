USE online_book_store;

LOAD DATA INFILE 'C:/Users/zbc23jakl/Desktop/XAMPP/mysql/data/Danske_postnumre.csv'
INTO TABLE Citys
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(PostalCode, CityName);

CALL CreateBook('978-87-01-31786-3', 'Den lille Havfrue', 'Eventyr', '1837-12-01', 32, 'Hans', 'Christian Andersen', 'Danish', '1805-09-07', '1875-08-04', 79.95, 60, 1);
CALL CreateBook('978-87-05-03509-8', 'Babettes gæstebud', 'Novelle', '1958-04-01', 96, 'Karen', 'Blixen', 'Danish', '1885-04-17', '1962-09-07', 129.95, 110.95, 2);
CALL CreateBook('978-87-23-01534-7', 'Væk Fra Danmark', 'Roman', '1930-09-01', 352, 'H.C.', 'Branner', 'Danish', '1903-07-22', '1966-06-30', 249.95, 200.95, 3);
CALL CreateBook('978-87-00-76352-8', 'Lykke-Per', 'Roman', '1898-09-091', 778, 'Henrik', 'Pontoppidan', 'Danish', '1857-07-24', '1943-08-21', 179.95, 99.95, 6);
CALL CreateBook('978-87-28-00129-6', 'Creme Fraiche', 'Roman', '1978-09-01', 223, 'Suzanne', 'Brøgger', 'Danish', '1944-11-18', NULL, 189.95, 100, 7);
CALL CreateBook('978-87-00-93811-9', 'Virginia', 'Roman', '2002-08-01', 200, 'Jens', 'Christian Grøndahl', 'Danish', '1959-11-09', NULL, 199.95, 110.95, 8);
CALL CreateBook('978-87-03-04712-1', 'Kvinden i buret', 'Krimi', '2007-06-01', 472, 'Jussi', 'Adler-Olsen', 'Danish', '1950-09-02', NULL, 219.95, 189.95, 9);
CALL CreateBook('978-87-02-15554-7', 'Den som blinker er bange for døden', 'Krimi', '2009-10-01', 420, 'Jussi', 'Adler-Olsen', 'Danish', '1950-09-02', NULL, 219.95, 189.95, 10);
CALL CreateBook('978-87-03-04694-0', 'Den som blinker er bange for lyset', 'Roman', '2005-06-01', 400, 'Knud', 'Romer', 'Danish', '1951-08-29', NULL, 199.95, 110.95, 10);
CALL CreateBook('978-87-78-10285-6', 'Raj Raj Raj', 'Roman', '2019-08-01', 300, 'Knud', 'Romer', 'Danish', '1951-08-29', NULL, 219.95, 189.95, 11);
