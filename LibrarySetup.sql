/* ********************************************************************
** Create the Library database and do initial table, indexes and data
** Setup
******************************************************************** */

Database: library

DROP DATABASE IF EXISTS library;

CREATE DATABASE library
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- Types (address type)

DROP TABLE IF EXISTS Types 

CREATE TABLE Types (
        Name    varchar(255) NULL,
        Note    varchar(128) NULL,
        Type    SERIAL PRIMARY KEY
);

INSERT INTO Types 
VALUES  ('Author', 'Author address information'),
        ('Loaned', 'Address of person who borrowed media')

CREATE INDEX ix_name ON Types (Name);

SELECT * FROM Types;

-- Addresses

DROP TABLE IF EXISTS addresses;

CREATE TABLE addresses (
	House	varchar(8) NULL,
	Appt	varchar(8) NULL,
	Street	varchar(100) NULL,
	City	varchar(50) NULL,
	State	varchar(2) NULL,
	Zip	varchar(10) NULL,
	Note	varchar(128) NULL,
    AddrType bigint NULL REFERENCES Types (Type),
    Address SERIAL PRIMARY KEY
);

INSERT INTO Addresses
VALUES ('1091', NULL, 'East West Street', 'Notown', 'FL', 
        '33123', 'Test record...', 1);

SELECT * FROM Addresses;

-- Authors

DROP TABLE IF EXISTS Authors; 

CREATE TABLE Authors (
	First	varchar(50),
	Last	varchar(50),
	Web	varchar(255) NULL,
	EMail	varchar(255) NULL,
	Social1	varchar(255) NULL,
	Social2	varchar(255) NULL,
	Social3 varchar(255) NULL,
	Phone	varchar(20) NULL,
	AddrId	bigint NULL REFERENCES Addresses (Address),
	Note	varchar(255) NULL,
    Author	SERIAL PRIMARY KEY
);

CREATE INDEX ix_author ON Authors (Last, First); 

INSERT INTO Authors
VALUES  ('John', 'Scalzi', 'https://whatever.scalzi.com/',
         'john@scalzi.com', NULL, NULL, NULL, NULL, NULL, 
         'Old Man''s War'),
        ('Ken O.', 'Burtch', NULL, NULL, NULL, NULL, NULL, 
         NULL, NULL, 'Bash stuff'),
        ('Irma', 'Fake', 'https://www.psudeo.nym', 
         'floof@psudeo.nym', NULL, NULL, NULL, NULL, 1, 
         'Bash stuff');

SELECT * FROM Authors;         

-- Groups

DROP TABLE IF EXISTS Groups;

CREATE TABLE Groups (
	Name	varchar(255) NOT NULL,
    GroupId SERIAL PRIMARY KEY
);

INSERT INTO Groups
VALUES ('Old Man''s War'),
       ('Tech - Linux'),
       ('Test Data');

SELECT * FROM Groups;

-- Loans

DROP TABLE IF EXISTS Loans

CREATE TABLE Loans (
        First   varchar(50) NULL,
        Last    varchar(50) NULL,
        Phone   varchar(20) NULL,
        Note    varchar(255) NULL,
        Loaned  date NULL,
        AddrId  bigint REFERENCES Addresses (Address),
        Loan    SERIAL PRIMARY KEY
);

CREATE INDEX idx_loans ON Loans (Last, First)

SELECT * FROM Loans

-- Books

DROP TABLE IF EXISTS Books;

CREATE TABLE Books (
	ISBN	varchar(25) NULL,
	Title	varchar(50) NULL,
	AuthorId bigint REFERENCES Authors (Author) NULL,
	PubDate	date,
	LoanId	bigint REFERENCES Loans (Loan) NULL,
	GroupId	bigint REFERENCES Groups (GroupId) NULL,
	Note	varchar(255) NULL,
	Book    SERIAL PRIMARY KEY
);

CREATE INDEX ix_title ON Books (Title);

INSERT INTO Books 
VALUES ('978-0-7653-4827-2', 'Old Man''s War', 1, '1/1/2005',
        NULL, 1, 'Fun with John and Jane Perry.'),
        ('0-672-32642-6', 'Linux Shell Scripting With Bash',
         NULL, '2/1/2004', NULL, NULL, '#!/bin/bash'),
        ('978-0-7653-5406-8', 'The Ghost Brigades', 1, '1/1/2006',
         NULL, 1, 'More fun with John and Jane Perry.'),
        ('987-0-6543-2109-8', 'Test Data Vol. 1', 3, '1/1/2026', 
         NULL, 3, 'Some Test Data.');

UPDATE Books SET GroupID = 2 WHERE Book = 2;
UPDATE Books Set AuthorId = 2 WHERE Book = 2;

SELECT * FROM Books;

-- Test and validations

SELECT * FROM Groups;
SELECT * FROM Books ORDER BY Title;
SELECT * FROM Authors ORDER BY Last, First;
SELECT * FROM Groups ORDER BY Name;
SELECT * FROM Addresses ORDER BY Address;
 
--Make sure we can join on the authors and groups table
SELECT  b.Title, a.First, a.Last, b.ISBN, b.Book, a.Author, 
        g.GroupId, g.Name as Group, a.Web, a.EMail
FROM Books AS b
INNER JOIN Authors AS a ON b.AuthorId = a.Author
LEFT JOIN Groups AS g ON b.GroupId = g.GroupId
WHERE b.authorid IS NOT NULL
ORDER BY b.Title;

--List authors and include address info if present
SELECT a.First, a.Last, g.*
FROM Authors AS a
LEFT JOIN Addresses AS g ON a.AddrId = g.Address
ORDER BY a.Last