-- Populate coordinateCountry coordinateCountryFormer and 
-- coordinateCountrySubdivision, with coordinate/area pairs in 
-- `temp_geotab`.

INSERT IGNORE INTO `country_coordinates` 
SELECT DISTINCT lat, lon, country_id FROM `temp_geotab` WHERE 1;

INSERT IGNORE INTO `former_country_coordinates` 
SELECT DISTINCT lat, lon, former_country_id FROM `temp_geotab` 
WHERE former_country_id IS NOT NULL;

INSERT IGNORE INTO `country_subdivision_coordinates` 
SELECT DISTINCT lat, lon, country_subdivision_id FROM `temp_geotab` WHERE 1;

-- Update `capture`[Area] using `captureCoordinates` and `coordinate`[Area] tables
-- This part had no effect on 2007-08-21

-- Countries:
UPDATE 
    `captures` c
    LEFT JOIN `capture_countries` capCou ON
        c.sch = capCou.sch AND 
        c.ringnr = capCou.ringnr AND 
        c.occ = capCou.occ
    JOIN `capture_coordinates` cCoo ON 
        c.sch = cCoo.sch AND 
        c.ringnr = cCoo.ringnr AND 
        c.occ = cCoo.occ
    JOIN `country_coordinates` cCou ON
        cCoo.lat = cCou.lat AND
        cCoo.lon = cCou.lon
SET 
    capCou.country_id = cCou.country_id
WHERE capCou.country_id IS NULL;

-- Former countries:
UPDATE 
    `captures` c
    LEFT JOIN `capture_former_countries` capCou ON
        c.sch = capCou.sch AND 
        c.ringnr = capCou.ringnr AND 
        c.occ = capCou.occ
    JOIN `capture_coordinates` cCoo ON 
        c.sch = cCoo.sch AND 
        c.ringnr = cCoo.ringnr AND 
        c.occ = cCoo.occ
    JOIN `former_country_coordinates` cCou ON
        cCoo.lat = cCou.lat AND
        cCoo.lon = cCou.lon
SET 
    capCou.former_country_id = cCou.former_country_id
WHERE capCou.former_country_id IS NULL;

-- Country subdivisions
UPDATE 
    `captures` c
    LEFT JOIN `capture_country_subdivisions` capCou ON
        c.sch = capCou.sch AND 
        c.ringnr = capCou.ringnr AND 
        c.occ = capCou.occ
    JOIN `capture_coordinates` cCoo ON 
        c.sch = cCoo.sch AND 
        c.ringnr = cCoo.ringnr AND 
        c.occ = cCoo.occ
    JOIN `country_subdivision_coordinates` cCou ON
        cCoo.lat = cCou.lat AND
        cCoo.lon = cCou.lon
SET 
    capCou.country_subdivision_id = cCou.country_subdivision_id
WHERE capCou.country_subdivision_id IS NULL;


