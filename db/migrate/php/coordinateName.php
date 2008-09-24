<?php
// ----------------------------------------------------------------------------
// Populate coordinate_names
// Because any lat, lon combinations can have several names, the column
// occ is used to distinguish them. 
 
require_once '../../../config/database.php';

// First clean up
$query = "
  CREATE TABLE `coordinate_names` (
  `lat` DECIMAL(10,7),
  `lon` DECIMAL(10,7),
  `occ` INT NOT NULL,
  `name` VARCHAR( 50 ) NOT NULL ,
  PRIMARY KEY ( `lat` , `lon` , `occ` ) ,
  INDEX ( `name` )
  ) ENGINE = innodb;
";
	
$result = $mdb2->exec($query);

// Always check that result is not an error
if (PEAR::isError($result)) {
		echo $query;
        echo $result->getMessage()."\n";
	    exit(1);
}


$res = $mdb2->beginTransaction();
$query = "
	SELECT DISTINCT lat, lon 
    FROM `temp_geotab` WHERE 1
	";
	
$result = $mdb2->query($query);


// Always check that result is not an error
if (PEAR::isError($result)) {
		echo $query;
        echo $result->getMessage();
	    exit(1);
}

while($location = $result->fetchRow()) {
    $occ = 1;
    $lat = $location['lat'];
    $lon = $location['lon'];
    $query = "
        SELECT DISTINCT geoname
        FROM `temp_geotab`
        WHERE 
            lat = '$lat' AND 
            lon = '$lon' AND
            geoname IS NOT NULL AND
            geoname != 'NULL' AND
            geoname != ''
        ";
        
    $names = $mdb2->query($query);
    if (PEAR::isError($names)) {
            echo $query;
            echo $names->getMessage();
	        exit(1);
    }
    while($nameRow = $names->fetchRow()) {
        $name = $nameRow['geoname'];
        $name = $mdb2->quote($name, 'text');
        $query = "
            INSERT INTO `coordinate_names` 
                (`lat`, `lon`, `occ`, `name`) 
                VALUES ('$lat', '$lon', '$occ', $name);
            ";
            
        $insert = $mdb2->exec($query);
        if (PEAR::isError($insert)) {
                echo $query;
                echo $insert->getMessage()."\n";
	            exit(1);
        }
        $occ ++;
    }
}
   
$res = $mdb2->commit();

