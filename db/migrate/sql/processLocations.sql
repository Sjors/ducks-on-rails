-- Should replace the old country.sql and provincesRingedFound.sql file
-- Match country information from rar and far colums to 
-- country and former country id.
--
-- Perform special operations to make incompatible data usable:
-- USSR : merge European and Asiatic part into former country USSR
--

-- Clean up
DELETE FROM `capture_countries` WHERE 1;
DELETE FROM `capture_former_countries` WHERE 1;
DELETE FROM `capture_country_subdivisions` WHERE 1;

---------------------------------------
--- Process corresponding countries---
---------------------------------------
INSERT INTO `capture_countries` 
SELECT 
    sch,
    ringnr,
    occ,
    eA.country_id
FROM 
    `temp_merge_raw_captures` t
    JOIN `euring_country_to_iso` eA 
    ON t.ar REGEXP eA.ar
WHERE 1;
---------------------------------------------
--- Process corresponding former countries---
---------------------------------------------
INSERT INTO `capture_former_countries` 
SELECT 
    sch,
    ringnr,
    occ,
    eA.former_country_id
FROM 
    `temp_merge_raw_captures` t
    JOIN `euring_former_country_to_iso` eA 
    ON t.ar REGEXP eA.ar
WHERE 1;

-----------------------------------------------
-- Process corresponding county subdivisions --
-----------------------------------------------
INSERT INTO `capture_country_subdivisions` 
SELECT 
    sch,
    ringnr,
    occ,
    eA.country_subdivision_id
FROM 
    `temp_merge_raw_captures` t
    JOIN `euring_country_subdivision_to_iso` eA 
    ON t.ar REGEXP eA.ar
WHERE 1;
