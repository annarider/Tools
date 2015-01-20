/* 
 * Demo schemas to create independent demo environments
 */

DROP USER WINE_REPOSITORY   CASCADE;
DROP USER WINE_MDM          CASCADE;
DROP USER WINE_PULSE        CASCADE;
DROP USER WINE_DEMO_SOURCE  CASCADE;
DROP USER WINE_DEMO_MDM     CASCADE;
DROP USER WINE_STG          CASCADE;

CREATE USER                     WINE_REPOSITORY
IDENTIFIED BY                   WINE_REPOSITORY 
DEFAULT TABLESPACE USERS 
TEMPORARY TABLESPACE TEMP;
GRANT CONNECT, RESOURCE TO      WINE_REPOSITORY;

CREATE USER                     WINE_MDM
IDENTIFIED BY                   WINE_MDM 
DEFAULT TABLESPACE USERS 
TEMPORARY TABLESPACE TEMP;
GRANT CONNECT, RESOURCE TO      WINE_MDM;

CREATE USER                     WINE_PULSE
IDENTIFIED BY                   WINE_PULSE
DEFAULT TABLESPACE USERS 
TEMPORARY TABLESPACE TEMP;
GRANT CONNECT, RESOURCE, DBA TO WINE_PULSE;
GRANT SELECT ANY TABLE TO       WINE_PULSE;

CREATE USER                     WINE_DEMO_SOURCE 
IDENTIFIED BY                   WINE_DEMO_SOURCE
DEFAULT TABLESPACE USERS 
TEMPORARY TABLESPACE TEMP;
GRANT CONNECT, RESOURCE TO      WINE_DEMO_SOURCE; 

CREATE USER                     WINE_DEMO_MDM
IDENTIFIED BY                   WINE_DEMO_MDM 
DEFAULT TABLESPACE USERS 
TEMPORARY TABLESPACE TEMP;
GRANT CONNECT, RESOURCE TO      WINE_DEMO_MDM;

CREATE USER                     WINE_STG
IDENTIFIED BY                   WINE_STG
DEFAULT TABLESPACE USERS 
TEMPORARY TABLESPACE TEMP;
GRANT CONNECT, RESOURCE, DBA TO WINE_STG;

