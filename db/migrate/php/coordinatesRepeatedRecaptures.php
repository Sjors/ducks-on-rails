<?php
require_once '../database.php';

# Pseudocode:
#for all ducks where totalcaptures > 1
#  captures = select all captures where postcode is regexp 'nnnn ll': occ, date, ringer_id, postcode : order by date ASC
#  for all distinct postcode
#  for all captures with that 
#    if lat!=null and lon!=null then known = true
#    if known $lat = lat, $lon = lon, $postcode, $rid
#    if unknown: lat = $lat, lon = $lon
#  end
    


$res = $mdb2->beginTransaction();

$sql = "
SELECT * FROM `crc_countCaptures` WHERE captures > 1
";

$result = $mdb2->query($sql);

// Always check that result is not an error
if (PEAR::isError($result)) {
		echo $sql;
        echo $result->getMessage();
	    exit(1);
}
$ducks = $result;
while($duck = $ducks->fetchRow()) {
  $sch = $duck['sch'];
  $ringnr = $duck['ringnr'];
  # Get distinct postal codes
  $sql = "
  SELECT DISTINCT POSTCODE
  FROM 
    `crc_captures` c 
    JOIN `crc_ringerCaptures` r 
      ON r.sch = c.sch AND r.ringnr = c.ringnr AND r.occ = c.occ
    JOIN `crc_adresses` a 
      ON r.ringer_id = a.KODE
    LEFT JOIN `crc_captureCoordinates` co 
      ON co.sch = c.sch AND co.ringnr = c.ringnr AND co.occ = c.occ
  WHERE  
    c.sch = '$sch' AND 
    c.ringnr = '$ringnr' AND
    POSTCODE REGEXP '^[[:digit:]][[:digit:]][[:digit:]][[:digit:]] [[:alpha:]][[:alpha:]]$'
  ORDER BY 'date' ASC
  ";

  $result = $mdb2->query($sql);

  // Always check that result is not an error
  if (PEAR::isError($result)) {
      echo $sql;
          echo $result->getMessage();
        exit(1);
  } 
  $postcodes = $result;
  while($row = $postcodes->fetchRow()) {
    $postcode = $row['postcode'];
    # Fetch all captures with that postal code
    $sql = "
    SELECT lat, lon, c.occ as occ
    FROM 
      `crc_captures` c 
      JOIN `crc_ringerCaptures` r 
        ON r.sch = c.sch AND r.ringnr = c.ringnr AND r.occ = c.occ
      JOIN `crc_adresses` a 
        ON r.ringer_id = a.KODE
      LEFT JOIN `crc_captureCoordinates` co 
        ON co.sch = c.sch AND co.ringnr = c.ringnr AND co.occ = c.occ
    WHERE  
      c.sch = '$sch' AND 
      c.ringnr = '$ringnr' AND
      POSTCODE = '$postcode'
    ORDER BY 'date' ASC
    ";
    $result = $mdb2->query($sql);

    // Always check that result is not an error
    if (PEAR::isError($result)) {
        echo $sql;
            echo $result->getMessage();
          exit(1);
    } 
    $captures = $result;
    while($capture = $captures->fetchRow()) {
      if ($capture['lat'] == NULL and $capture['lon'] == NULL) 
      {
        $occ = $capture['occ'];
        $sql = "
        INSERT INTO `crc_captureCoordinates` 
          (sch, ringnr, occ, lat, lon)
        VALUES ('$sch', '$ringnr', '$occ', '$lat','$lon')
        ";
        $result = $mdb2->exec($sql);

        // Always check that result is not an error
        if (PEAR::isError($result)) {
            echo $sql;
                echo $result->getMessage();
              exit(1);
        }
      } else 
      {
        $lat = $capture['lat'];
        $lon = $capture['lon'];
      }
    }
  }
}

$res = $mdb2->commit();
