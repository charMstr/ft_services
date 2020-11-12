#!/bin/sh

## install wordpress and edit wp-config.php
wp_install_and_edit_wp-config.sh

### DEBUG php_test_connexion
mkdir -p /usr/share/webapps/php_test_connexion/
chown nginx:www-data /usr/share/webapps/php_test_connexion
cp /tmp/php_test_connexion.php /usr/share/webapps/php_test_connexion/index.php
cp /tmp/php_test_connexion2.php /usr/share/webapps/php_test_connexion/index2.php
ln -s /usr/share/webapps/php_test_connexion /var/www/php_test_connexion
cd /var/www/php_test_connexion
sed -i "s/__WORDPRESS_DB_PASSWORD__/${__WORDPRESS_DB_PASSWORD__}/" index.php
sed -i "s/__WORDPRESS_DB_USERNAME__/${__WORDPRESS_DB_USERNAME__}/" index.php
sed -i "s/__WORDPRESS_DB_HOST__/${__WORDPRESS_DB_HOST__}/" index.php
cd -


### NGINX ###
# creat nginx /run/nginx folder
mkdir -p /run/nginx
#make logs available to docker
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log

### starting services ###
# start the FastCGI php module as a daemon.
# note: use "php-fpm7 -F" to start it in a daemon mode
php-fpm7
# start nginx as a non daemon
nginx -g "daemon off;"

#/bin/sh
