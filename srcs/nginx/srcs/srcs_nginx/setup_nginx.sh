#!/bin/sh

#### NGINX:
# Forward request and error logs to Docker log collector
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log

#generating autosigned certificates for ssl demo (no prompt).
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=FR/O=krkr/OU=Domain Control Validated/CN=*.krkr.io" 2>&1 >/dev/null

#substitute the env variables in the server config
#note: rename it default.conf otherwise it doesnt work for some reason.
envsubst '$__WORDPRESS_IP__ $__PHPMYADMIN_IP__'  < /tmp/server_config > /etc/nginx/conf.d/default.conf
rm /tmp/server_config
