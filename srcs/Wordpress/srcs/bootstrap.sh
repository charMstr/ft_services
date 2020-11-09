#!/bin/sh

### NGINX ###
# creat nginx /run/nginx folder
mkdir -p /run/nginx
#make logs available to docker
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log

### WORDPRESS ###
wp_install.sh

### starting services ###
# start nginx as a non daemon
#nginx -g "daemon off;"

/bin/sh
