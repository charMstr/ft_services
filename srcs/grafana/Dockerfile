#refer to related README.md
FROM alpine:latest

WORKDIR /usr/share/grafana

RUN apk update \
    && apk add grafana --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
	&& mkdir /usr/share/grafana/dashboards \
	&& rm -rf /var/cache/apk/*

EXPOSE 3000

COPY srcs/datasource_influxdb.yaml /usr/share/grafana/conf/provisioning/datasources/
COPY srcs/grafana.ini /usr/share/grafana/conf/grafana.ini
COPY srcs/dashboard_provider.yaml /usr/share/grafana/conf/provisioning/dashboards/default.yaml
COPY srcs/dashboards/* /usr/share/grafana/dashboards/

ENV __GRAFANA_ADMIN_PASSWORD__=password
ENV __GRAFANA_ADMIN_NAME__=user
ENV __GRAFANA_ANON_LOGIN__=true
ENV	__GRAFANA_LOG_LEVEL__=info
ENV __GRAFANA_PORT__=3000
ENV __GRAFANA_IP__=172.18.0.4
ENV __INFLUXDB_DB_NAME__=telegraf
ENV __INFLUXDB_DB_USER__=user
ENV __INFLUXDB_DB_PASSWORD__=password
ENV __INFLUXDB_URL__=http://172.18.0.2:8086

ENTRYPOINT [ "/usr/sbin/grafana-server", "--config", "conf/grafana.ini" ]
#CMD exec /bin/sh -c "trap : TERM INT; sleep 9999999999d & wait"

