FROM alpine:latest

ENV __DB_NAME__=wordpress
ENV __DB_USERNAME__=user
ENV __DB_PASSWORD__=password
ENV __DB_HOST__=172.22.0.2

RUN apk update \
	&& apk add nginx \
	# install all the php packages recommanded in documentation
	&& apk add php7 php7-fpm  php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session php7-bz2 php-zip \
	# download the phpmyadmin tar ball
	&& wget --output-document=/tmp/phpmyadmin.tar.gz http://files.directadmin.com/services/all/phpMyAdmin/phpMyAdmin-5.0.2-all-languages.tar.gz \
	#gettext allows us to do an envsubst action.
	&& apk add gettext \
	&& rm -rf /var/cache/apk/*

EXPOSE 5000

COPY ./srcs/bootstrap.sh /usr/sbin
COPY ./srcs/srcs_nginx/setup_nginx.sh /usr/sbin/
COPY ./srcs/srcs_nginx/phpmyadmin_server.conf /etc/nginx/conf.d
COPY ./srcs/srcs_phpmyadmin/setup_phpmyadmin.sh /usr/sbin
COPY ./srcs/srcs_phpmyadmin/phpmyadmin_config.inc.php /tmp/config.inc.php

#override the original conf with ours:
# now fastcgi pass happens over Unix domain socket instead of a TCP/IP socket
COPY ./srcs/srcs_phpmyadmin/my_php-fpm7.conf /etc/php7/php-fpm.d/www.conf

CMD ["bootstrap.sh"]
