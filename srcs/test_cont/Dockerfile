FROM alpine:latest

RUN apk add nginx

COPY ./start.sh /usr/sbin/

ENTRYPOINT ["start.sh"]
