FROM alpine:latest

ENV __INFLUXDB_DB_NAME__=telegraf
ENV __INFLUXDB_DB_USER__=user
ENV __INFLUXDB_DB_PASSWORD__=password
ENV __INFLUXDB_URL__=http://172.18.0.2:8086
ENV __LOGS_WITH_DEBUG__=false

RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.13.3-static_linux_amd64.tar.gz \
    && tar -C . -xzf telegraf-1.13.3-static_linux_amd64.tar.gz \
    && chmod +x telegraf/* \
    && cp telegraf/telegraf /usr/bin/ \
	## make sure we can copy our conf file in the right location
	&& mkdir /etc/telegraf \
	&& mv telegraf/telegraf.conf /etc/telegraf/telegraf.conf \
	#clean
    && rm -rf *.tar.gz* telegraf/

COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf

ENTRYPOINT	["/usr/bin/telegraf"]
#CMD exec /bin/sh -c "trap : TERM INT; sleep 9999999999d & wait"
#ENTRYPOINT	["/bin/sh"]
