### check associated README.txt for explanations and details.
FROM alpine:latest

#because more than one process will be ran, we will add openrc and manage all
#add openrc, nginx, openssl, openssh
RUN apk update \
	#&& apk add openrc --no-cache \
	&& apk add nginx &&  mkdir -p /run/nginx \
	&& apk add openssl \
	&& apk add openssh-server

#creat basic environement variables. default value used if not changed.
# those environement variables take effect in bootstrap.sh
ENV __SSH_USER__ user
ENV __SSH_PASSWORD__ password

# note: this is just documentation between the guy that writes the dockerfile
# and the guy that will launch the docker run command. it does not publish any
# port... unless you use the "-p" option with the docker run command.
EXPOSE 80 443 22

### NGINX SETUP ###
#copy server_config file and place the webpage
#note: make it default otherwise it doesnt work for some reason.
COPY ./srcs/srcs_nginx/server_config /etc/nginx/conf.d/default.conf
RUN mkdir -p /var/www/my_server
COPY ./srcs/srcs_nginx/index.html /var/www/my_server/index.html
COPY ./srcs/srcs_nginx/self-signed.conf /etc/nginx/snippets/

### SSH SETUP ###
# copy the authorized_keys in the root home.
COPY ./srcs/srcs_ssh/authorized_keys /root/.ssh/authorized_keys
#for secret authentication on user@<ip_adress_server> to work straight away,
# add the authorized_keys file into /home/user/.ssh folder.
COPY --chown=user ./srcs/srcs_ssh/authorized_keys /home/user/.ssh/authorized_keys
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
