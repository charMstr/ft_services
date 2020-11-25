#!/bin/sh

#creat a ICP socket connexion, and place it in /run/php-fpm7
# the socket is referenced in both our custom php-fpm/www.conf
# and /etc/nginx/conf.d/phpmyadmin_server.conf files.
if [ ! -d "/run/php-fpm7" ]; then
	mkdir -p /run/php-fpm7/
fi
chown -R nginx:www-data /run/php-fpm7/

#creat folder where we will put our webapp phpmyadmin
#creat at the same time the tmp folder to avoid a futur warning
mkdir -p /usr/share/webapps/phpmyadmin/tmp

#unzip at the correct location and give
# strip-component option so that we unzip inside the existing folder
tar zxvf /tmp/phpmyadmin.tar.gz --strip-components=1 -C /usr/share/webapps/phpmyadmin/ 2>&1 > /dev/null

#Change the folder permissions
#chmod -R 777 /usr/share/webapps/
chown -R nginx:www-data /usr/share/webapps/

#Create a symlink to the phpmyadmin folder from the nginx server root dir
ln -s /usr/share/webapps/phpmyadmin/ /var/www/phpmyadmin

# replace the variables in the phymyadmin config file, and place this in the
# correct location.
envsubst '$__DB_NAME__ $__DB_USERNAME__ $__DB_PASSWORD__ $__DB_HOST__' < /tmp/config.inc.php > /usr/share/webapps/phpmyadmin/config.inc.php
# then make sure the config adjustements happened correctly
if [ $? -ne 0 ]
then
	echo "envsubst command failed"
	exit 1
fi

#delete tar file. and tmp/config.inc.php
rm /tmp/phpmyadmin.tar.gz
rm /tmp/config.inc.php

