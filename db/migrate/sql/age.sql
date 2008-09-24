-- Clean up
UPDATE `temp_merge_raw_captures` SET age = NULL WHERE 1;
UPDATE `captures` SET age = NULL WHERE 1;

-- age moet 1,2,3,4,5,6,7,8,9 of letter zijn : A t/m Z converteren naar 10 en hoger (voor later, nu negeren)
UPDATE `temp_merge_raw_captures` 
SET age = a 
WHERE 
a = '1' OR
a = '2' OR
a = '3' OR
a = '4' OR
a = '5' OR
a = '6' OR
a = '7' OR
a = '8' OR
a = '9'; 

