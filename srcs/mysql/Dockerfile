FROM alpine:latest

RUN apk update \
	&& apk add mariadb \
	&& apk add mariadb-client \
	&& rm -rf /var/cache/apk/*

# creating DB and setting a user, able to connect only to this database.
ENV __MYSQL_DB_NAME__ wordpress
ENV __MYSQL_DB_USER__ user
ENV __MYSQL_DB_PASSWD__ password

#changing the name and password for the mysql superuser.
ENV __MYSQL_ADMIN__ admin
ENV __MYSQL_ADMIN_PASSWD__ password_admin

COPY srcs/bootstrap.sh usr/sbin/bootstrap.sh
COPY srcs/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

EXPOSE 3306

ENTRYPOINT ["bootstrap.sh"]
