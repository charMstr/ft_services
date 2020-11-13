FROM alpine:latest

ENV __WORDPRESS_DB_NAME__ wordpress
ENV __WORDPRESS_DB_USERNAME__ user
ENV __WORDPRESS_DB_PASSWORD__ password
ENV __WORDPRESS_DB_HOST__ 127.0.0.1

RUN apk update \
	&& apk add nginx \
	# install all the php packages recommanded in documentation
	&& apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session \
	# download the phpmyadmin tar ball
	&& wget --output-document=/tmp/phpmyadmin.tar.gz http://files.directadmin.com/services/all/phpMyAdmin/phpMyAdmin-5.0.2-all-languages.tar.gz \
	&& rm -rf /var/cache/apk/*

EXPOSE 5000

COPY /srcs/bootstrap.sh /usr/sbin
COPY /srcs/phpmyadmin_server.conf /etc/nginx/conf.d

#override the original conf with ours:
# now fastcgi pass happens over Unix domain socket instead of a TCP/IP socket
COPY /srcs/my_php-fpm7.conf /etc/php7/php-fpm.d/www.conf

CMD ["bootstrap.sh"]
