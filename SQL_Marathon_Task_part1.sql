-- Task 1
-- Write a query to calculate the total annual payroll (sum of SALARY) and the total headcount 
-- (COUNT of employees) for every distinct REGION_NAME. Only include regions that have more 
-- than 10 employees.
SELECT 
    T5.REGION_NAME, 
    SUM(T1.SALARY) AS TOTAL_SALARY,
    COUNT(T1.EMPLOYEE_ID) AS TOTAL_EMPLOYEE
FROM 
    HR.EMPLOYEES T1
INNER JOIN HR.DEPARTMENTS T2
    ON T1.DEPARTMENT_ID = T2.DEPARTMENT_ID
INNER JOIN HR.LOCATIONS T3
    ON T2.LOCATION_ID = T3.LOCATION_ID
INNER JOIN HR.COUNTRIES T4
    ON T3.COUNTRY_ID = T4.COUNTRY_ID
INNER JOIN HR.REGIONS T5
    ON T4.REGION_ID = T5.REGION_ID
HAVING COUNT(T1.EMPLOYEE_ID) > 10
GROUP BY T5.REGION_NAME, T5.REGION_NAME

-- Task 2
-- Identify any department where the current manager (from HR.DEPARTMENTS) is also listed 
-- in the HR.JOB_HISTORY table for that same department. Display the Department Name, the 
-- Manager's Full Name (FIRST_NAME and LAST_NAME), and the Manager's total number of 
-- past job entries in the HR.JOB_HISTORY table.
SELECT
    DEPARTMENT_NAME, 
    JOB_TITLE,
    FIRST_NAME ||' '||LAST_NAME AS FULL_NAME,
    COUNT(T2.EMPLOYEE_ID) AS EMPLOYEE_COUNT
FROM HR.EMPLOYEES T1
INNER JOIN HR.JOB_HISTORY T2
    ON T1.EMPLOYEE_ID = T2.EMPLOYEE_ID
INNER JOIN HR.DEPARTMENTS T3
    ON T2.DEPARTMENT_ID = T3.DEPARTMENT_ID
INNER JOIN HR.JOBS T4
    ON T2.JOB_ID = T4.JOB_ID

WHERE JOB_TITLE LIKE '%Manager'
GROUP BY DEPARTMENT_NAME, 
JOB_TITLE,
FIRST_NAME,
LAST_NAME

-- Task 3
-- Find all JOB_TITLEs where the average salary of currently assigned employees is greater 
-- than $10,000. The result should list the Job Title and the Calculated Average Salary, 
-- ordered by the average salary in descending order. 
SELECT 
    T2.JOB_TITLE, 
    AVG(T1.SALARY) AS AVG_SALARY
FROM 
    HR.EMPLOYEES T1
INNER JOIN 
    HR.JOBS T2
    ON T1.JOB_ID = T2.JOB_ID
GROUP BY 
    T2.JOB_TITLE
HAVING 
    AVG(T1.SALARY) > 10000
ORDER BY 
    AVG_SALARY DESC;

-- Task 4
-- For each CITY in the HR.LOCATIONS table, find the employee with the earliest HIRE_DATE. 
-- The output should show the City, Employee's Full Name, and their Hire Date.
SELECT 
    T3.CITY, 
    FIRST_NAME ||' '||LAST_NAME AS FULL_NAME, 
    HIRE_DATE
FROM HR.EMPLOYEES T1
INNER JOIN HR.DEPARTMENTS T2
    ON T1.DEPARTMENT_ID = T2.DEPARTMENT_ID
INNER JOIN HR.LOCATIONS T3
    ON T2.LOCATION_ID = T3.LOCATION_ID
WHERE T1.HIRE_DATE IN 

(SELECT
    MIN(T1.HIRE_DATE)
FROM
HR.EMPLOYEES T1
INNER JOIN
HR.DEPARTMENTS T2
    ON T1.DEPARTMENT_ID = T2.DEPARTMENT_ID
INNER JOIN
HR.LOCATIONS T3
    ON T2.LOCATION_ID = T3.LOCATION_ID
GROUP BY T3.CITY
ORDER BY T3.CITY

-- Task 5
-- Write a query to calculate the average salary for every distinct combination of JOB_TITLE 
-- and DEPARTMENT_NAME. Exclude any combinations where the average salary is less than 
-- $5,000. The final result should show the Job Title, Department Name, and the Calculated 
-- Average Salary.
SELECT 
    JOB_TITLE,
    DEPARTMENT_NAME,
    AVG(SALARY) AS AVG_SALARY
FROM HR.EMPLOYEES T1
INNER JOIN HR.DEPARTMENTS T2
    ON T1.DEPARTMENT_ID = T2.DEPARTMENT_ID
INNER JOIN HR.JOBS T3
    ON T1.JOB_ID = T3.JOB_ID 

GROUP BY JOB_TITLE, DEPARTMENT_NAME
HAVING AVG(SALARY) >= 5000

-- Task 6
-- For every distinct REGION_NAME, find the maximum salary and the minimum salary among 
-- all employees in that region. Then, calculate the difference (or "spread") between the max 
-- and min salary. The output should show the Region Name, Max Salary, Min Salary, and the 
-- Salary Spread.
SELECT 
    REGION_NAME,
    MIN(SALARY) AS MIN_SALARY,
    MAX(SALARY) AS MAX_SALARY, 
    (MAX(SALARY) - MIN(SALARY)) AS SALARY_GAP
FROM HR.EMPLOYEES T1
INNER JOIN HR.DEPARTMENTS T2
    ON T1.DEPARTMENT_ID = T2.DEPARTMENT_ID 
INNER JOIN HR.LOCATIONS T3
    ON T2.LOCATION_ID = T3.LOCATION_ID 
INNER JOIN HR.COUNTRIES T4
    ON T3.COUNTRY_ID = T4.COUNTRY_ID
INNER JOIN HR.REGIONS T5
    ON T4.REGION_ID = T5.REGION_ID
GROUP BY REGION_NAME

-- Task 7
-- For every DEPARTMENT_NAME, calculate the total headcount (COUNT of employees) and 
-- the total potential annual commission payout. The commission payout is the sum of 
-- SALARY * COMMISSION_PCT. Crucially, only include employees who actually have a 
-- commission percentage (COMMISSION_PCT is not null) in your calculations and do not 
-- include departments with zero commissioned employees.
SELECT
    DEPARTMENT_NAME,
    SUM(SALARY * COMMISSION_PCT) AS COMMISSION_PAYOUT,
    COUNT(T1.EMPLOYEE_ID) AS TOTAL_HEADCOUNT
FROM HR.EMPLOYEES T1
INNER JOIN HR.DEPARTMENTS T2
    ON T1.DEPARTMENT_ID = T2.DEPARTMENT_ID 
WHERE COMMISSION_PCT IS NOT NULL
GROUP BY DEPARTMENT_NAME
HAVING COUNT(T1.EMPLOYEE_ID) > 0

-- Task 8
-- Write a query to count the total number of employees hired for each distinct year 
-- (extracted from the HIRE_DATE). Display the Year and the Number of Employees Hired, 
-- ordered from the oldest year to the newest year. 
SELECT
    EXTRACT(YEAR FROM HIRE_DATE) AS YEAR,
    COUNT(EMPLOYEE_ID) AS TOTAL_EMPLOYEE
FROM HR.EMPLOYEES
GROUP BY
EXTRACT(YEAR FROM HIRE_DATE)
ORDER BY
YEAR ASC

-- Task 9
-- For each CITY listed in the HR.LOCATIONS table, calculate the current headcount of 
-- employees working there. Only include cities where the headcount is less than 5 employees. 
-- Order the results by the headcount in ascending order.
SELECT
    T3.CITY,
    COUNT(T1.EMPLOYEE_ID)
    AS HEAD_COUNT
FROM
    HR.EMPLOYEES T1
INNER JOIN 
    HR.DEPARTMENTS T2
    ON T1.DEPARTMENT_ID = T2.DEPARTMENT_ID 
INNER JOIN 
    HR.LOCATIONS T3
    ON T2.LOCATION_ID = T3.LOCATION_ID 
GROUP BY
    T3.CITY
HAVING
    COUNT(T1.EMPLOYEE_ID) < 5
ORDER BY 
    HEAD_COUNT ASC

-------------------- ADVANCED LEVEL ZONE --------------------------
-- Task 10
-- Identify any current employee whose current salary falls outside the min_salary and 
-- max_salary range defined for their JOB_ID in the HR.JOBS table. The output should show the 
-- Employee Name, Job Title, Current Salary, and the defined Min/Max Salary Range for 
-- that job.
SELECT 
    FIRST_NAME ||' '|| LAST_NAME
    AS EMPLOYEE_NAME,
    JOB_TITLE,
    SALARY,
    CASE
        WHEN SALARY > MAX_SALARY
        THEN (MAX_SALARY - SALARY)
        WHEN SALARY < MIN_SALARY
        THEN (MIN_SALARY - SALARY)
        ELSE 0
        END AS SALARY_RANGE
FROM 
    HR.EMPLOYEES T1
INNER JOIN 
    HR.JOBS T2
    ON T1.JOB_ID = T2.JOB_ID
WHERE 
    SALARY < MIN_SALARY OR
    SALARY > MAX_SALARY
