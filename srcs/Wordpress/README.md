# NGINX container

This readme is dedicated to the Wordpress container, subpart of the ft_services
project(school project, at 42).

## OVERVIEW

The container will host a word press site. it will also run its own nginx
server.
The container will have a database running in a separate container.
The server is placed inside /var/www/aha_archi (it is actually a symlink to
/usr/share/webapps/wordpress)

## ports:
Nginx is listening on the port 5050.

## ENV variables (and their default values).

__WORDPRESS_DB_NAME__ wordpress
__WORDPRESS_DB_USERNAME__ user
__WORDPRESS_DB_PASSWORD__ password
__WORDPRESS_DB_HOST__ 127.0.0.1
__WORDPRESS_DB_TABLE_PREFIX__ aha_archi_wp_

## SECURITY:
the table_prefix is not left to wp_ in order to avoid common sql injections.
the salt keys are set and can be changed though the use of the script:
`wp_salt_keys_reset.sh`
