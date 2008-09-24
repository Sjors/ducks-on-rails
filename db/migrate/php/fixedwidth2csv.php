<?php
	$fp = fopen("ducks-recaptured.tmp",r);
	# First line are the titles
	$titles = fgets($fp);
	echo $titles;
	# Second line indicates width of the colums
	$dashline = fgets($fp);
	echo $dashline;
	# Now process each line and put a comma between the columns
	while($line = fgets($fp)) {
		for($i=0; $i < strlen($line);$i++) { 
			if($dashline[$i] == " ") {
				$line[$i] = ",";
			}		
		}
		// Very unelegant way to deal with fdate (will break if someone adds or removes a field):
		$line[189] = ",";
	

		echo $line;
	}
?>
