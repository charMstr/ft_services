FROM alpine:latest

RUN apk update \
	&& apk add mariadb \
	&& rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/sh"]
