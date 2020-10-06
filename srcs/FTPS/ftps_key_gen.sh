#!/bin/sh

cd /tmp
openssl req -nodes -newkey rsa:2048 -keyout FTP.key -out certificate.csr -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=example.com"
cp FTP.key FTP.key.orig
openssl rsa -in FTP.key.orig -out ftp.key
openssl x509 -req -days 365 -in certificate.csr -signkey ftp.key -out mycertificate.crt
mkdir -p /etc/pki/tls/certs/
cp ftp.key /etc/pki/tls/certs/
cp mycertificate.crt /etc/pki/tls/certs

