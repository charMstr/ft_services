FROM alpine:latest

ENV __WORDPRESS_DB_NAME__ wordpress
ENV __WORDPRESS_DB_USERNAME__ user
ENV __WORDPRESS_DB_PASSWORD__ password
ENV __WORDPRESS_DB_HOST__ 127.0.0.1
ENV __WORDPRESS_DB_TABLE_PREFIX__ aha_archi_wp_

COPY /srcs/wp_salt_keys_reset.sh /usr/sbin/
COPY /srcs/wp_install_and_edit_wp-config.sh /usr/sbin

RUN apk update \
	&& apk add nginx \
	#add all the php dependencies including php-fpm
	&& apk add php7 \
		php7-bcmath \
       	php7-ctype \
       	php7-curl \
       	php7-fpm \
       	php7-gd \
       	php7-iconv \
       	php7-intl \
       	php7-json \
       	php7-mbstring \
       	php7-mcrypt \
       	php7-mysqlnd \
       	php7-opcache \
       	php7-openssl \
       	php7-pdo \
       	php7-pdo_mysql \
		php7-mysqli \
       	php7-pdo_pgsql \
       	php7-pdo_sqlite \
       	php7-phar \
       	php7-posix \
       	php7-session \
       	php7-soap \
       	php7-xml \
       	php7-zip \
	# download the wordpress tar ball
	&& wget -P /tmp/ http://wordpress.org/latest.tar.gz \
	&& wp_install_and_edit_wp-config.sh \
	# clean cache
	&& rm -rf /var/cache/apk/*

	# run the wordpress custom installation script
#RUN  wp_install.sh 

COPY /srcs/bootstrap.sh /usr/sbin
COPY /srcs/wp_server.conf /etc/nginx/conf.d

EXPOSE 5050

ENTRYPOINT ["bootstrap.sh"]
