-- Given the CITY and COUNTRY tables, query the sum of the populations of all cities
-- where the CONTINENT is 'Asia'.

-- Note: CITY.CountryCode and COUNTRY.Code are matching key columns.

SELECT SUM(CITY.POPULATION)
FROM CITY
INNER JOIN COUNTRY 
ON CITY.COUNTRYCODE = COUNTRY.CODE
WHERE COUNTRY.CONTINENT = 'Asia';

-- Given the CITY and COUNTRY tables, query the names of all cities where the CONTINENT is 'Africa'.

-- Note: CITY.CountryCode and COUNTRY.Code are matching key columns.

SELECT DISTINCT CITY.NAME FROM CITY
INNER JOIN COUNTRY 
ON CITY.COUNTRYCODE = COUNTRY.CODE 
WHERE COUNTRY.CONTINENT = 'Africa';

-- Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent)
-- and their respective average city populations (CITY.Population) rounded down to
-- the nearest integer.

-- Note: CITY.CountryCode and COUNTRY.Code are matching key columns.

SELECT T2.CONTINENT, FLOOR(AVG(T1.POPULATION))
FROM CITY AS T1
JOIN COUNTRY AS T2 
ON T1.COUNTRYCODE = T2.CODE
GROUP BY T2.CONTINENT;

------- LEVEL UPGRADE TO MEDIUM --------

-- You are given two tables: Students and Grades. 
-- Students contains three columns ID, Name and Marks.
-- Grades contain three column with following data

Grade min_mark max_mark
1       0       9
2       10      19
3       20      29
4       30      39
5       40      49
6       50      59
7       60      69
8       70      79
9       80      89
10      90      100

-- Ketty gives Eve a task to generate a report containing three columns: Name, Grade and Mark. 
-- Ketty doesn't want the NAMES of those students who received a grade lower than 8. 
-- The report must be in descending order by grade -- i.e. higher grades are entered first. 
-- If there is more than one student with the same grade (8-10) assigned to them, 
-- order those particular students by their name alphabetically. Finally, 
-- if the grade is lower than 8, use "NULL" as their name and list them by their grades 
-- in descending order. If there is more than one student with the same grade (1-7) 
-- assigned to them, order those particular students by their marks in ascending order.

-- Write a query to help Eve.

SELECT
    CASE
        WHEN grades.grade < 8 THEN 'NULL'
        ELSE students.name
    END AS Name,
    grades.grade AS Grade,
    students.marks AS Mark
FROM
    students AS students
JOIN
    grades AS grades ON students.marks BETWEEN grades.minmarks AND grades.maxmarks
ORDER BY
grades.grade DESC,
    CASE
        WHEN grades.grade >= 8 THEN students.name
    END ASC,
    CASE
        WHEN grades.grade < 8 THEN students.marks
    END ASC;