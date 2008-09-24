-- This script merges the temp_merge_raw_captures table with the captures 
-- table. 
start transaction;
UPDATE 
    `captures` c 
    JOIN `temp_merge_raw_captures` t
    ON c.sch = t.sch AND c.ringnr = t.ringnr AND c.occ = t.occ
SET 
    c.age = t.age;
commit;

-- DROP TABLE `temp_merge_raw_captures`;  
