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
  LPAD(' ',2*(LEVEL-1)) || FIRST_NAME   as PaddedFirstName
  ,FIRST_NAME                           as FIRST_NAME
  ,LPAD(' ',2*(LEVEL-1)) || LAST_NAME   as PaddedLastName
  ,LAST_NAME                            as LAST_NAME
  ,FIRST_NAME || ' ' || LAST_NAME       as FULL_NAME
  ,EMPLOYEE_NUMBER                      as EMPLOYEE_NUMBER
  ,LEVEL                                as Lvl
  ,F_MANAGER                            as F_MANAGER
  ,(SELECT FIRST_NAME from GD_EMPLOYEE emp2 WHERE emp2.EMPLOYEE_NUMBER = emp1.F_MANAGER) as ManagerFirstName
  ,(SELECT LAST_NAME from GD_EMPLOYEE emp2 WHERE emp2.EMPLOYEE_NUMBER = emp1.F_MANAGER)  as ManagerLastName
  ,SYS_CONNECT_BY_PATH(last_name, '/')                                                   as Path
FROM GD_EMPLOYEE emp1
START WITH EMPLOYEE_NUMBER = 100
CONNECT BY PRIOR EMPLOYEE_NUMBER = F_MANAGER
ORDER SIBLINGS BY EMPLOYEE_NUMBER
;

/* 
 * mdahlman
 * Tweaked to return JSON bracketing
 * Including debugging extra info
 */
WITH connect_by_query as (
  SELECT 
     ROWNUM                               as rnum
    ,LPAD(' ',2*(LEVEL-1)) || FIRST_NAME  as PaddedFirstName
    ,FIRST_NAME                           as FIRST_NAME
    ,LPAD(' ',2*(LEVEL-1)) || LAST_NAME   as PaddedLastName
    ,LAST_NAME                            as LAST_NAME
    ,FIRST_NAME || ' ' || LAST_NAME       as FULL_NAME
    ,EMPLOYEE_NUMBER                      as EMPLOYEE_NUMBER
    ,LEVEL                                as Lvl
    ,F_MANAGER                            as F_MANAGER
    ,(SELECT FIRST_NAME from GD_EMPLOYEE emp2 WHERE emp2.EMPLOYEE_NUMBER = emp1.F_MANAGER) as ManagerFirstName
    ,(SELECT LAST_NAME from GD_EMPLOYEE emp2 WHERE emp2.EMPLOYEE_NUMBER = emp1.F_MANAGER)  as ManagerLastName
    ,SYS_CONNECT_BY_PATH(last_name, '/')                                                   as Path
  FROM GD_EMPLOYEE emp1
  START WITH EMPLOYEE_NUMBER = 100
  CONNECT BY PRIOR EMPLOYEE_NUMBER = F_MANAGER
  ORDER SIBLINGS BY EMPLOYEE_NUMBER
)
select 
  CASE 
    WHEN Lvl = 1 THEN '{' 
    WHEN Lvl - LAG(Lvl) OVER (order by rnum) = 1 THEN ',"children" : [{' 
    ELSE ',{' END 
  || ' "name" : "' || FULL_NAME || '" '
  || CASE WHEN LEAD(Lvl, 1, 1) OVER (order by rnum) - Lvl <= 0 
     THEN '}' || rpad( ' ', 1+ (-2 * (LEAD(Lvl, 1, 1) OVER (order by rnum) - Lvl)), ']}' )
     ELSE NULL END as JSON_SNIPPET
  ,Lvl
  ,F_MANAGER 
  ,LAG(Lvl, 1, 0)  OVER (order by rnum)       as prev_level
  ,Lvl - LAG(Lvl, 1, 0)  OVER (order by rnum) as change_to_this_record
  ,LEAD(Lvl, 1, 1) OVER (order by rnum)       as next_level
  ,LEAD(Lvl, 1, 1) OVER (order by rnum) - Lvl as change_to_next_record
from connect_by_query
order by rnum
;

/* 
 * mdahlman
 * Tweaked to return JSON bracketing
 * Excluding debugging info
 */
WITH connect_by_query as (
  SELECT 
     ROWNUM                               as rnum
    ,LPAD(' ',2*(LEVEL-1)) || FIRST_NAME  as PaddedFirstName
    ,FIRST_NAME                           as FIRST_NAME
    ,LPAD(' ',2*(LEVEL-1)) || LAST_NAME   as PaddedLastName
    ,LAST_NAME                            as LAST_NAME
    ,FIRST_NAME || ' ' || LAST_NAME       as FULL_NAME
    ,EMPLOYEE_NUMBER                      as EMPLOYEE_NUMBER
    ,LEVEL                                as Lvl
    ,F_MANAGER                            as F_MANAGER
    ,(SELECT FIRST_NAME from GD_EMPLOYEE emp2 WHERE emp2.EMPLOYEE_NUMBER = emp1.F_MANAGER) as ManagerFirstName
    ,(SELECT LAST_NAME from GD_EMPLOYEE emp2 WHERE emp2.EMPLOYEE_NUMBER = emp1.F_MANAGER)  as ManagerLastName
    ,SYS_CONNECT_BY_PATH(last_name, '/')                                                   as Path
  FROM GD_EMPLOYEE emp1
  START WITH EMPLOYEE_NUMBER = 100
  CONNECT BY PRIOR EMPLOYEE_NUMBER = F_MANAGER
  ORDER SIBLINGS BY EMPLOYEE_NUMBER
)
select 
  CASE 
    WHEN Lvl = 1 THEN '{' 
    WHEN Lvl - LAG(Lvl) OVER (order by rnum) = 1 THEN ',"children" : [{' 
    ELSE ',{' END 
  || ' "name" : "' || FULL_NAME || '" '
  || CASE WHEN LEAD(Lvl, 1, 1) OVER (order by rnum) - Lvl <= 0 
     THEN '}' || rpad( ' ', 1+ (-2 * (LEAD(Lvl, 1, 1) OVER (order by rnum) - Lvl)), ']}' )
     ELSE NULL END 
  || '\'
  as JSON_SNIPPET
from connect_by_query
order by rnum
;

