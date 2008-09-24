<?php
// ----------------------------------------------------------------------------
// Should replace the old convertAmersfoort.php, processCoordinates1.sql and 
// processCoordinates3.sql. 
// Converts the coordinates in raw-ducksRinged raw-ducksFound to decimal
// latitude and longitude. It uses the table temp-mergeRawCaptures to achieve
// this.

require_once '../../../config/database.php';

// There are four 'types of coordinates' in the original tables:
// 1) no coordinate given; this is expressed in different ways
// 2) Euring 2000 code (ca = "MMSS", cb="MMSS", q="E" or "W")
// 3) Rounded pseudo Euring style: (ca = "MMS-", cb="MMs-", q="E" or "W")
// 4) Amersfoort coordinate system: (ca = "### ", cb="### ", q="P")
//
// The script only processes case 2,3 and 4. The rest is assumed to be case 1,
// and will therefore result in NULL values in the captures table.
//

# Create table to keep track of manipulations
$query = "
  CREATE TABLE `manipulations` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
  `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  `type` VARCHAR( 50 ) NOT NULL ,
  `ref` VARCHAR( 50 ) NOT NULL
  ) ENGINE = innodb
";
	
$result = $mdb2->exec($query);

// Always check that result is not an error
if (PEAR::isError($result)) {
		echo $query;
        echo $result->getMessage()."\n";
	    exit(1);
}

// Coordinate type 2: Euring 2000 code
$query = "
INSERT INTO `capture_coordinates`
SELECT 
    sch,
    ringnr,
    occ,
	SUBSTRING(ca,1,2) + SUBSTRING(ca, 3,2)/60 ,
	IF(q = 'E',1,-1) * (SUBSTRING(cb,1,2) + SUBSTRING(cb, 3,2)/60)
FROM `temp_merge_raw_captures`
WHERE 
	(
        (
            SUBSTRING(ar,3,2) ='NL' AND q != 'N'
        ) OR (
            SUBSTRING(ar,3,2) != 'NL' AND 
            ca != 0 AND 
            cb !=0 AND
            (q = 'E' OR q = 'W')
        )
    ) AND
    NOT(SUBSTRING(ca,4,1)) = '-' AND
    NOT(SUBSTRING(cb,4,1)) = '-'
";
$result = $mdb2->exec($query);

// Always check that result is not an error
if (PEAR::isError($result)) {
		echo $query;
        echo $result->getMessage()."\n";
	    exit(1);
}


// Coordinate type 3: Rounded coordinates
// This should be reported in the cooAcc field, but this is not yet implemented.
$query="
INSERT INTO `capture_coordinates`
SELECT 
    sch,
    ringnr,
    occ,
	SUBSTRING(ca,1,2) + SUBSTRING(ca, 3,1)/6,
	SUBSTRING(cb,1,2) + SUBSTRING(cb, 3,1)/6
FROM  `temp_merge_raw_captures`
WHERE 
	CHAR_LENGTH(ca)=4 AND 
	CHAR_LENGTH(cb)=4 AND 
	(
		SUBSTRING(ca,4, 1) = '-' OR
		SUBSTRING(cb,4, 1) = '-'
	) AND
    (q = 'E' OR q = 'W')
    
";
$result = $mdb2->exec($query);

// Always check that result is not an error
if (PEAR::isError($result)) {
		echo $query;
        echo $result->getMessage()."\n";
	    exit(1);
}

// Coordinate type 4: Amersfoort coordinate
// These will be reported in the `manipulations` table

require_once 'convert_amersfoort.php';

$query = "
	SELECT 
		sch, ringnr, occ, ca, cb 
	FROM `temp_merge_raw_captures` 
	WHERE 
		SUBSTRING(ar,1,2) = 'NL' AND 
        q = 'N' AND
        ca != '' AND 
        cb != '' AND
        ca != '???' AND 
        cb != '???' AND
        ca != '...' AND 
        cb != '...' AND
        SUBSTRING(ca,3,1) != '.' AND 
        SUBSTRING(cb,3,1) != '.' AND 
        SUBSTRING(ca,1,1) != 'O' AND 
        SUBSTRING(cb,1,1) != 'O' AND 
        cb != '...' AND
        ca != '0' AND 
        cb != '0' AND
        ca != '000' AND 
        cb != '000' AND
        char_length(ca) < 4 AND
        char_length(cb) < 4 AND
        cb > ca AND
        ca >= -7 AND
        ca <= 300 AND
        cb >= 289 AND
        cb <= 629 AND
        NOT (ca = 123 AND cb = 456)
	";
	
$result = $mdb2->query($query);

// Always check that result is not an error
if (PEAR::isError($result)) {
		echo $query;
        echo $result->getMessage()."\n";
	    exit(1);
}
echo "Begin Amersfoort conversie...\n";

$res = $mdb2->beginTransaction();

while($row = $result->fetchRow()) {
	$sch = $row['sch'];
	$ringnr = $row['ringnr'];
	$occ = $row['occ'];
	$rx = $row['ca'];
	$ry = $row['cb'];
	rd2ec($rx,$ry,$eE,$eN);
	$query = "
    INSERT INTO `capture_coordinates`
    VALUES (
        '$sch',
        '$ringnr',
        '$occ',	
		'$eN',
		'$eE'
    )";
	$affected = $mdb2->exec($query);
	// Always check that result is not an error
    if (PEAR::isError($affected)) {
            echo $query;
            echo $affected->getMessage()."\n";
            exit(1);
    }
}
$res = $mdb2->commit();
echo "Einde Amersfoort conversie.\n";

// Update `manipulations` table
$query = "
INSERT INTO `manipulations` (`type`, `ref`)
SELECT 'Amersfoort', CONCAT(sch,' ',ringnr,' ',occ)
FROM `temp_merge_raw_captures` 
WHERE q = 'N'
";

$result = $mdb2->exec($query);

// Always check that result is not an error
if (PEAR::isError($result)) {
		echo $query;
        echo $result->getMessage()."\n";
	    exit(1);
}
