----------- Advanced Level ---------------
-- Task 11
-- Calculate the salary variance (the difference between the highest and lowest salary) and the 
-- salary ratio (highest salary divided by lowest salary) for every DEPARTMENT_NAME. List the 
-- top 5 departments that have the highest salary compression (i.e., the lowest salary ratio). 
SELECT 
    T2.DEPARTMENT_NAME,
    ROUND(MAX(T1.SALARY) / MIN(T1.SALARY),2) AS
    SALARY_RATIO,
    MAX(T1.SALARY) - MIN(T1.SALARY) AS 
    SALARY_VARIANCE
FROM
    HR.EMPLOYEES T1
INNER JOIN HR.DEPARTMENTS T2
    ON T1.DEPARTMENT_ID = T2.DEPARTMENT_ID
GROUP BY T2.DEPARTMENT_NAME
ORDER BY SALARY_RATIO ASC
FETCH FIRST 5 ROWS ONLY

-- Task 12
-- A "Boomerang Employee" is one who left a department, held a job in a different department, 
-- and then returned to their original department. Identify all employees who have been in the 
-- same department (based on JOB_HISTORY and EMPLOYEES current department) at least 
-- twice. Show the Employee Name, the Department Name, and the Total Number of Times 
-- they have worked for that specific department.

WITH EMPLOYEE_DEPT_HISTORY AS (
    SELECT EMPLOYEE_ID, DEPARTMENT_ID
    FROM HR.JOB_HISTORY

    UNION ALL

    SELECT EMPLOYEE_ID, DEPARTMENT_ID
    FROM HR.EMPLOYEES
)
SELECT
    T2.FIRST_NAME ||' '|| T2.LAST_NAME AS
    EMPLOYEE_NAME,
    T3.DEPARTMENT_NAME,
    COUNT(T1.DEPARTMENT_ID) AS TOTAL_TIMES
FROM
    EMPLOYEE_DEPT_HISTORY T1
INNER JOIN
    HR.EMPLOYEES T2
    ON T1.EMPLOYEE_ID = T2.EMPLOYEE_ID 
INNER JOIN  
    HR.DEPARTMENTS T3
    ON T1.DEPARTMENT_ID = T3.DEPARTMENT_ID 

GROUP BY
    T2.EMPLOYEE_ID, T2.FIRST_NAME,
    T2.LAST_NAME, T3.DEPARTMENT_NAME
HAVING COUNT(T1.DEPARTMENT_ID) >= 2
ORDER BY
    TOTAL_TIMES DESC, EMPLOYEE_NAME

-- Task 13
-- For employees in the 'Seattle' or 'London' cities, rank them based on their total tenure (time 
-- elapsed since HIRE_DATE) within their respective city. Assign rank 1 to the employee with the 
-- longest tenure in that city. The result should include City, Employee Name, Hire Date, and 
-- their calculated Tenure Rank in City.
SELECT
    T3.CITY,
    T1.FIRST_NAME||' '||T1.LAST_NAME
    AS FULL_NAME,
    T1.HIRE_DATE,
    DENSE_RANK() OVER (
        PARTITION BY T3.CITY
        ORDER BY (SYSDATE - T1.HIRE_DATE) DESC
    ) AS TENURE_RANK
FROM 
    HR.EMPLOYEES T1
INNER JOIN
    HR.DEPARTMENTS T2
    ON T1.DEPARTMENT_ID = T2.DEPARTMENT_ID 
INNER JOIN HR.LOCATIONS T3
    ON T2.LOCATION_ID = T3.LOCATION_ID

WHERE CITY IN ('Seattle','London')
ORDER BY
    T3.CITY, TENURE_RANK

-- Task 14
-- Find the top 10 longest periods (in days) any job was held by any employee, based on the 
-- START_DATE and END_DATE in the HR.JOB_HISTORY table. The final output must show the 
-- Employee Name, Job Title, Start Date, End Date, and the Duration in Days.
SELECT
    FIRST_NAME||' '||LAST_NAME
    AS EMPLOYEE_NAME,
    JOB_TITLE,
    START_DATE,
    END_DATE,
    (END_DATE - START_DATE) AS
    DURATIONS
FROM
    HR.EMPLOYEES T1
INNER JOIN
    HR.JOB_HISTORY T2
    ON T1.EMPLOYEE_ID = T2.EMPLOYEE_ID 
INNER JOIN HR.JOBS T3
    ON T2.JOB_ID = T3.JOB_ID 

ORDER BY DURATIONS DESC
FETCH FIRST 10 ROWS ONLY

-- Task 15
-- Write a single query that lists every employee who currently acts as a manager (by matching 
-- EMPLOYEES.EMPLOYEE_ID to EMPLOYEES.MANAGER_ID). For each manager, display their 
-- Full Name and the Total Number of Direct Reports they currently have.
SELECT 
    T1.FIRST_NAME||' '||T1.LAST_NAME
    AS FULL_NAME,
    COUNT(T2.EMPLOYEE_ID) 
    AS NUMBER_DIRECT_REPORT
FROM
    HR.EMPLOYEES T1
LEFT JOIN
    HR.EMPLOYEES T2
ON T1.EMPLOYEE_ID = T2.MANAGER_ID
GROUP BY 
    T1.FIRST_NAME, 
    T1.LAST_NAME, 
    T1.EMPLOYEE_ID
ORDER BY NUMBER_DIRECT_REPORT DESC

-- Task 16
-- Calculate the average salary for all employees in the 'Europe' region and the 'Americas' region. 
-- Then, display the percentage difference between the average salary of the 'Europe' region 
-- and the 'Americas' region.
WITH REGION_AVG AS (
SELECT
    AVG(CASE
    WHEN T5.REGION_NAME = 'Americas'
    THEN T1.SALARY END) AS AMS_AVG,
    AVG(CASE
    WHEN T5.REGION_NAME = 'Europe'
    THEN T1.SALARY END) AS EU_AVG
FROM 
    HR.EMPLOYEES T1
INNER JOIN 
    HR.DEPARTMENTS T2
    ON T1.DEPARTMENT_ID = T2.DEPARTMENT_ID 
INNER JOIN 
    HR.LOCATIONS T3
    ON T2.LOCATION_ID = T3.LOCATION_ID 
INNER JOIN 
    HR.COUNTRIES T4
    ON T3.COUNTRY_ID = T4.COUNTRY_ID
INNER JOIN 
    HR.REGIONS T5
    ON T4.REGION_ID = T5.REGION_ID
WHERE 
    REGION_NAME IN ('Americas','Europe')
)
SELECT
    ROUND(AMS_AVG, 2) AS AVG_AMERICAS, 
    ROUND(EU_AVG, 2) AS AVG_EUROPE,
    ROUND(((EU_AVG - AMS_AVG) / AMS_AVG) * 100, 2)
    AS PERCENT_DIFF
FROM REGION_AVG

-- Task 17
-- For every job transition recorded in HR.JOB_HISTORY, identify the next department the 
-- employee moved to. If their current job is the last entry, use their current 
-- EMPLOYEES.DEPARTMENT_ID as the "next department." The final output should show 
-- Employee Name, Previous Department Name, Next Department Name, and the Job Title 
-- associated with the transition. Hint: Use the LEAD() window function over the START_DATE 
-- partition. 
WITH EmployeeNextDepartment AS (
    SELECT
        JH2.EMPLOYEE_ID,
        JH2.START_DATE,
        LEAD(JH2.DEPARTMENT_ID, 1, E.DEPARTMENT_ID) 
             OVER(PARTITION BY JH2.EMPLOYEE_ID ORDER BY JH2.START_DATE) 
             AS NEXT_DEPT_ID
    FROM
        HR.JOB_HISTORY JH2
    INNER JOIN
        HR.EMPLOYEES E ON JH2.EMPLOYEE_ID = E.EMPLOYEE_ID
)
SELECT
    E.FIRST_NAME || ' ' || E.LAST_NAME AS FULL_NAME,
    PD.DEPARTMENT_NAME AS PREV_DEPT_NAME,
    COALESCE(ND.DEPARTMENT_NAME, CD.DEPARTMENT_NAME) AS NEXT_DEPT_NAME,
    J.JOB_TITLE AS JOB_TITLE
FROM
    HR.JOB_HISTORY JH
INNER JOIN
    HR.EMPLOYEES E 
    ON JH.EMPLOYEE_ID = E.EMPLOYEE_ID
INNER JOIN 
    HR.DEPARTMENTS PD 
    ON JH.DEPARTMENT_ID = PD.DEPARTMENT_ID 
INNER JOIN
    HR.JOBS J 
    ON JH.JOB_ID = J.JOB_ID
INNER JOIN
    EmployeeNextDepartment END 
    ON JH.EMPLOYEE_ID = END.EMPLOYEE_ID 
    AND JH.START_DATE = END.START_DATE
LEFT JOIN
    HR.DEPARTMENTS ND 
    ON END.NEXT_DEPT_ID = ND.DEPARTMENT_ID 
LEFT JOIN 
    HR.DEPARTMENTS CD 
    ON E.DEPARTMENT_ID = CD.DEPARTMENT_ID 
ORDER BY
    FULL_NAME, JH.START_DATE;

