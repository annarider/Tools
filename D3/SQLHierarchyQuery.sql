/*** Hierarchy Query for Employee Data from Semarchy Demo MDM ***/

/*** General hierarchy to retrieve all employees,             ***/
/*** employee ID, managers, manager ID, level & path          ***/

SELECT 
  FIRST_NAME "First Name"
  ,LAST_NAME "Last Name"
  ,EMPLOYEE_NUMBER "Employee ID"
  ,CONNECT_BY_ROOT first_name "Manager First Name"
  ,CONNECT_BY_ROOT last_name "Manager Last Name"
  ,F_MANAGER "Manager ID"
  ,LEVEL
  ,LEVEL - 1 "Pathlen"
  ,SYS_CONNECT_BY_PATH(last_name, '/') "Path"
  
FROM GD_EMPLOYEE
--WHERE LEVEL > 1
--START WITH EMPLOYEE_NUMBER = 100
CONNECT BY PRIOR EMPLOYEE_NUMBER = F_MANAGER
ORDER SIBLINGS BY EMPLOYEE_NUMBER;

/*** Takes an employee ID and returns the children from that employee ***/

SELECT 
  FIRST_NAME
  ,LAST_NAME
  ,EMPLOYEE_NUMBER
  ,LEVEL
  ,SYS_CONNECT_BY_PATH(last_name, '/') "Path"
FROM GD_EMPLOYEE
START WITH EMPLOYEE_NUMBER = 148
CONNECT BY PRIOR EMPLOYEE_NUMBER = F_MANAGER
ORDER SIBLINGS BY EMPLOYEE_NUMBER 
;

/*** Takes an Employee ID and returns the children and their managers one level up ***/

SELECT 
  LPAD(' ',2*(LEVEL-1)) || 
  FIRST_NAME "FirstName"
  ,LPAD(' ',2*(LEVEL-1)) || 
  LAST_NAME "LastName"
  ,EMPLOYEE_NUMBER
  ,LEVEL
  ,F_MANAGER
  ,(SELECT FIRST_NAME from GD_EMPLOYEE emp2 WHERE emp2.EMPLOYEE_NUMBER = emp1.F_MANAGER) as "ManagerFirstName"
  ,(SELECT LAST_NAME from GD_EMPLOYEE emp2 WHERE emp2.EMPLOYEE_NUMBER = emp1.F_MANAGER) as "ManagerLastName"
  ,SYS_CONNECT_BY_PATH(last_name, '/') "Path"
FROM GD_EMPLOYEE emp1
--WHERE LEVEL > 1
START WITH EMPLOYEE_NUMBER = 100
CONNECT BY PRIOR EMPLOYEE_NUMBER = F_MANAGER
ORDER SIBLINGS BY EMPLOYEE_NUMBER
;

/*** Takes an Employee ID and returns the children and their managers one level up           ***/
/*** Same as query above but additional fields that remove padding & concatenate full name   ***/
/***  Matt this is the most recent query you want ***/

SELECT 
  LPAD(' ',2*(LEVEL-1)) || 
  FIRST_NAME PaddedFirstName
  ,FIRST_NAME FirstName
  ,LPAD(' ',2*(LEVEL-1)) || 
  LAST_NAME PaddedLastName
  ,LAST_NAME LastName
  ,FIRST_NAME || ' ' || LAST_NAME FullName
  ,EMPLOYEE_NUMBER
  ,LEVEL
  ,F_MANAGER
  ,(SELECT FIRST_NAME from GD_EMPLOYEE emp2 WHERE emp2.EMPLOYEE_NUMBER = emp1.F_MANAGER) as ManagerFirstName
  ,(SELECT LAST_NAME from GD_EMPLOYEE emp2 WHERE emp2.EMPLOYEE_NUMBER = emp1.F_MANAGER) as ManagerLastName
  ,SYS_CONNECT_BY_PATH(last_name, '/') "Path"
FROM GD_EMPLOYEE emp1
--WHERE LEVEL > 1
START WITH EMPLOYEE_NUMBER = 100
CONNECT BY PRIOR EMPLOYEE_NUMBER = F_MANAGER
ORDER SIBLINGS BY EMPLOYEE_NUMBER
;

/*** Takes an Employee ID and returns the entire arm of the tree including  ***/
/*** children and parents but NOT siblings. NOT FINISHED. Not working!!     ***/

SELECT 
  LPAD(' ',2*(LEVEL-1)) || 
  FIRST_NAME
  ,LPAD(' ',2*(LEVEL-1)) || 
  LAST_NAME
  ,EMPLOYEE_NUMBER
  ,LEVEL
  ,CONNECT_BY first_name "Manager First Name"
  ,CONNECT_BY last_name "Manager Last Name" 
  ,SYS_CONNECT_BY_PATH(last_name, '/') "Path"
FROM GD_EMPLOYEE
--WHERE EMPLOYEE_NUMBER = 148
START WITH EMPLOYEE_NUMBER = 100
CONNECT BY PRIOR EMPLOYEE_NUMBER = F_MANAGER
;