### check associated README.txt for explanations and details.
FROM alpine:latest

#because more than one process will be ran, we will add openrc and manage all
#add openrc, nginx, openssl, openssh
RUN apk update \
	#&& apk add openrc --no-cache \
	&& apk add nginx &&  mkdir -p /run/nginx \
	&& apk add openssl \
	&& apk add openssh-server



# note: this is just documentation between the guy that writes the dockerfile
# and the guy that will launch the docker run command. it does not publish any
# port... unless you use the "-p" option with the docker run command.
EXPOSE 80 443 22

### NGINX SETUP ###
# Forward request and error logs to Docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
  
#copy server_config file and place the webpage
#note: make it default otherwise it doesnt work for some reason.
COPY ./srcs_nginx/server_config /etc/nginx/conf.d/default.conf
RUN mkdir -p /var/www/my_server
COPY ./srcs_nginx/index.html /var/www/my_server/index.html

#GENERATING AUTOSIGNED CERTIFICATES FOR SSL DEMO, NO PROMPT
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=FR/O=krkr/OU=Domain Control Validated/CN=*.krkr.io"
COPY ./srcs_nginx/self-signed.conf /etc/nginx/snippets/

### SSH SETUP ###

# copy the authorized_keys in the root home.
COPY ./srcs_ssh/authorized_keys /root/.ssh/authorized_keys
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys
#impossible to connect through public key if the password has not been set yet
# for root. weird but real.
RUN echo 'root:dummy' | chpasswd

#add ssh user: "user", with password: "password"
RUN adduser -D user \
	&& echo "user:password"|chpasswd
#for secret authentication on user@<ip_adress_server> to work straight away,
# add the authorized_keys file into /home/user/.ssh folder.
COPY --chown=user ./srcs_ssh/authorized_keys /home/user/.ssh/authorized_keys
#custom message of the day replaced for fun
COPY srcs_ssh/motd /etc/motd
#custom ssh banner added for fun
COPY srcs_ssh/ssh_banner /tmp/ssh_banner

#custom sshd_config (among other things disabling the password authentication).
#only the ssh public key athentication is available.
COPY /srcs_ssh/sshd_config /etc/ssh/sshd_config

#make sure the ownership and permissions of the folder .ssh and file
# authorized_keys are correct for user "user".
RUN chmod 700 /home/user/.ssh && chmod 600 /home/user/.ssh/authorized_keys

#generate pairs of keys on host (here 3 different types of encryption)
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
	ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa && \
	ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa

### FINAL SETUP
#add the start script that will allow us to exec multiple commands at start.
COPY start.sh /tmp/start.sh
RUN chmod +x /tmp/start.sh

#ENTRYPOINT 
ENTRYPOINT ["/tmp/start.sh"]
