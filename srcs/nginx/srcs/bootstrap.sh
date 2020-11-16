#!/bin/sh

setup_nginx.sh

setup_ssh.sh

###############################################################################
#### STARTING SERVICES:
# starting NGINX in the foreground, with the "-g daemon off;" option
#nginx -g "daemon off;"

#starting SSHD:
# -D' ->	sshd will not detach and does not become a daemon.
#			This allows easy monitoring of sshd.
#			We do not use it otherwise we cant move to the next script command
# -e' ->	sshd will send the output to the standard error instead of the
#			system log. So that the logs can be recolted by Docker..
###############################################################################

# We have two services running in the same container,
# We will avoid using a Openrc or supervisord, full fledged inint processes.

nginx
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start nginx: $status"
  exit $status
fi

# Start the second process
/usr/sbin/sshd -e
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start sshd: $status"
  exit $status
fi

while sleep 20; do
  ps aux |grep nginx |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep sshd |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done
