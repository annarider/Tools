/* Drops the tables to update model with new config, from DI into Semarchy
/* Replace the name SEMARCHY_MDM with the correct user
/* Once the SQL is generated, run it to drop the tables */
 
select 'drop table SEMARCHY_MDM.' || table_name || ';'
from all_tables 
where owner='SEMARCHY_MDM' 
and table_name not like 'DL_%' and table_name not like 'EXT_%'
order by substr(table_name,3), table_name;
