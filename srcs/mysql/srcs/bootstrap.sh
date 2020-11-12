#!/bin/sh

#make sure the /rum/mysqld exists and has right ownership
if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

#creating temp file
tmp_file=`mktemp`
if [ ! -f "$tmp_file" ]; then
    return 1
fi

#creat user specificaly for the wordpress database only if different from admin
if [[ $__MYSQL_ADMIN__ != $__MYSQL_DB_USER__ ]]
then
	echo "CREATE USER '$__MYSQL_DB_USER__'@'%' IDENTIFIED BY '$__MYSQL_DB_PASSWD__';" >> $tmp_file
fi

#set password and grants for admin to the mysql server in general, onlyable to
#connect locally. Also creat database, and set grants to the user.
cat <<EOF > $tmp_file
RENAME USER 'mysql'@'localhost' to '$__MYSQL_ADMIN__'@'localhost';
SET PASSWORD FOR '$__MYSQL_ADMIN__'@'localhost'=PASSWORD('${__MYSQL_ADMIN_PASSWD__}') ;
GRANT ALL ON *.* TO '$__MYSQL_ADMIN__'@'127.0.0.1' IDENTIFIED BY '$__MYSQL_ADMIN_PASSWD__' WITH GRANT OPTION;
GRANT ALL ON *.* TO '$__MYSQL_ADMIN__'@'localhost' IDENTIFIED BY '$__MYSQL_ADMIN_PASSWD__' WITH GRANT OPTION;

CREATE DATABASE IF NOT EXISTS $__MYSQL_DB_NAME__ CHARACTER SET utf8 COLLATE utf8_general_ci;

GRANT ALL ON $__MYSQL_DB_NAME__.* TO '$__MYSQL_DB_USER__'@'%' IDENTIFIED BY '$__MYSQL_DB_PASSWD__' WITH GRANT OPTION;
GRANT ALL ON $__MYSQL_DB_NAME__.* TO '$__MYSQL_DB_USER__'@'localhost' IDENTIFIED BY '$__MYSQL_DB_PASSWD__' WITH GRANT OPTION;
GRANT ALL ON $__MYSQL_DB_NAME__.* TO '$__MYSQL_DB_USER__'@'127.0.0.1' IDENTIFIED BY '$__MYSQL_DB_PASSWD__' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# It initializes the MySQL data directory and creates the system tables that it contains.
# Specify the --user option to indicate the user name that mysqld should also
#creat. It should be an existing system account
echo 'Initializing data directory and system necessary tables at standard place'
mysql_install_db --user=mysql --datadir=/var/lib/mysql/  #> /dev/null

#since the mysqld_safe stays in the foreground forever. trick
#quickly start the server, connect the mysql client to it and creat out database
(/usr/bin/mysqld_safe &) && sleep 2 \
&& mysql < $tmp_file \
&& killall mysqld \
&& sleep 2 # waiting for mysql to die

#Now that the server has been kicked off, thanks to the log-basename option we know the name of
# the error log file and we can redirect it to stdout for docker.
tail -f /var/lib/mysql/mysql_log_.err &
# redirecting the general logs to stdout as well
tail -f /var/lib/mysql/mysql_log_.log &

#deleting the tmp_file
rm $tmp_file

#starting the mysql server daemon
/usr/bin/mysqld_safe --datadir="/var/lib/mysql/"
