# PHMYQADMIN CONTAINER

This readme is dedicated to the PhpMyAdmin container, subpart of the
ft_services project(school project, at 42).

## OVERVIEW

This container will host a phpmyadmin application, and its personal ngnix
server, passing php requestst to php-fmp (FastCGI).
This container will interact with the container containing the Mysql server.

PhpMyAdmin is providing a nice UI to viewing/managing our mysql database.
It is an application written in php, just like wordpress, that will be accessed
in our case through the Nginx server.

## IMPLEMENTATION DETAILS & SECURITY GOOD PRACTICE

Nginx redirects to the root directory
where phpmyadmin has been installed. The redirection is done by first
recognising the fact that we have a .php on port 5000, then forwarding the work
to php-fpm (FastCGI style, so all the requests are process on an external
process: php-fpm).

The Nginx proxies this request to php-fpm, i chose to update a bit the set ups
i found on the internet and make it happen through a unix domain socket instead
of a TCP/IP socket. Possible because we run both processes on the same machine,
its quicker and this reduces security attack surface by itself. That was just a
good exercice.

## RUNNING PROCESSES IN THE SAME CONTAINER

- Nginx
- php-fpm7

## PORTS:

- 5000

## ENV VARIABLES (and their default values):

- \_\_WORDPRESS_DB_NAME\_\_ wordpress
- \_\_WORDPRESS_DB_USERNAME\_\_ user
- \_\_WORDPRESS_DB_PASSWORD\_\_ password
- \_\_WORDPRESS_DB_HOST\_\_ 127.0.0.1

## LOGS

nginx logs are made available to docker.
