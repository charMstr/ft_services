#!/bin/sh

###############################################################################
#### NGINX:
# Forward request and error logs to Docker log collector
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log

#generating autosigned certificates for ssl demo (no prompt).
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=FR/O=krkr/OU=Domain Control Validated/CN=*.krkr.io" 2>&1 >/dev/null

###############################################################################
#### SSH:
# correct right on folder and file For "root" user.
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys
#impossible to connect through public key if the password has not been set yet
# for root. weird but real.
echo 'root:dummy' | chpasswd &>/dev/null

#add ssh user: "user", with password: "password"
adduser -D $__SSH_USER__ &>dev/null
echo "$__SSH_USER__:$__SSH_PASSWORD__"|chpasswd &>dev/null

#make sure the ownership and permissions are correct for user "user.
chmod 700 /home/user/.ssh
chmod 600 /home/user/.ssh/authorized_keys

#generate pairs of keys on host (here 3 different types of encryption)
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
	ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa && \
	ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa

###############################################################################
#### STARTING SERVICES:
# starting NGINX in the foreground, with the "-g daemon off;" option
#nginx -g "daemon off;"
nginx 

#starting SSHD:
# -D' ->	sshd will not detach and does not become a daemon.
#			This allows easy monitoring of sshd.
#			We do not use it otherwise we cant move to the next script command
# -e' ->	sshd will send the output to the standard error instead of the
#			system log. So that the logs can be recolted by Docker..
/usr/sbin/sshd -De;
