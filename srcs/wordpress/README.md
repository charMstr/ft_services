# WORDPRESS CONTAINER

This readme is dedicated to the Wordpress container, subpart of the ft\_services
project(school project, at 42).

## OVERVIEW

The container will host a wordpress site. it will also run its own nginx
server.
The container will have a database running in a separate container.
The server is placed inside /var/www/aha\_archi (it is actually a symlink to
/usr/share/webapps/wordpress)

## IMPLEMENTATION DETAILS

The user, password, and ip\_host/ip\_client in the wordpress container should
match the mysql database container.

Wrodpress is a php application.
Nginx by default does not process php requests on its own.
We will install php-fpm for this task. It is basically a FastCGI Process
Manager (FPM).

_**Note:**CGI (Common Gateway Interface) means all requests are redirected into
a unique process. Unlike CGI, with FastCGI, a process runs independently of
the Web server, isolating it and thus providing more security. Therefore
php-fmp will be a single process handling **ALL** php scritps for Nginx (for
all its requests) from the outside._

The mysql client is part of the php dependencies. Since we use a php 7 version,
the old php-mysql packages needs to be replaced by php-mysqli packages.

In the wordpress installation folder, activate the debug option within the file
wp-config.php and life will be easier while troubleshoting.
## WORDPRESS INSTALLATION

the instalation is done through a tar ball. we could have used wp-cli directly
with the wp-cli download command.
note: we also could have used wp-cli to create the wp-config.php.
Then the famous "5 minutes install" is only done if the database is not
populated yet.

## RUNNING SERVICES IN THE SAME CONTAINER:

- Nginx
- php-fpm7

## PORTS:

- 5050

Nginx is listening on the port 5050, this is internal to the cluster. (behind
the metalLB load balancer or the main "Nginx container").

## ENV variables (and their default values).

- \_\_WORDPRESS\_DB\_NAME\_\_=wordpress
- \_\_WORDPRESS\_DB\_USERNAME\_\_=user
- \_\_WORDPRESS\_DB\_PASSWORD\_\_=password
- \_\_WORDPRESS\_DB\_HOST\_\_=127.0.0.1
- \_\_WORDPRESS\_DB\_TABLE\_PREFIX\_\_=aha\_archi\_wp\_

_Mainly used for dynamically updating the **wp-config.php** file when building image
and starting the container._

## SECURITY:

The table\_prefix is not left to wp\_ in order to avoid common sql injections.
In the wp-config file, the salt keys are set, thanks to the **[link](https://api.wordpress.org/secret-key/1.1/salt/)**
from their official website and can be changed though the use of the script:
`wp_salt_keys_reset.sh`
