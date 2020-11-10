FROM alpine:latest

RUN apk update \
	&& apk add mariadb \
	&& apk add mariadb-client \
	&& rm -rf /var/cache/apk/*

ENV __MYSQL_DB_NAME__ wordpress
ENV __MYSQL_DB_USER__ mysql
ENV __MYSQL_DB_PASSWD__ password
ENV __MYSQL_DB_IP_HOST__ 0.0.0.0
ENV __MYSQL_ADMIN__ mysql
ENV __MYSQL_ADMIN_PASSWD__ password2

COPY srcs/bootstrap.sh usr/sbin/bootstrap.sh
COPY srcs/my_mariadb_server.cnf /etc/my.cnf
#COPY conf file

EXPOSE 3306

ENTRYPOINT ["bootstrap.sh"]
