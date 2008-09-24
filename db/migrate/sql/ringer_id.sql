-- Clean up
DELETE FROM `ringer_captures` WHERE 1;

INSERT INTO `ringer_captures`
SELECT 
    rid,
    sch, 
    ringnr,
    occ
FROM `temp_merge_raw_captures` t JOIN `addresses_nl_vts` a ON t.rid = a.KODE
WHERE 
rid IS NOT NULL AND
rid != "" AND
rid NOT LIKE "NULL" AND
rid NOT LIKE "000" AND
rid NOT LIKE "OOO";
