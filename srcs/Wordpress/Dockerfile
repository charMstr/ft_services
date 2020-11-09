FROM alpine:latest

RUN apk update \
	&& apk add wget \
	&& apk add nginx \
	&& rm -rf /var/cache/apk/*

ENV __WORDPRESS_DB_NAME__ wordpress
ENV __WORDPRESS_DB_USERNAME__ user
ENV __WORDPRESS_DB_PASSWORD__ password
ENV __WORDPRESS_DB_HOST__ 127.0.0.1
ENV __WORDPRESS_DB_TABLE_PREFIX__ aha_archi_wp_

COPY /srcs/bootstrap.sh /usr/sbin
COPY /srcs/wp_salt_keys_reset.sh /usr/sbin/
COPY /srcs/wp_install.sh /usr/sbin
COPY /srcs/wp_server.conf /etc/nginx/conf.d

EXPOSE 5050

ENTRYPOINT ["bootstrap.sh"]
