### check associated README.txt for explanations and details.
FROM alpine:latest

RUN apk update \
	&& apk add nginx &&  mkdir -p /run/nginx \
	&& mkdir -p /var/www/my_server \
	&& apk add openssl \
	&& apk add openssh-server \
	&& apk add gettext \
	&& rm -rf /var/cache/apk/*

#creat basic environement variables. default value used if not changed.
# those environement variables take effect in bootstrap.sh
ENV __SSH_USER__=user
ENV	__SSH_PASSWORD__=password
ENV __PHPMYADMIN_IP__=172.24.0.4
ENV __WORDPRESS_IP__=172.24.0.3
ENV __WORDPRESS_PORT__=5050
ENV __PHPMYADMIN_PORT__=5000

# note: this is just documentation between the guy that writes the dockerfile
# and the guy that will launch the docker run command. it does not publish any
# port... unless you use the "-p" option with the docker run command.
EXPOSE 80 443 22

### NGINX SETUP ### see the setup_nginx.sh script for more details.
COPY ./srcs/srcs_nginx/setup_nginx.sh /usr/sbin
COPY ./srcs/srcs_nginx/server_config  /tmp/
COPY ./srcs/srcs_nginx/index.html /var/www/my_server/index.html
COPY ./srcs/srcs_nginx/self-signed.conf /etc/nginx/snippets/

### SSH SETUP ###
# copy the authorized_keys in the root home.
COPY ./srcs/srcs_ssh/setup_ssh.sh /usr/sbin
COPY ./srcs/srcs_ssh/authorized_keys /root/.ssh/authorized_keys
COPY ./srcs/srcs_ssh/authorized_keys /tmp 
#custom message of the day replaced for fun
COPY ./srcs/srcs_ssh/motd /etc/motd
#custom ssh banner added for fun
COPY ./srcs/srcs_ssh/ssh_banner /tmp/ssh_banner
#custom sshd_config (among other things disabling the password authentication).
#only the ssh public key athentication is available.
COPY ./srcs/srcs_ssh/sshd_config /etc/ssh/sshd_config


### FINAL SETUP ###
#add the bootstrap script that will allow us to exec multiple commands at start.
COPY ./srcs/bootstrap.sh /usr/sbin/

#ENTRYPOINT 
ENTRYPOINT ["bootstrap.sh"]
