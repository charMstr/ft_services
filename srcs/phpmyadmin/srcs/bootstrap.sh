#!/bin/sh

#we will make a Unix domain connexion between nginx an php-fpm to uincrease speed and security
# creat the folder where the socket will be created.
# the socket is referenced in both our custom php-fpm/www.conf
# and /etc/nginx/conf.d/phpmyadmin_server.conf files.
if [ ! -d "/run/php-fpm7" ]; then
	mkdir -p /run/php-fpm7/
fi
chowm -R nginx:www-data /run/php-fpm7/

#creat folder where we will put our webapp phpmyadmin
mkdir -p /usr/share/webapps/phpmyadmin

#unzip at the correct location and give
# strip-component option so that we unzip inside the existing folder
tar zxvf /tmp/phpmyadmin.tar.gz --strip-components=1 -C /usr/share/webapps/phpmyadmin/
#delete tar file.
rm /tmp/phpmyadmin.tar.gz

#Change the folder permissions
chmod -R 777 /usr/share/webapps/
chown -R nginx:www-data /usr/share/webapps/

#Create a symlink to the phpmyadmin folder from the nginx server root dir
ln -s /usr/share/webapps/phpmyadmin/ /var/www/phpmyadmin


### NGINX ###
# creat nginx /run/nginx folder
mkdir -p /run/nginx
#make logs available to docker
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log

/bin/sh
exit
#start php-fpm7
php-fpm7
# start nginx as a non daemon
nginx -g "daemon off;"
