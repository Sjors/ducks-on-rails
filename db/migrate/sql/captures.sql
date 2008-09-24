DROP TABLE IF EXISTS `temp_merge_raw_captures`;
CREATE TABLE `temp_merge_raw_captures` (
    `sch` VARCHAR( 3 ) NOT NULL ,
    `ringnr` VARCHAR( 8 ) NOT NULL ,
    `occ` INT NOT NULL ,
    `ca` VARCHAR( 4 ) NOT NULL COMMENT 'rca, fca',
    `cb` VARCHAR( 4 ) NOT NULL COMMENT 'rcb, fcb',
    `q` VARCHAR( 1 ) NOT NULL COMMENT 'rq, fq',
    `ar` VARCHAR( 4 ) NOT NULL COMMENT 'rar, far',
    `a` VARCHAR(1) NULL,
    `age` INT NULL,
    `rid` VARCHAR(3),
    PRIMARY KEY ( `sch` , `ringnr` , `occ` )
)
ENGINE = innodb;

ALTER TABLE `temp_merge_raw_captures` ADD INDEX ( `ar` ) ;
ALTER TABLE `temp_merge_raw_captures` ADD INDEX ( `q` ) ;
ALTER TABLE `temp_merge_raw_captures` ADD INDEX ( `ca` ) ;
ALTER TABLE `temp_merge_raw_captures` ADD INDEX ( `cb` ) ;
ALTER TABLE `temp_merge_raw_captures` ADD INDEX ( `age` ) ;
ALTER TABLE `temp_merge_raw_captures` ADD INDEX ( `rid` ) ;

-- Load ringing events (i.e. first captures)
INSERT INTO `captures` (sch, ringnr, occ, date, dateAcc)
    SELECT 
        sch, 
        ringnr, 
        1, 
        rdate, 
        ry 
   FROM `raw_ringed_ducks`  
   WHERE 1;

-- Load ringing events and extra data in temporary merge table
INSERT INTO `temp_merge_raw_captures` (sch, ringnr, occ, ca, cb, q, ar,a,rid)
    SELECT sch, ringnr, 1, rca, rcb, rq, rar, ra, rid FROM `raw_ringed_ducks`;  
