# I received the ring and recapture data about ducks from Gert Speek, 29th of 
# May 2007. The files (eenden-geringd.rpt and eenden-terug.rpt) are in
# fixed format, bare ascii. The script tabdata.sh converts the data to the input format of this script. This script puts them in a MySQL database.
#
# To use this script, make sure:
# - The files (eenden-geringd-tab.rpt and eenden-terug.csv) are present.  

DROP TABLE IF EXISTS `raw_ringed_ducks`;

# Create table structure.

CREATE TABLE `raw_ringed_ducks` (
    `sch`       VARCHAR( 3 )        COMMENT 'ringing scheme                        01-03',
    `ringnr`    VARCHAR( 8 )        COMMENT 'ring number                           04-11',
    `rspec`     INT(5) ZEROFILL     COMMENT 'species                               12-16',
    `rf`        INT                 COMMENT 'not used                                   ',
    `ch`        VARCHAR( 1 )        COMMENT 'factors affecting recovery chances    18-18',
    `rx`        INT( 2 ) ZEROFILL   COMMENT 'sex                                   19-19',
    `ra`        VARCHAR( 1 )        COMMENT 'age                                   20-20',
    `rs`        VARCHAR( 1 )        COMMENT 'status and broodsize                  21-21',
    `rb`        VARCHAR( 1 )        COMMENT 'moult and biometrics, pullus age      22-22',
    `p`         VARCHAR( 1 )        COMMENT 'plumage, accuracy of pullus age       23-23',
    `rdate`     DATE                COMMENT 'date of ringing                       24-29',
    `rtime`     TIME                COMMENT 'not used, not part of EURING 1979          ',
    `ry`        VARCHAR ( 2 )       COMMENT 'accuracy of ringing date              30-30',
    `rar`       VARCHAR( 4 )        COMMENT 'place code                            31-34',
    `rca`       VARCHAR( 4 )        COMMENT 'geographical co-ordinates             35-38',
    `rcb`       VARCHAR( 4 )        COMMENT 'geographical co-ordinates             39-42',
    `rq`        VARCHAR( 1 )        COMMENT 'quadrant                              43-43',
    `rid`       VARCHAR( 10 )       COMMENT 'not used, not part of EURING 1979          ',
    PRIMARY KEY (`sch`, `ringnr`)
) ENGINE=InnoDB ;

ALTER TABLE `raw_ringed_ducks` ADD INDEX ( `rar` );
ALTER TABLE `raw_ringed_ducks` ADD INDEX ( `rca` );
ALTER TABLE `raw_ringed_ducks` ADD INDEX ( `rcb` );
ALTER TABLE `raw_ringed_ducks` ADD INDEX ( `rq` );
ALTER TABLE `raw_ringed_ducks` ADD INDEX ( `rx` );

DROP TABLE IF EXISTS `raw_found_ducks`;

CREATE TABLE `raw_found_ducks` (
    `sch`       VARCHAR( 3 )            COMMENT 'ringing scheme                        01-03',
    `ringnr`    VARCHAR( 8 )            COMMENT 'ring number                           04-11',
  `fspec`   INT( 5 ) ZEROFILL   COMMENT 'species                               12-16',
  `ve`          VARCHAR( 1 )            COMMENT 'verification of ring and identity     17-17',
  `fx`          INT( 2 )ZEROFILL    COMMENT 'sex                                   19-19',
  `fa`          VARCHAR ( 1  )      COMMENT 'age                                   20-20',
  `fdate`       DATE                            COMMENT 'date of finding                       44-49',
  `fy`          VARCHAR( 2 )        COMMENT 'accuracy of finding date              50-50',
  `far`         VARCHAR( 4 )        COMMENT 'place code                            51-54',
  `fca`         VARCHAR( 4 )        COMMENT 'geographical co-ordinates             55-58',
  `fcb`         VARCHAR( 4 )        COMMENT 'geographical co-ordinates             59-62',
  `fq`          VARCHAR( 1 )      COMMENT 'quadrant                              63-63',
  `c`               INT( 1 )                COMMENT 'finding condition                     64-64',
  `ci`          INT( 2 )                    COMMENT 'finding circumstances                 65-66',
  `tr`          VARCHAR( 1 )        COMMENT 'finding details presumed.....         67-67',
  `pr`          VARCHAR( 1 )      COMMENT 'previous report.....                  68-68',
  `fs`          VARCHAR( 1 )      COMMENT 'status, other relatives recovered     69-69',
  `fb`          INT( 1 )              COMMENT 'moult and biometrics                  70-70',
  `dist`    VARCHAR( 4 )            COMMENT 'distance                              71-74',
  `dir`     VARCHAR( 4 )            COMMENT 'direction                             75-77',
  `fid`     VARCHAR(10),
    `ref`           DATE                            COMMENT 'Reference data (not part of EURING 1979)'
) ENGINE=InnoDB;

# The combination ringing scheme (sch) and ring number (ringnr) does NOT have
# to be unique.

ALTER TABLE `raw_found_ducks`
    ADD `id` INT NOT NULL
    AUTO_INCREMENT
    PRIMARY KEY
    COMMENT 'index (not part of EURING 1979)'
    FIRST ;

ALTER TABLE `raw_found_ducks` ADD INDEX ( `sch` , `ringnr` );
ALTER TABLE `raw_found_ducks` ADD INDEX ( `far` );
ALTER TABLE `raw_found_ducks` ADD INDEX ( `fca` );
ALTER TABLE `raw_found_ducks` ADD INDEX ( `fcb` );
ALTER TABLE `raw_found_ducks` ADD INDEX ( `fq` );


# The combination ringing scheme (sch) and ring number (ringnr) must be unique. This also means an addition index column is needed.

-- Load the ringing data from 'ducks-ringed-tab.rpt'
LOAD DATA LOCAL INFILE 'db/import/ducks-ringed-tab.rpt' 
	INTO TABLE `raw_ringed_ducks`
	FIELDS ENCLOSED BY '' TERMINATED BY '\t'
	LINES TERMINATED BY '\n'
	IGNORE 2 LINES
	(sch, ringnr, rspec, rf, ch, rx, ra, rs, rb, p, rdate, rtime, ry, rar, rca, rcb, rq, rid);


# Load the finding data from 'ducks-recaptured.csv'
LOAD DATA LOCAL INFILE 'db/import/ducks-recaptured.csv' 
	INTO TABLE `raw_found_ducks`
	FIELDS ENCLOSED BY '' TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 2 LINES
	(@dummy,@dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, 
	sch, ringnr, fspec, ve, fx, fa, fdate,@dummy, fy, far, fca, fcb, fq, c, ci, tr, 
		pr, fs, fb, dist, dir, @dummy, fid, @dummy, @dummy, @dummy, @dummy, @dummy, ref, @dummy);

