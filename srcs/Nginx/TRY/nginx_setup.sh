#!/bin/sh

/usr/sbin/sshd -D
# -D' ->	sshd will not detach and does not become a daemon.
#			This allows easy monitoring of sshd.

# -e' ->	sshd will send the output to the standard error instead of the
#			system log. So that the logs can be recolted by Docker...

#maybe creat a /etc/ssh/sshrc file that will prompt a welcome message!

