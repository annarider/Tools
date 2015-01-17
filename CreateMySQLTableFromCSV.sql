/* How to upload a .csv file to a MySQL table 
By: Anna Li 2015-01-16

 1. Start by creating the table in the schema with all columns matching csv
 2. modify the sql below
 3. run select to check the data was sucessfully loaded	
*/

-- modify the column names, data types, & sizes below
CREATE TABLE <tablename> (
	
    Email VARCHAR(128),
    SentFrom VARCHAR(128),
    Campaign VARCHAR(128),
    LastChanged VARCHAR(128),
    Bounced VARCHAR(128),
    BounceType VARCHAR(128),
    Unsubscribed VARCHAR(128),
    UnsubscribeReason VARCHAR(128),
    Description VARCHAR(128)
   ); 

LOAD DATA LOCAL INFILE '/path/to/file.csv' -- replace with name of CSV and a path to the file
INTO TABLE <tablename> -- replace with tablename
FIELDS TERMINATED BY ',' -- comma separated here
ENCLOSED BY '"' -- if terminated by double quotes
LINES TERMINATED BY '\n' -- carriage return?
IGNORE 1 ROWS; -- ignores the header row


SELECT * FROM <schema>.<tablename>;