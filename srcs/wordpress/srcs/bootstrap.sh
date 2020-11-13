#!/bin/sh

## install wordpress and edit wp-config.php
wp_install_and_edit_wp-config.sh

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
