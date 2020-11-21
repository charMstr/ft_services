#!/bin/sh

setup_nginx.sh

## install wordpress and edit wp-config.php
setup_wordpress.sh
# will run the wp cli as nginx user (non root) and give it a shell
#only do the "5minutes install" if the database is not populated yet
#after ten attempts to connect to the databse, we abort
su -s /bin/sh -c "config_wordpress_site.sh" nginx
if [[ $? = 1 ]]
then
	echo "ERROR: impossible to reach database, abort container"
	exit 1
fi

### starting services ###
# start the FastCGI php module:
# note: use "php-fpm7 -F" to start it in a daemon mode
#php-fpm7
# start nginx as a non daemon
#nginx -g "daemon off;"

nginx
status=$?
if [ $status -ne 0 ];
then
	echo "Failed to start nginx: $status"
	exit $status
fi

# Start the second process
php-fpm7
status=$?
if [ $status -ne 0 ];
then
	echo "Failed to start php-fpm7: $status"
	exit $status
fi

while sleep 20;
do
	ps aux |grep nginx |grep -q -v grep
	PROCESS_1_STATUS=$?
	ps aux |grep php-fpm |grep -q -v grep
	PROCESS_2_STATUS=$?
	# If the greps above find anything, they exit with 0 status
	# If they are not both 0, then something is wrong
	if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ];
	then
		echo "One of the processes has already exited."
		exit 1
	fi
done

