# This script converts data
#
# To add a script, simply copy paste an example line and change the name of the script.
#
# Make sure to put the error checking code after each command, so that the script stops whenever
# something goes wrong.

cd db/migrate/sql

echo "Ducks table..."
mysql --defaults-extra-file=../../../config/duck.cnf < ducks.sql 2>>error.txt
if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi

echo "First captures..."
mysql --defaults-extra-file=../../../config/duck.cnf < captures.sql 2>>error.txt
if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi

cd ../php

echo "Recaptures..."
php recaptures.php 

cd ../sql
echo "Count captures..."
mysql --defaults-extra-file=../../../config/duck.cnf < countCaptures.sql 2>>error.txt
if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi

echo "Convert age information..."
mysql --defaults-extra-file=../../../config/duck.cnf < age.sql 2>>error.txt
if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi

cd ../php
echo "Process coordinates..."
php processCoordinates.php 

cd ../sql

echo "Process countries and areas..."
mysql --defaults-extra-file=../../../config/duck.cnf < processLocations.sql 2>>error.txt
if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi

if $1; then
  echo "Process ringer information..."
  mysql --defaults-extra-file=../../../config/duck.cnf < ringer_id.sql 2>>error.txt
  if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi
fi

echo "Merge temporary table with captures table..."
mysql --defaults-extra-file=../../../config/duck.cnf < updateCaptures.sql 2>>error.txt
if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi

if $1; then 
  echo "Coordinates areas..."
  mysql --defaults-extra-file=../../../config/duck.cnf < coordinateArea.sql 2>>error.txt
  if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi
  
  echo "Process geotab table 1/4..."
  mysql --defaults-extra-file=../../../config/duck.cnf < processGeotab1.sql 2>>error.txt
  if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi
  cd ../php

  echo "Process geotab table 2/4..."
  php process_geotab.php

  cd ../sql

  echo "Process geotab table 3/4..."
  mysql --defaults-extra-file=../../../config/duck.cnf < processGeotab3.sql 2>>error.txt
  if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi

  cd ../php

  echo "Populate coordinateName"
  php coordinateName.php

  # Scripts dealing with eendenkooien

  cd ../sql

  echo "Convert trivial decoy data..."
  mysql --defaults-extra-file=../../../config/duck.cnf < kooiConvertTrivial.sql 2>>error.txt
  if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi

  echo "Process decoy provinces..."
  mysql --defaults-extra-file=../../../config/duck.cnf < kooiProvincies.sql 2>>error.txt
  if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi

  echo "Manually obtained decoy data..."
  mysql --defaults-extra-file=../../../config/duck.cnf < kooiHandmatig.sql 2>>error.txt
  if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi

  echo "Apply Hans criteria..."
  mysql --defaults-extra-file=../../../config/duck.cnf < kooiHansCriteria.sql 2>>error.txt
  if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi

  echo "Match ringing sites at decoys (no ringer identification)..."
  mysql --defaults-extra-file=../../../config/duck.cnf < kooiRidSite.sql 2>>error.txt
  if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi

  echo "Find ringers nearby decoys..."
  mysql --defaults-extra-file=../../../config/duck.cnf < kooiAfstandCriteriumMetRid.sql 2>>error.txt
  if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi

  echo "Find ringers nearby decoys without ringer identification..."
  mysql --defaults-extra-file=../../../config/duck.cnf < kooiAfstandCriteriumZonderRid.sql 2>>error.txt
  if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi

  echo "Combine all the decoy information and update 'captures' table..."
  mysql --defaults-extra-file=../../../config/duck.cnf < kooi.sql 2>>error.txt
  if [ -s error.txt ]; then echo "An error occured:" && cat error.txt && rm error.txt && exit 2; fi
fi

# And clean up:
if [ -f error.txt ]; then rm error.txt; fi
