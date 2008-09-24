CREATE TABLE `raw_geotab` (
    area char (4) NOT NULL ,
    lat char (4) NULL ,
    lon char (4) NULL ,
    q char (1) NOT NULL ,
    ca varchar (4) NULL ,
    cb varchar (4) NULL ,
    geoname varchar (50) NOT NULL,
    INDEX ( `area`), 
    INDEX (`q`), 
    INDEX (`ca`),
    INDEX (`cb`), 
    INDEX (`geoname`),
    INDEX (`lat`, `lon`)
);

LOAD DATA LOCAL INFILE 'db/import/nl_vts_geotab' 
	INTO TABLE `raw_geotab`
	FIELDS ENCLOSED BY '"' TERMINATED BY ','
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES
	(area, lat, lon, q, ca, cb, geoname);

