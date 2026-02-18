
/* *************************************************************
** Add a book with added options for new author, author details,
** group and format
************************************************************* */

-- Add a new type (address type)
/*
INSERT INTO Types (name, note)
VALUES ('Some type name', 'Note about type');
*/
SELECT * FROM Types ORDER BY type;


-- Add a new address
/*
INSERT INTO Addresses (house, appt, street, city, state, zip, note, addrtype)
VALUES ('10191', NULL, 'East West Street', 'Notown', 'FL', 
        '33123', 'Test record...', 1);
*/		
SELECT * FROM Addresses ORDER BY address;

-- Add a new author
/*
INSERT INTO Authors (first, last, web, email, social1, social2, social3, phone, addrid, note)
VALUES ('Psude', 'O''Nym', 'https://www.psudeo.com', 'psuedeo@gmail.com', NULL, NULL, NULL,
		'123-555-1234', 1, 'Test record 2');
*/
SELECT * FROM authors ORDER BY author;

-- Add a new group
/*
INSERT INTO groups (name)
VALUES ('Test group');
*/
SELECT * FROM Groups ORDER BY groupid;

-- Add a new format
/*
INSERT INTO Formats (name, note)
VALUES ('Format name', 'Note about name');
*/
SELECT * FROM Formats ORDER BY formatid;

-- Add a new book
/*
INSERT INTO Books (isbn, title, authorid, pubdate, loanid, groupid, note, formatid)
VALUES ('987-0-6543-2110-1', 'Test Data Vol. 2', 5, '01/01/1972', NULL, 5, 'More test data...', 6)
*/
SELECT * FROM Books ORDER BY book;

-- A test
SELECT  b.Title, a.First, a.Last, b.ISBN, b.Book, f.Name AS Format, f.FormatId, a.Author, 
        g.GroupId, g.Name as Group, a.Web, a.EMail
FROM Books AS b
INNER JOIN Authors AS a ON b.AuthorId = a.Author
LEFT JOIN Formats AS f ON b.FormatId = f.FormatId
LEFT JOIN Groups AS g ON b.GroupId = g.GroupId
WHERE b.authorid IS NOT NULL
ORDER BY b.Title;
