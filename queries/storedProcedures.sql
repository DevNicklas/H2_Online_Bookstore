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

-- To show we meet the goals

CREATE PROCEDURE TestProcedure()
BEGIN
	SELECT * FROM Books;
END//
    
-- You can't really edit/alter a procedure, so if you want to change it, you need to drop it, and create the new procedure

DROP PROCEDURE IF EXISTS TestProcedure()

CREATE PROCEDURE TestProcedure()
BEGIN
	SELECT Title FROM Books;
END//
    
DROP PROCEDURE TestProcedure()
    
DELIMITER ;