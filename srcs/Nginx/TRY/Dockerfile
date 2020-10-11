FROM alpine:3.7

RUN apk update \
	&& apk add nginx \
	&& mkdir -p /run/nginx 
	#&& apk add openssl

# Forward request logs to Docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
&& ln -sf /dev/stderr /var/log/nginx/error.log
# see docker inspect command to use the latter...

# note: this is just documentation between the guy that writes the dockerfile
# and the guy that will write the docker run command. it does not publish any
# port... use the "-p" option with the docker run command
EXPOSE 80 443

# Use CMD to start NGINX when the image is instantiated as a container. You’ll
# need to run NGINX in the fore‐ ground. To do this, you’ll need to start NGINX
# with -g "daemon off;" or add daemon off; to your configuration.
CMD ["nginx", "-g", "daemon off;"]
# or CMD ["nginx"]

#starting nginx in the foreground, with the -g daemon off option
# and as well making it pid 1 thanks to the exec form of the ENTRYPOINT
ENTRYPOINT ["nginx", "-g", "daemon off"]
# or try simply the following form, that will be an exec anyway?
# ENTRYPOINT ["nginx"]

#then from outside the container run something like:
#	docker run -it --rm --name test_container top
# and you should see nginx as the pid one?
