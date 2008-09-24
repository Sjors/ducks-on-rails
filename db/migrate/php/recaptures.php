<?php
// ----------------------------------------------------------------------------
// Processes raw-found-ducks; the ducks that are after they have been
// ringed. 

// Note: the INSERT part of this script is very inefficient because InnoDB 
// tries to reindex the primary key (sch, ringnr, occ) all the time. 
// This can probably be improved drasticly by using transactions. Be carefull
// however not to make them too big.
 
require_once '../../../config/database.php';

// First clean up
$query = "
	DELETE FROM `captures`
    WHERE occ > 1;
	";
	
$result = $mdb2->exec($query);

// Always check that result is not an error
if (PEAR::isError($result)) {
		echo $query;
        echo $result->getMessage()."\n";
	    exit(1);
}

$query = "
	DELETE FROM `temp_merge_raw_captures`
    WHERE occ > 1;
	";
	
$result = $mdb2->exec($query);

// Always check that result is not an error
if (PEAR::isError($result)) {
		echo $query;
        echo $result->getMessage()."\n";
	    exit(1);
}




// Process the recaptures:

$query = "
	SELECT sch, ringnr
    FROM `raw_found_ducks`
    WHERE 1
    GROUP BY sch, ringnr
	";
	
$result = $mdb2->query($query);


// Always check that result is not an error
if (PEAR::isError($result)) {
		echo $query;
        echo $result->getMessage();
	    exit(1);
}

while($duck = $result->fetchRow()) {
    $occ = 2;
    $sch = $duck['sch'];
    $ringnr = $duck['ringnr'];
    $query = "
        SELECT *
        FROM `raw_found_ducks`
        WHERE sch = '$sch' AND ringnr = '$ringnr' 
        ORDER BY fdate
        ";
        
    $duckcaptures = $mdb2->query($query);
    if (PEAR::isError($duckcaptures)) {
            echo $query;
            echo $duckcaptures->getMessage();
	        exit(1);
    }
    while($capture = $duckcaptures->fetchRow()) {
        $fdate = $capture['fdate'];
        $fy = $capture['fy'];
        $c = $capture['c'];
        $ci = $capture['ci'];
        $fca = $capture['fca'];
        $fcb = $capture['fcb'];
        $fq = $capture['fq'];
        $far = $capture['far'];
        $fa = $capture['fa'];
        $fid = $capture['fid'];
        $query = "
            INSERT INTO `captures` 
                (`sch`, `ringnr`, `occ`, `date`, `dateAcc`, `condition`, `circumstances`) 
                VALUES ('$sch', '$ringnr', '$occ', '$fdate', '$fy', '$c', '$ci');
            ";
            
        $insert = $mdb2->exec($query);
        if (PEAR::isError($insert)) {
                echo $query;
                echo $insert->getMessage()."\n";
	            exit(1);
        }
        $query = "
            INSERT INTO `temp_merge_raw_captures` 
            (`sch`,`ringnr`,`occ`,`ca`,`cb`,`q`,`ar`,`a`,`rid`)
            VALUES ('$sch', '$ringnr', '$occ','$fca', '$fcb', '$fq', '$far', '$fa', '$fid') ;
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
   

