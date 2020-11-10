# WORDPRESS CONTAINER

This readme is dedicated to the Wordpress container, subpart of the ft_services
project(school project, at 42).

## OVERVIEW

The container will host a wordpress site. it will also run its own nginx
server.
The container will have a database running in a separate container.
The server is placed inside /var/www/aha_archi (it is actually a symlink to
/usr/share/webapps/wordpress)

## IMPLEMENTATION DETAILS

The user and password should be te same when running the mysql container.

## PORTS:
Nginx is listening on the port 5050.

## ENV variables (and their default values).

- \_\_WORDPRESS_DB_NAME\_\_ wordpress
- \_\_WORDPRESS_DB_USERNAME\_\_ user
- \_\_WORDPRESS_DB_PASSWORD\_\_ password
- \_\_WORDPRESS_DB_HOST\_\_ 127.0.0.1
- \_\_WORDPRESS_DB_TABLE_PREFIX\_\_ aha_archi_wp_

_Mainly used for dynamically updating the **wp-config.php** file when building image
and starting the container._

## SECURITY:

the table_prefix is not left to wp_ in order to avoid common sql injections.
the salt keys are set and can be changed though the use of the script:
`wp_salt_keys_reset.sh`
