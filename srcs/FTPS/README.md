###############################################################################
### GENERAL ###

This README is for the ftps server part of ft_service, a 42 school project.

the docker container should expose the following ports:
20, 21 (classic ftp). and 30 000.
Port 30 000 should be exposed so that we can have a passive connexion.
note: The port 30000 is given as min andmax in the vsftpd.conf file.

a dummyfile named hello_world is copied inside the image for correction, so
that we can download it from the ftp server.

the server should be using ftps (ftp over SSL or TLS).

for training purpose: the user named "user" is chrooted in his home directory.

log file redirection to docker log collection (through stdout) is made with a
tail -f. (sym link would not work).
###############################################################################

###############################################################################
### vsftpd.conf ###
	
tips: install filezilla and look at the error messages when configuring.

things that needed corrections:

-	the seccomp sandboxing appeared in version 3.0 and causes problems
	seccomp_sandbox=NO
-	allow local users to connect and change things:
	lacal_enable=YES
	write_enable=YES
###############################################################################

###############################################################################
### client side ###
	
on the client side when testing the ftp connexion, you can use filezilla(easy).

or you can user lftp
	sudo apt install lftp

connect to ftp server:
	lftp -u <user_name> <IPaddress>
	lftp -u user 127.0.0.1
	
things that needed to be fix in /etc/lftp.conf (on local machine):

	-	allow using an invalid certificate:
		set ssl:verify-certificate no
###############################################################################
