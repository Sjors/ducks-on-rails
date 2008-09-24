#!/bin/bash
cd db/import
# First $1.rpt

# Delete (potential) old output files
rm $1.tmp -f
rm $1.tmp.out -f
rm ducks-ringed-tab.rpt -f

# Create temporary file to work on
cp $1 $1.tmp
chmod +w $1.tmp

# Convert from DOS to Linux format
dos2unix $1.tmp

# Delete last 3 lines (slightly unelegant...)
sed '$d' $1.tmp > $1.tmp.out
mv $1.tmp.out $1.tmp
sed '$d' $1.tmp > $1.tmp.out
mv $1.tmp.out $1.tmp
sed '$d' $1.tmp > $1.tmp.out
mv $1.tmp.out $1.tmp

# Separate fields with tabs in stead of spaces
sed 's/  */\t/g' $1.tmp > $1.tmp.out
mv $1.tmp.out $1.tmp

# Rename temporary file to output file
mv $1.tmp ducks-ringed-tab.rpt

# Then $2.rpt
# This one is a bit more problematic, so we use fixedwidth2csv.php

# Delete (potential) old output files
rm ducks-recaptured.tmp -f
rm ducks-recaptured.tmp.out -f
rm ducks-recaptured-tab.rpt -f

# Create temporary file to work on
cp $2 ducks-recaptured.tmp
chmod +w ducks-recaptured.tmp

# Convert from DOS to Linux format
sed 's/.$//' ducks-recaptured.tmp > ducks-recaptured.tmp.out
mv ducks-recaptured.tmp.out ducks-recaptured.tmp

# Delete last 3 lines (slightly unelegant...)
sed '$d' ducks-recaptured.tmp > ducks-recaptured.tmp.out
mv ducks-recaptured.tmp.out ducks-recaptured.tmp
sed '$d' ducks-recaptured.tmp > ducks-recaptured.tmp.out
mv ducks-recaptured.tmp.out ducks-recaptured.tmp
sed '$d' ducks-recaptured.tmp > ducks-recaptured.tmp.out
mv ducks-recaptured.tmp.out ducks-recaptured.tmp

# Convert to CSV format
php ../migrate/php/fixedwidth2csv.php > ducks-recaptured.tmp.out
mv ducks-recaptured.tmp.out ducks-recaptured.tmp

# Rename temporary file to output file
mv ducks-recaptured.tmp ducks-recaptured.csv

