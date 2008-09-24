-- Converts coordinates in `raw_geotab` the way as those in 
-- `raw_(found/ringed)_ducks`. After that converts area information and geonames.
-- The table `temp_geotab` is used for processing and its content will be put in:
-- `crc_coordinatesArea`
-- `crc_coordinateName`

DROP TABLE IF EXISTS `temp_geotab`;
CREATE TABLE `temp_geotab` (
`id` INT NOT NULL AUTO_INCREMENT,
`area` VARCHAR( 4 ) NOT NULL ,
`country_id` VARCHAR( 2 ) NULL ,
`former_country_id` VARCHAR( 4 ) NULL ,
`country_subdivision_id` VARCHAR( 6 ) NULL ,
`lat_dm` VARCHAR( 4 ) NOT NULL ,
`lon_dm` VARCHAR( 4 ) NOT NULL ,
`q` VARCHAR( 1 ) NOT NULL ,
`ca` VARCHAR( 4 ) NOT NULL ,
`cb` VARCHAR( 4 ) NOT NULL ,
`lat` DECIMAL(10,7) NULL ,
`lon` DECIMAL(10,7) NULL ,
`geoname` VARCHAR( 50 ) NOT NULL ,
PRIMARY KEY (`id`),
INDEX ( `area`), 
INDEX (`lat_dm`) , 
INDEX (`lon_dm`),
INDEX (`q`), 
INDEX (`ca`),
INDEX (`cb`), 
INDEX (`geoname`),
INDEX (`lat`, `lon`)
) ENGINE = innodb;

-- populate `temp_geotab`:
INSERT INTO `temp_geotab` (
    `area`, 
    `lat_dm`, 
    `lon_dm`, 
    `q`, 
    `ca`, 
    `cb`, 
    `geoname`) 
SELECT DISTINCT * FROM `raw_geotab` WHERE 1;

-- Process area field (code based on processLocations)
-- Countries
UPDATE 
    `temp_geotab` t 
    JOIN `euring_country_to_iso` eA 
    ON t.area REGEXP eA.ar
SET t.country_id = eA.country_id
WHERE 1;

-- Former countries
UPDATE 
    `temp_geotab` t 
    JOIN `euring_former_country_to_iso` eA 
    ON t.area REGEXP eA.ar
SET t.former_country_id = eA.former_country_id
WHERE 1;

-- Country subdivisions
UPDATE 
    `temp_geotab` t 
    JOIN `euring_country_subdivision_to_iso` eA 
    ON t.area REGEXP eA.ar
SET t.country_subdivision_id = eA.country_subdivision_id
WHERE 1;
