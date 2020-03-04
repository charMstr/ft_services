FROM alpine:3.7

RUN apk update \
	&& apk upgrade \
	&& apk add bash

# Install openrc
RUN apk update && apk add openrc &&\
# Tell openrc its running inside a container, till now that has meant LXC
	sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf &&\
# Tell openrc loopback and net are already there, since docker handles the networking
	echo 'rc_provide="loopback net"' >> /etc/rc.conf &&\
# no need for loggers
	sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf &&\
# can't get ttys unless you run the container in privileged mode
	sed -i '/tty/d' /etc/inittab &&\
# can't set hostname since docker sets it
	sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname &&\
# can't mount tmpfs since not privileged
	sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh &&\
# can't do cgroups
	sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh &&\
# clean apk cache
	rm -rf /var/cache/apk/*

#remove me at the end
RUN apk add bash-completion
RUN apk add vim 

#add nginx [OK]
# do the work instad of nginx: creat dir for nginx.pid, change rights/owner
RUN apk add nginx \
	&& mkdir -p /run/nginx \
	&& chown nginx:nginx /run/nginx 

#copy server_config file and place the webpage
#note: make it default otherwise it doesnt work for some reason.
COPY ./srcs_nginx/server_config /etc/nginx/conf.d/default.conf
RUN mkdir -p /var/www/my_server
COPY ./srcs_nginx/index.html /var/www/my_server/index.html

VOLUME [ “/sys/fs/cgroup” ]

EXPOSE 80 443

#RUN apk add openrc
ENTRYPOINT openrc single && /etc/init.d/nginx start && bash
