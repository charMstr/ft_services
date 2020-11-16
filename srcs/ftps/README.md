# FTPS CONTAINER

This readme is dedicated to the ftps server subpart of the ft\_services
project. (school project, at 42.)

## OVERVIEW

The ftps server is designed to run in a container build from scratch from a
light weight base image: alpine linux, and will then be deployed in a
kubernetes cluster.

_**note:** a dummyfile named hello\_world is copied inside the image for peer
correction purspose, so that we can download it from the ftp server._

## IMPLEMENTATION DETAILS & SECURITY GOOD PRACTICE

The server should be using ftps (ftp over SSL or TLS).

For training purpose: the user named "user" is chrooted in his home directory.

## PORTS:
- 20
- 21
- 3000

Port 20 and 21 are classic ftp ports.

Port 30 000 should be exposed so that we can have a passive connexion.
note: The port 30000 is given as min andmax in the vsftpd.conf file.

## RUNNING SERVICES IN THE SAME CONTAINER:

- vsftpd

It has been used as it should be the more lightweight.

## ENV VARIABLES (and their default values):

- \_\_FTP_USER\_\_=user
- \_\_FTP_PASSWORD\_\_=password

## LOGS

log file redirection to docker log collection (through stdout) is made with a
tail -f. (sym link would not work).

## VSFTPD.CONF
	
tips: install filezilla and look at the error messages when configuring.

things that needed corrections:

-	the seccomp sandboxing appeared in version 3.0 and causes problems
	seccomp_sandbox=NO
-	allow local users to connect and change things:
	lacal_enable=YES
	write_enable=YES

## CLIENT SIDE
	
On the client side when testing the ftp connexion, you can use filezilla(easy).

or you can user lftp:
	```
	sudo apt install lftp
	```

connect to ftp server:
```	
	lftp -u <user_name> <IPaddress>
	lftp -u user 127.0.0.1
```
	
** TIPS:** things that needed to be fix in /etc/lftp.conf (on local machine):

allow using an invalid certificate:
	`set ssl:verify-certificate no`
