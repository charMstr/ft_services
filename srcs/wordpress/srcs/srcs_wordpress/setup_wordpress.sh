#!/bin/sh
  
#creat the directory in which all the webapps will land (good practice).
mkdir -p /usr/share/webapps
# unzip the latest version of wordpress in directory.
tar -xzf /tmp/latest.tar.gz  -C /usr/share/webapps/
#make sure we can upload images to the wp-content directory.
mkdir -m 777 /usr/share/webapps/wordpress/wp-content/uploads

#make all the sudirectories and files available to nginx
chown -R nginx:www-data /usr/share/webapps/
#clean the /tmp folder
rm -rf /tmp/latest.tat.gz

# do a sym link from /var/www/aha_archi to the place where we will untar.
# note: aha_archi is the root for our nginx server
ln -s /usr/share/webapps/wordpress /var/www/wordpress

################ EDITING wp-config.php
cd /usr/share/webapps/wordpress

#copy the sample file into wp-config.php file and make adjustements to config.
mv  ./wp-config-sample.php wp-config.php

sed -i "s/database_name_here/${__WORDPRESS_DB_NAME__}/" wp-config.php
sed -i "s/password_here/${__WORDPRESS_DB_PASSWORD__}/" wp-config.php
sed -i "s/username_here/${__WORDPRESS_DB_USERNAME__}/" wp-config.php
sed -i "s/localhost/${__WORDPRESS_DB_HOST__}:${__WORDPRESS_DB_PORT}/" wp-config.php

## security enhancement of the wordpress:
#change the table prefix (avoid "wp_" = avoid most sql injections attack)
sed -i "s/'wp_'/'$__WORDPRESS_DB_TABLE_PREFIX__'/" wp-config.php

#run the script that will set/change the salt keys automatically in wp-config.php
wp_salt_keys_reset.sh

cd -
################ DONE EDITING wp-config.php
