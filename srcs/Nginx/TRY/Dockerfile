FROM alpine:3.7

#update and add nginx
RUN apk update \
	&& apk add nginx \
	&& mkdir -p /run/nginx \
	&& apk add openssl

# Forward request logs to Docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
# now if you want to tail the logs when container is running, use command:
# docker logs -f container_name_or_ID

# note: this is just documentation between the guy that writes the dockerfile
# and the guy that will launch the docker run command. it does not publish any
# port... unless you use the "-p" option with the docker run command.
EXPOSE 80 443

  
#copy server_config file and place the webpage
#note: make it default otherwise it doesnt work for some reason.
COPY ./srcs_nginx/server_config /etc/nginx/conf.d/default.conf
RUN mkdir -p /var/www/my_server
COPY ./srcs_nginx/index.html /var/www/my_server/index.html

#GENERATING AUTOSIGNED CERTIFICATES FOR SSL DEMO, NO PROMPT
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=FR/O=krkr/OU=Domain Control Validated/CN=*.krkr.io"
COPY ./srcs_nginx/self-signed.conf /etc/nginx/snippets/

#starting nginx in the foreground, with the "-g daemon off;" option
# and as well making it pid 1 thanks to the exec form of the ENTRYPOINT
ENTRYPOINT ["nginx", "-g", "daemon off;"]

#then from outside the container run something like:
#	docker exec -it container_ID top
# and you should see nginx as the pid one.
