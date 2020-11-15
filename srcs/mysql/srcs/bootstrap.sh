#!/bin/sh

#make sure the /rum/mysqld exists and has right ownership
if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

# It initializes the MySQL data directory and creates the system tables that it contains.
# Specify the --user option to indicate the user name that mysqld should also
#creat. It should be an existing system account
echo 'Initializing data directory and system necessary tables at standard place'
mysql_install_db --user=mysql --datadir=/var/lib/mysql/  #> /dev/null

#redirecting logs For docker
tail -f /var/lib/mysql/mysql_log_.err &
tail -f /var/lib/mysql/mysql_log_.log &


#Need to start the mysqld so the client can creat our database.
#Since the mysqld_safe stays in the foreground forever.
# two tricks possible:
#	start the mysqld_safe in background in a subshell.
# 		(/usr/bin/mysqld_safe &) && sleep 2 && ...
#	or start the client connexion in a script with an until loop
nohup init_my_db.sh &

#starting the mysql server daemon
/usr/bin/mysqld_safe --datadir="/var/lib/mysql/"
