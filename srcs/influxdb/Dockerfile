### check associated README.txt for explanations and details.
FROM alpine:latest

RUN apk update \
	&& apk add influxdb \
	&& rm -rf /var/cache/apk/*

COPY srcs/bootstrap.sh /usr/sbin

EXPOSE 8086

ENTRYPOINT ["bootstrap.sh"]
