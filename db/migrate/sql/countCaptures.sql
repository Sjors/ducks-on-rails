-- Counts the number of times each duck has been captured.
-- It helps to speed up other scripts.
DROP TABLE IF EXISTS `capture_counts`;
CREATE TABLE `capture_counts` (
`sch` VARCHAR( 3 ) NOT NULL ,
`ringnr` VARCHAR( 8 ) NOT NULL ,
`captures` INT NOT NULL ,
PRIMARY KEY ( `sch` , `ringnr` ),
FOREIGN KEY
    (sch, ringnr)
    REFERENCES `captures` (sch, ringnr) ON DELETE CASCADE
) ENGINE = innodb;

INSERT INTO `capture_counts` (`sch`, `ringnr`, `captures`)
    SELECT sch, ringnr, max(occ) 
    FROM `captures`
    GROUP BY sch, ringnr;


