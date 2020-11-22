FROM alpine:latest

RUN apk update && apk add openssl \
	&& apk add vsftpd \
	&& apk add gettext \
	&& rm -rf /var/cache/apk/*

#creat basic environement variables. default value used if not changed.
# those environement variables take effect in bootstrap.sh
ENV __FTP_USER__=user
ENV __FTP_PASSWORD__=password
ENV __CLUSTER_EXTERNAL_IP__=172.17.0.2

#replace the original conf file with our customed one.
COPY ./srcs/vsftpd.conf /tmp/vsftpd.conf

#copy a dummy file just so that we can download it during the correction.
COPY ./srcs/hello_world1.txt /home/user/hello_world.txt

EXPOSE 20 21 30000

#place the bootstrap script in the usr/sbin so no need to make it executable.
COPY srcs/bootstrap.sh /usr/sbin

ENTRYPOINT ["bootstrap.sh"]
