-- Populate table using data from captureArea and captureCoordinates
DROP TABLE IF EXISTS `country_coordinates`;
CREATE TABLE `country_coordinates` (
    `lat` DECIMAL(10,7) NOT NULL ,
    `lon` DECIMAL(10,7) NOT NULL ,
    `country_id` VARCHAR( 2 ) NULL ,
    PRIMARY KEY ( `lat` , `lon` ),
    FOREIGN KEY (country_id) REFERENCES `countries`(id) ON DELETE CASCADE
) ENGINE = innodb;

-- Note that former_country_id is also part of the primary key,
-- because multiple former countries (in the ISO definition)
-- can occupy one location.
DROP TABLE IF EXISTS `former_country_coordinates`;
CREATE TABLE `former_country_coordinates` (
    `lat` DECIMAL(10,7) NOT NULL ,
    `lon` DECIMAL(10,7) NOT NULL ,
    `former_country_id` VARCHAR( 4 ) NULL ,
    PRIMARY KEY ( `lat` , `lon`,`former_country_id` ),
    FOREIGN KEY (former_country_id) REFERENCES `former_countries`(id) ON DELETE CASCADE
) ENGINE = innodb;

DROP TABLE IF EXISTS `country_subdivision_coordinates`;
CREATE TABLE `country_subdivision_coordinates` (
    `lat` DECIMAL(10,7) NOT NULL ,
    `lon` DECIMAL(10,7) NOT NULL ,
    `country_subdivision_id` VARCHAR( 6 ) NULL ,
    PRIMARY KEY ( `lat` , `lon` ),
    FOREIGN KEY (country_subdivision_id) REFERENCES `country_subdivisions`(id) ON DELETE CASCADE
) ENGINE = innodb;


-- This script does not deal with inconsistancies, if they exist.
-- E.g. if 1 coordinate belongs to multiple countries, it will
-- pick one (not) at random.

-- countries
INSERT INTO `country_coordinates` (lat, lon, country_id)
SELECT
    lat, 
    lon, 
    country_id 
FROM 
    `capture_countries` a 
    JOIN `capture_coordinates` c 
    ON a.sch = c.sch AND a.ringnr = c.ringnr AND a.occ = c.occ
WHERE 1
GROUP BY lat, lon;

-- former countries
INSERT INTO `former_country_coordinates` (lat, lon, former_country_id)
SELECT
    lat, 
    lon, 
    former_country_id 
FROM 
    `capture_former_countries` a 
    JOIN `capture_coordinates` c 
    ON a.sch = c.sch AND a.ringnr = c.ringnr AND a.occ = c.occ
WHERE 1
GROUP BY lat, lon;

-- country subdivisions
INSERT INTO `country_subdivision_coordinates` (lat, lon, country_subdivision_id)
SELECT
    lat, 
    lon, 
    country_subdivision_id 
FROM 
    `capture_country_subdivisions` a 
    JOIN `capture_coordinates` c 
    ON a.sch = c.sch AND a.ringnr = c.ringnr AND a.occ = c.occ
WHERE 1
GROUP BY lat, lon;
