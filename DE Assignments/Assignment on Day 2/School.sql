USE School;

-- Create the Student table
CREATE TABLE Student (
    Id INT IDENTITY PRIMARY KEY,
    Name VARCHAR(65) NOT NULL,
    Gender CHAR(1) NULL,
    Age INT NULL,
    Marks INT
);

-- Storing data in table
INSERT INTO Student (Name, Gender, Age, Marks) VALUES ('Alice', 'F', 20, 85);
INSERT INTO Student (Name, Gender, Age, Marks) VALUES ('Bob', 'M', 22, 90);
INSERT INTO Student (Name, Gender, Age, Marks) VALUES ('Charlie', 'M', 23, 70);
INSERT INTO Student (Name, Gender, Age, Marks) VALUES ('Diana', 'F', 21, 95);
INSERT INTO Student (Name, Gender, Age, Marks) VALUES ('Eve', 'F', 22, 88);

-- Update the table
UPDATE Student
SET Marks = 92
WHERE Name = 'Bob';


-- Delete table
DELETE FROM Student
WHERE Name = 'Charlie';
select * from Student;
-- Delete all students with marks below 80
DELETE FROM Student
WHERE Marks < 80;

-- Retrieve specific columns
SELECT Name, Marks
FROM Student;

-- Retrieve records for students with Marks greater than 85
SELECT * FROM Student
WHERE Marks > 85;


-- Retrieve students with Age equal to 22
SELECT * FROM Student
WHERE Age = 22;

-- Filtering Data with IN, DISTINCT, AND, OR, BETWEEN, LIKE, Column & Table Aliases
--IN Clause
SELECT * FROM Student
WHERE Marks IN (85, 90);
--DISTINCT
SELECT DISTINCT Age
FROM Student;
--AND,OR
SELECT * FROM Student
WHERE (Gender = 'F' AND Age > 20) OR (Gender = 'M' AND Marks > 85);
--BETWEEN
SELECT * FROM Student
WHERE Marks BETWEEN 80 AND 95;
--LIKE
SELECT * FROM Student
WHERE Name LIKE 'A%';
-- Use aliases for columns and tables
SELECT S.Name AS StudentName, S.Marks AS Score
FROM Student AS S;

-- Implementing Data Integrity
ALTER TABLE Student
ADD CONSTRAINT chk_Age CHECK (Age > 0 AND Age < 120);

ALTER TABLE Student
ADD CONSTRAINT chk_Marks CHECK (Marks BETWEEN 0 AND 100);
select * from Student;


-- Functions to Customize Result Set
SELECT CONCAT(Name, ' (', Gender, ')') AS StudentInfo, 
       CASE WHEN Marks >= 50 THEN 'Pass' ELSE 'Fail' END AS Status
FROM Student;

-- String Functions
SELECT UPPER(Name) AS NameUpperCase, LEN(Name) AS NameLength, 
       LEFT(Name, 3) AS ShortName
FROM Student;

-- Date Functions
ALTER TABLE Student ADD EnrollmentDate DATE DEFAULT GETDATE();
SELECT Name, EnrollmentDate, DATEDIFF(YEAR, EnrollmentDate, GETDATE()) AS YearsSinceEnrollment
FROM Student;
SELECT * FROM Student WHERE YEAR(EnrollmentDate) = YEAR(GETDATE());

-- Mathematical Functions
SELECT Name, Marks, SQRT(Marks) AS MarksSqrt, 
       ABS(Marks - 80) AS DifferenceFrom80
FROM Student;

-- System Functions
SELECT NEWID() AS UniqueID, SUSER_NAME() AS CurrentUser;
SELECT @@VERSION AS SQLVersion;

-- Summarizing and Grouping Data
SELECT COUNT(*) AS TotalStudents, AVG(Marks) AS AverageMarks, 
       MIN(Marks) AS MinMarks, MAX(Marks) AS MaxMarks
FROM Student;
SELECT Gender, AVG(Marks) AS AverageMarks FROM Student GROUP BY Gender;


-- Filtering Data
SELECT * FROM Student WHERE Marks > 85 AND Age < 25;

-- Total Aggregations
SELECT COUNT(*) AS TotalStudents, AVG(Marks) AS AverageMarks FROM Student;

-- Group By Aggregations
SELECT Gender, COUNT(*) AS NumberOfStudents, AVG(Marks) AS AverageMarks
FROM Student GROUP BY Gender;

-- Order of Execution
SELECT Gender, AVG(Marks) AS AverageMarks FROM Student
WHERE Age >= 20 GROUP BY Gender HAVING AVG(Marks) > 70 ORDER BY AverageMarks DESC;

-- Group & Filter Rules
SELECT Gender, AVG(Marks) AS AverageMarks FROM Student GROUP BY Gender;

-- Filter with Group By and Having
SELECT Gender, AVG(Marks) AS AverageMarks FROM Student GROUP BY Gender HAVING AVG(Marks) > 80;

