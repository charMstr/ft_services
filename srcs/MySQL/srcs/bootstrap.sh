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

#CREATE USER '$__MYSQL_DB_USER__'@'%';
#SET PASSWORD FOR '$__MYSQL_ADMIN__'@'%'=PASSWORD('${__MYSQL_ADMIN_PASSWD__}') ;
echo "Creating database \"$__MYSQL_DB_NAME__\" for user: \"$__MYSQL_DB_USER__\""
cat <<EOF > $tmp_file
CREATE DATABASE IF NOT EXISTS $__MYSQL_DB_NAME__ CHARACTER SET utf8 COLLATE utf8_general_ci;
SET PASSWORD FOR '$__MYSQL_DB_USER__'@'localhost'=PASSWORD('${__MYSQL_DB_PASSWD__}') ;
GRANT ALL ON *.* TO '$__MYSQL_DB_USER__'@'127.0.0.1' IDENTIFIED BY '$__MYSQL_DB_PASSWD__' WITH GRANT OPTION;
GRANT ALL ON *.* TO '$__MYSQL_DB_USER__'@'localhost' IDENTIFIED BY '$__MYSQL_DB_PASSWD__' WITH GRANT OPTION;
GRANT ALL ON *.* TO '$__MYSQL_DB_USER__'@'%' IDENTIFIED BY '$__MYSQL_DB_PASSWD__' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# It initializes the MySQL data directory and creates the system tables that it contains.
# Specify the --user option to indicate the user name that mysqld should also creat.
echo 'Initializing data directory and system necessary tables at standard place'
mysql_install_db --user=mysql --datadir=/var/lib/mysql/  > /dev/null

#since the mysqld_safe stays in the foreground forever. trick
#quickly start the server, connect the mysql client to it and creat out database
(/usr/bin/mysqld_safe &) && sleep 3 \
&& mysql < $tmp_file \
&& killall mysqld 

# waiting for mysql to die
sleep 3

#deleting the tmp_file
rm -rf $tmp_file

#starting the mysql server
/usr/bin/mysqld_safe --user=mysql; --datadir="/var/lib/mysql/"
