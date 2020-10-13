FROM alpine:3.7

RUN apk update && apk upgrade \
	&& apk add openssl

# Install openrc
RUN apk update && apk add openrc && apk add nginx

# add nginx [OK]
# do the work instad of nginx: creat dir for nginx.pid, change rights/owner
RUN mkdir -p /run/nginx \
	&& chown nginx:nginx /run/nginx 

########################
# remove me at the end #
########################
#RUN apk add bash-completion
#RUN apk add vim 

RUN rc-update add nginx default
#RUN ln -s /etc/init.d/nginx /etc/runlevels/sysinit

ENTRYPOINT openrc default && rc-service nginx start  && exec /bin/sh 
#ENTRYPOINT openrc default && /etc/init.d/nginx start && exec /bin/sh 
