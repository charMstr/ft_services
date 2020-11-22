#!/bin/sh

# creat a ssl key pair for our ftps server.
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=NL/ST=Noord-Holland/O=Codam/CN=Peer de Bakker' -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt &>/dev/null

envsubst '$__CLUSTER_EXTERNAL_IP__' < /tmp/vsftpd.conf > /etc/vsftpd/vsftpd.conf

#add a user named "user", its password is "password"
adduser -D $__FTP_USER__ && echo "$__FTP_USER__:$__FTP_PASSWORD__" | chpasswd &>/dev/null

#creat file of chrooted users, and add user to it
echo "$__FTP_USER__" >/etc/vsftpd/chroot.list

# make the logs available to docker:
# creat the log file before we tail it.
touch /var/log/vsftpd.log
#tail -f in the background
tail -f /var/log/vsftpd.log &

#start vsftpd with its config file as argument
usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
