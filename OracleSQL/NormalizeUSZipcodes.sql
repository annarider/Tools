
/* Example of normalizing US zipcodes so they are at least 5 digits
 * Most helpful for zipcodes on East Coast that begin with 0
 * LPAD(exp1 to be formated, number of characters expected, exp2 to be filled in) 
*/

-- From Juniper POV

select sitzip,
CASE
  WHEN length(sitzip) <5 THEN LPAD(SITZIP, 5, '0')
  ELSE sitzip
END
from SD_SITE
where (SITCOUNTRY = 'United States'  or SITCOUNTRY = 'US Minor Outlying Islands' ) 
;