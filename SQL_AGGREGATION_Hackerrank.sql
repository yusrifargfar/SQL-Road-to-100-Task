-- Query the Name of any student in STUDENTS who scored higher than 75 Marks. 
-- Order your output by the last three characters of each name. 
-- If two or more students both have names ending in the same last three characters 
-- (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.

SELECT Name FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT(Name, 3), ID ASC;



-- Write a query that prints a list of employee names (i.e.: the name attribute) for employees
-- in Employee having a salary greater than 2000 per month who have been employees for 
-- less than 10 months. Sort your result by ascending employee_id

SELECT name FROM Employee
WHERE salary > 2000 AND months < 10
ORDER BY employee_id ASC;

-- Query a count of the number of cities in CITY having a Population larger than 100,000.

SELECT COUNT(*) FROM CITY
WHERE POPULATION > 100000;

-- Query the total population of all cities in CITY where District is California.

SELECT SUM(POPULATION) FROM CITY
WHERE DISTRICT = 'California';

-- Query the difference between the maximum and minimum populations in CITY.
SELECT MAX(POPULATION) - MIN(POPULATION) 
FROM CITY
;

