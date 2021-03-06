<?php
    // Converts coordinates in `raw_geotab` the way as those in 
    // `raw-(found/ringed)-ducks`. After that converts area information.
    // The result is added to coordinateArea.

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
// Clean up:
//

// First clean up
$query = "
    UPDATE `temp_geotab` SET lat = NULL, lon = NULL WHERE 1;
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
UPDATE `temp_geotab` SET
lat = SUBSTRING(lat_dm,1,2) + SUBSTRING(lat_dm, 3,2)/60 ,
lon = IF(q = 'E',1,-1) * (SUBSTRING(lon_dm,1,2) + SUBSTRING(lon_dm, 3,2)/60)
WHERE 
	(
        (
            SUBSTRING(area,3,2) ='NL' AND q != 'N'
        ) OR (
            SUBSTRING(area,3,2) != 'NL' AND 
            lat_dm != 0 AND 
            lon_dm !=0 AND
            (q = 'E' OR q = 'W')
        )
    ) AND
    NOT(SUBSTRING(lat_dm,4,1)) = '-' AND
    NOT(SUBSTRING(lon_dm,4,1)) = '-'
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
UPDATE `temp_geotab` SET
lat = SUBSTRING(lat_dm,1,2) + SUBSTRING(lat_dm, 3,1)/6,
lon = SUBSTRING(lon_dm,1,2) + SUBSTRING(lon_dm, 3,1)/6
WHERE 
	CHAR_LENGTH(lat_dm)=4 AND 
	CHAR_LENGTH(lon_dm)=4 AND 
	(
		SUBSTRING(lat_dm,4, 1) = '-' OR
		SUBSTRING(lon_dm,4, 1) = '-'
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
// These will be reported in the `crc_manipulations` table

require_once 'convert_amersfoort.php';

$query = "
	SELECT id, ca, cb 
	FROM `temp_geotab` 
	WHERE 
		SUBSTRING(area,1,2) = 'NL' AND 
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
echo "Begin Amersfoort conversie... \n";

$res = $mdb2->beginTransaction();

while($row = $result->fetchRow()) {
    $id = $row['id'];
	$rx = $row['ca'];
	$ry = $row['cb'];
	rd2ec($rx,$ry,$eE,$eN);
	$query = "
    UPDATE `temp_geotab` 
    SET lat = '$eN', lon = '$eE' 
    WHERE id = '$id'
    ";
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



?>
