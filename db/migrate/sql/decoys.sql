DROP TABLE IF EXISTS `raw_decoys`;
CREATE TABLE `raw_decoys` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`registratienummer` VARCHAR( 20 ) NOT NULL ,
`naam_eendenkooi` VARCHAR( 40 ) NOT NULL ,
`gemeente` VARCHAR( 30 ) NOT NULL ,
`provincie` VARCHAR( 20 ) NOT NULL ,
`dur_nummer` VARCHAR( 40 ) NOT NULL ,
`kadastrale_omschrijving` VARCHAR( 100 ) NOT NULL ,
`coordinaten` VARCHAR( 20 ) NOT NULL
) ENGINE = InnoDB COMMENT = 'From Excel file';
ALTER TABLE `raw_decoys` ADD INDEX (`coordinaten`);

LOAD DATA LOCAL INFILE 'db/import/TOTAALLIJSTNL04 coordinates.csv' 
	INTO TABLE `raw_decoys`
	FIELDS ENCLOSED BY '"' TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	(
		registratienummer, 
		naam_eendenkooi, 
		gemeente, 
		provincie, 
		dur_nummer, 
		kadastrale_omschrijving, 
		coordinaten
	);
