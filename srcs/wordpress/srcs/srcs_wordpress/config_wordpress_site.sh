#!/bin/sh

# check if yes or no there is already a database set up at the location + name
# that wp-config.php points to.

cd /usr/share/webapps/wordpress
wp core is-installed > /dev/null 2>&1
if [[ $? = 0 ]]
then	
	echo "wp-cli: no need to reinstall wordpress, it already has a database"
	echo "		name: $__WORDPRESS_DB_NAME__"
	echo "		at address: $__WORDPRESS_DB_HOST__"
	exit 0
fi

echo "wp-cli: wordpress not installed yet at address: $__WORDPRESS_DB_HOST__ with database: $__WORDPRESS_DB_NAME__ "

#trying ten times to connect to database, so it gives it the time to boot.
# and if it completely fails, then we abort the container
LIMIT=11
while :
do
	echo "waiting for database conexion"
	wp core is-installed 2>&1 | grep "Error establishing" > /dev/null
	if [[ $? = 0 ]]
	then
		let "LIMIT--"
		echo "$LIMIT"
		sleep 1
		if [[ $LIMIT = 0 ]]
		then
			exit 1
		fi
	else
		echo "OK!"
		break	
	fi
done

wp core install --url=http://${__WORDPRESS_SVC_IP__}:${__WORDPRESS_SVC_PORT__} --title="Charmstr's_site" --admin_user=user --admin_password=password --admin_email=user@42.fr --skip-email
#clean the file
#:> /tmp/postid
wp term create category haha
wp post create /tmp/content_first_post.txt --post_author=1 --post_category="haha" --post_title="my first post" --post_excerpt="about confinment" --post_status=publish | awk '{gsub(/[.]/, ""); print $4}' > /tmp/postid
#echo -n "created a post with id: "; cat /tmp/postid; echo ""
# creating different users
wp user create user1 user1@example.com --role=editor --user_pass=user1
wp user create user2 user2@example.com --role=author --user_pass=user2
wp user create user3 user3@example.com --role=contributor --user_pass=user3
wp user create user4 user4@example.com --role=subscriber --user_pass=user4
wp theme activate twentyseventeen
wp option update blogdescription "Just another ft_services project at 42"
