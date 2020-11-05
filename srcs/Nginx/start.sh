#!/bin/sh

#starting nginx:
# in the foreground, with the "-g daemon off;" option
#nginx -g "daemon off;"
nginx 

#starting sshd:
# -D' ->	sshd will not detach and does not become a daemon.
#			This allows easy monitoring of sshd.
#			We do not use it otherwise we cant move to the next script command
# -e' ->	sshd will send the output to the standard error instead of the
#			system log. So that the logs can be recolted by Docker..
/usr/sbin/sshd -De;
