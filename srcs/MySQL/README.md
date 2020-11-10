# MySQL container

This readme is dedicated to the MySQL container, subpart of the ft_services
project(school project, at 42).

## OVERVIEW

This container will host a MySQL database server. It is due to be accessed by
the container running the wordpress (and its dedicated nginx server), and by
the container running the phpmyadmin also.
Good practice has been followed.

## IMPLEMENTATION DETAILS & SECURITY GOOD PRACTICE

The mysqld (server version) in order to run first needs us to run the script:
```mysql_install_db```

It will creat the data directory and build all the necessary system tables.
It is good practice to provide the **--user argument**. It specifies the login
user name to use for running mysqld. And Files and directories created by
mysqld will be owned by this user. Therefor we can avoid running the server as
root (dangerous practice).

It is recommanded to start mysqld using a super_set script: `mysqld_safe`.
This script will make sure the **test** database and user are removed, and that
root user only has grants locally (localhost).

Unfortunately the `mysql_safe` script runs in the foreground forever.
We wanted to kick off the server and in the meantime connect the client to it
so that we could creat a wordpress database and an associated user.
To succeed in doing so we had to start mysqld_sqfe in a subshell and in the
background, and wait for it to start.

note: The mariadb-client is of no more use after this quick necessary set up.

The admin is "mysql" and it has a configurable password.
It also only has grants on local connexions for security reasons.

## ports:

Port 3306 is the default port for the classic MySQL protocol (port), which is
used by the mysql client,

## ENV variables (and their default values).

ENV __MYSQL_DB_NAME__ wordpress
ENV __MYSQL_DB_USER__ user
ENV __MYSQL_DB_PASSWD__ password
ENV __MYSQL_DB_IP_CLIENT__ 0.0.0.0

ENV __MYSQL_ADMIN__ mysql
ENV __MYSQL_ADMIN_PASSWD__ password_admin

note: __MYSQL_DB_IP_CLIENT__ is first to any adress as default. but it could be
set to a precise adress when setting up a cluster.
