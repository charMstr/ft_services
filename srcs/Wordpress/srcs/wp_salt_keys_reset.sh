#!/bin/sh

#note: this script is designed to change the salt keys into the wp-config.php file
# it should be executed where the wp-config.php file is.

#get the new salt_keys.
wget https://api.wordpress.org/secret-key/1.1/salt/ -O wp_salt_keys.txt &>/dev/null
if [ $? -gt 0 ]
then
	echo " wget failed: salt keys could not be set/changed."
	exit
fi

#delete all the lines regarding the 8 satl keys
grep -v "'AUTH_KEY" wp-config.php > wp-config.php.tmp && mv wp-config.php.tmp wp-config.php
grep -v "SECURE_AUTH_KEY" wp-config.php > wp-config.php.tmp && mv wp-config.php.tmp wp-config.php
grep -v "LOGGED_IN_KEY" wp-config.php > wp-config.php.tmp && mv wp-config.php.tmp wp-config.php
grep -v "NONCE_KEY" wp-config.php > wp-config.php.tmp && mv wp-config.php.tmp wp-config.php
grep -v "'AUTH_SALT" wp-config.php > wp-config.php.tmp && mv wp-config.php.tmp wp-config.php
grep -v "SECURE_AUTH_SALT" wp-config.php > wp-config.php.tmp && mv wp-config.php.tmp wp-config.php
grep -v "LOGGED_IN_SALT" wp-config.php > wp-config.php.tmp && mv wp-config.php.tmp wp-config.php
grep -v "NONCE_SALT" wp-config.php > wp-config.php.tmp && mv wp-config.php.tmp wp-config.php

#place the new keys at the bottom of the file
echo "" >> wp-config.php
cat wp_salt_keys.txt >> wp-config.php

echo "salt keys changed!"

#delete the tempory file containing new salt keys
rm wp_salt_keys.txt
