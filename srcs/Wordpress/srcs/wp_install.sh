#!/bin/sh

#creat the folder webapps
mkdir -p /usr/share/webapps/
#download unzip -then delete- the latest version of wordpress in webapps.
wget -P /usr/share/webapps/ http://wordpress.org/latest.tar.gz 
tar -xzvf /usr/share/webapps/latest.tar.gz -C /usr/share/webapps/
rm -rf /usr/share/webapps/latest.tar.gz
#change ownership of file to nginx so that it can access it.
chown -R nginx /usr/share/webapps/
# now we should either do a sym link from /var/www/aha_archi to our folder.
ln -s /usr/share/webapps/wordpress /var/www/aha_archi

cd /usr/share/webapps/wordpress
#copy the sample file into wp-config.php file and make adjustements to config.
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/${__WORDPRESS_DB_NAME__}/" wp-config.php
sed -i "s/password_here/${__WORDPRESS_DB_PASSWORD__}/" wp-config.php
sed -i "s/username_here/${__WORDPRESS_DB_USERNAME__}/" wp-config.php
sed -i "s/localhost/${__WORDPRESS_DB_HOST__}/" wp-config.php

## security enhancement of the wordpress:
#change the table prefix (avoid "wp_" = avoid most sql injections attack)
sed -i "s/'wp_'/'$__WORDPRESS_DB_TABLE_PREFIX__'/" wp-config.php

#run the script that will set/change the salt keys automatically in wp-config.php
wp_salt_keys_reset.sh
cd -
