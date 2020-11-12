# MYSQL CONTAINER

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
It is good practice to provide the **--user=...** argument. It specifies the login
user name to use for running mysqld. And Files and directories created by
mysqld will be owned by this user. Therefor we can avoid running the server as
root (dangerous practice).

It is recommanded to start mysqld using the script: `mysqld_safe`.
It is a superset of the `mysqld` script with security enhancements.
This script will make sure the **test** database and user are removed, and that
root user only has grants locally (localhost), and is not used to start the
server.

Unfortunately the `mysql_safe` script runs in the foreground forever.
We wanted to kick off the server and in the meantime connect the client to it
so that we could creat a wordpress database and an associated user.
To succeed in doing so we had to start mysqld_sqfe in a subshell and in the
background, and wait for it to start.

**Note:** The mariadb-client is of no more use after this quick necessary set up.
But running another RUN layer at dockerfile level would actually enhance the
image since, when trying to remove apt virtual paquets (apt **--virtual** option).

The admin is "mysql" and it has a configurable password.
It also only has grants on local connexions for security reasons.

For training purpose the configuration options have been written in a .cnf file
that is place into /etc/my.cnf.d.
The /etc/my.cnf is automatically created with the `mysqld_install_db` script
and includes any file.cnf found in /etc/my.cnf.d directory.
The equivalent command line sequences are written as comments.


The mysql server will be started with the "mysql" system account.(root should
be avoided for security reasons).
 When installing the mysql server with the script mysql_install_db, a mysql
 database admin account is created along with the same name. We will change its
name and give it a new password.
We also make sure it is only able to connect locally (security reasons). This
user has super right over the entirity of the databases, including the
wordpress database, but also the system tables etc.

We created a user that is only being granted access to the wordpress
database, and not the entire set of databases in the mysql server. This user
will be able to connect remotely.

### TIP: the DB_USER in the wp-config.php file will be the user connecting the 
database as a client, it will in our case access the wordpress database.
Within this database, we will find in the subtable wp_users the different 
wordpress users like admins, editors etc. DB_USER and wp_users are two different things.

## RESSOURCES:

Regarding the configuration options file of mysql, on the oficial website can be
found a guide at how they work in general:

[https://mariadb.com/kb/en/configuring-mariadb-with-option-files/#options]

and a through list of all available options:

[https://mariadb.com/kb/en/full-list-of-mariadb-options-system-and-status-variables/]

## PORTS:

- 3306 

it is the default port for the classic MySQL protocol (port), which is
used by the mysql client,

## ENV VARIABLES (and their default values):

- \_\_MYSQL_DB_NAME\_\_ wordpress
- \_\_MYSQL_DB_USER\_\_ user
- \_\_MYSQL_DB_PASSWD\_\_ password
- \_\_MYSQL_DB_IP_CLIENT\_\_ 0.0.0.0

- \_\_MYSQL_ADMIN\_\_ mysql
- \_\_MYSQL_ADMIN_PASSWD\_\_ password_admin

note: \_\_MYSQL_DB_IP_CLIENT\_\_ is first to any adress as default. but it could be
set to a precise adress when setting up a cluster.

## LOGS

The prefix log name is set to _"mysql_log_"_ and can be modified in the .cnf
file, thanks to the **log-basename** option. This prefix will be appended at
the begining of all log files created. It makes the name of the log files
independant of the host name, thus very usefull when using replication.

The logs connected to docker(redirection to stdout) are the ones originating
from the mysqld_safe script (also sending logs from mysqld).

Logs from the database important actions(CREATE, ALTER, INSERT, UPDATE and
DELETE) are also recorded,  thanks to the **_log-bin_** option. But for now
they are not redirected to docker log collection.

## REASONS IT DID NOT WORK

The default mariadb-server.cnf conf file found at the /etc/my.cnf.d/ location
contains a line that makes it available only on localhost.
`skip-networking` option should be commented out (off by default).

A simple error in the file being redirect into the mysql client for the
creation of the database would stop the container. It is probably a fail-safe
proof behavior from the mysqld_safe script.

