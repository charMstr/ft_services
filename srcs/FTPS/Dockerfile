FROM alpine:3.10
RUN apk --no-cache add vsftpd \
	&& apk add openssl

RUN apk add bash

COPY start_vsftpd.sh /bin/start_vsftpd.sh
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

EXPOSE 21 21000-21010
VOLUME /ftp/

#ssh cetfificate for tls
#COPY ./ftps_key_gen.sh /tmp
#RUN /tmp/ftps_key_gen.sh

#uncomment this line and see the start_vsftpd.sh script if you want to connect
#to the container in an interactive shell.
ENTRYPOINT /bin/start_vsftpd.sh && bash
#ENTRYPOINT ["/bin/start_vsftpd.sh"]

