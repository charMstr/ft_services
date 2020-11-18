#!/bin/sh

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

#set password and grants for admin to the mysql server in general, only able to
#connect locally. Also creat database, and set grants to the user.
#remove  the "test" databse.
cat <<EOF > $tmp_file
RENAME USER 'mysql'@'localhost' to '$__MYSQL_ADMIN__'@'localhost';
SET PASSWORD FOR '$__MYSQL_ADMIN__'@'localhost'=PASSWORD('${__MYSQL_ADMIN_PASSWD__}') ;
GRANT ALL ON *.* TO '$__MYSQL_ADMIN__'@'127.0.0.1' IDENTIFIED BY '$__MYSQL_ADMIN_PASSWD__' WITH GRANT OPTION;
GRANT ALL ON *.* TO '$__MYSQL_ADMIN__'@'localhost' IDENTIFIED BY '$__MYSQL_ADMIN_PASSWD__' WITH GRANT OPTION;

CREATE DATABASE IF NOT EXISTS $__MYSQL_DB_NAME__ CHARACTER SET utf8 COLLATE utf8_general_ci;

GRANT ALL ON $__MYSQL_DB_NAME__.* TO '$__MYSQL_DB_USER__'@'%' IDENTIFIED BY '$__MYSQL_DB_PASSWD__' WITH GRANT OPTION;
GRANT ALL ON $__MYSQL_DB_NAME__.* TO '$__MYSQL_DB_USER__'@'localhost' IDENTIFIED BY '$__MYSQL_DB_PASSWD__' WITH GRANT OPTION;
GRANT ALL ON $__MYSQL_DB_NAME__.* TO '$__MYSQL_DB_USER__'@'127.0.0.1' IDENTIFIED BY '$__MYSQL_DB_PASSWD__' WITH GRANT OPTION;
DROP DATABASE test;
FLUSH PRIVILEGES;
EOF

until mysql
do
	sleep 0.5
done

#effectively creat our databse and set passwords etc
mysql < $tmp_file
#deleting the tmp_file
rm $tmp_file

# import a dump version into the freshly created database if present in /tmp
if [ -f /tmp/wordpress_dump.sql ]
then
	mysql $__MYSQL_DB_NAME__ -u $__MYSQL_ADMIN__ --password=$__MYSQL_ADMIN_PASSWD__ < /tmp/wordpress_dump.sql
	rm /tmp/wordpress_dump.sql
fi
exit
