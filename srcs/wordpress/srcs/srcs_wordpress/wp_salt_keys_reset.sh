#!/bin/sh

#note: this script is designed to change the salt keys into the wp-config.php file
# it should be executed where the wp-config.php file is.

if [ ! -f ./wp-config.php ] 
then
	echo "ERROR: need to run this script in wp-config.php's directory."
	exit 1
fi

#get the new salt_keys.
wget https://api.wordpress.org/secret-key/1.1/salt/ -O wp_salt_keys.txt
#&>/dev/null
if [ $? -gt 0 ]
then
	echo " wget failed: salt keys could not be set/changed."
	exit 1
fi

while read -r SALT
do
	SEARCH="$(echo "$SALT" | cut -d "'" -f 2)"
	SEARCH=\'$SEARCH\'
	REPLACE=$(echo "$SALT" | cut -d "'" -f 4)
	#esacaping the special charaters so that they wont cause trouble in our final sed command
	ESCAPED_REPLACE=`echo "$REPLACE" | sed 's:[]\[\&\^\$\.\*\/]:\\\&:g'`
	NEWLINE="define( $SEARCH, '$ESCAPED_REPLACE' );"
	sed -i  "s/^define(.*$SEARCH.*/$NEWLINE/" ./wp-config.php
done < wp_salt_keys.txt

echo "wp-salt_keys_reset.sh: salt keys changed in wp-config.php!"

#delete the tempory file containing new salt keys
rm wp_salt_keys.txt
