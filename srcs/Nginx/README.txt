###############################################################################
### OVERVIEW ###
This readme is dedicated to the NGINX server subpart of the ft_services
project. (school project, at 42.)

The nginx server is designed to run in a container build from scratch from a
light weight base image: alpine linux, and will then be deployed in a
kubernetes cluster.

It is due to listen on the ports 22, 80 and 443.
Port 80 should do a constant 301 redirect to port 443, where ssl is
implemented.
Port 22 is listening for a ssh connexion.
###############################################################################

###############################################################################
### DOCKERFILE ###
In a real world application, we would run only one service per container.
Here I had to run openssl and nginx in the same one (school subject).
But I still chose for training purpose to avoid using an init system (in our
alpine linux case: Openrc) and start individually each binaries.
Caveat: if we kill nginx sshd will still run, the container still runs.

the services are stated in a script. nginx is started in the foreground so that
the command never ends (the container keeps running).

I redirect the nginx log and error messages to the docker logs (redirection to
stdin and stdout).
same goes for the sshd errors.
	commands like:	docker logs -f nginx_container_name
					kubectl logs -f nginx_pod_name	
	would work.
###############################################################################



###############################################################################
### SSH CONEXION ###
For the ssh connexion, I chose not to just set no password, nor use a password.
For good practice I chose to use an assymetric key pair authentication method
(much stronger security).
When the image is built, new host keys are generated on the server side, and 
the .ssh/authorized_keys file will already contain one specific public key.
that specific public key and its matching private key are found into
srcs_ssh/client_key_pair/ and will need to be adopted on the client side for
demo purpose.

reasons it did not work:
	- if rebuilding the image from zero, therefore recreating new host keys:
		on the client side, i had to supress the .ssh/known_hosts file.
		note: you could just suppress the specific host with:
			ssh-keygen -R <IP_or_domain_name>:port
	- on the very firt connexion when prompt that we cannot identify the server
		hitting ENTER instead of typing yes would make it fail all the time.
		note: you could avoid this message in a script with:
			ssh -o StrictHostKeyChecking=no host@ipadress
	- when trying to authenticate with the public key method, if .ssh folder
		and authorized_keys file dont have a correct and very specific
		ownership or permissions it will fail without really giving a reason.
	- ssh to root: on alpine linux the root user has not password set yet.
		it should not be related but until a useless password was set to root,
		it was impossible to shh with public key authentication(without
		password!) as root.

tip: use the "-vvv" option when starting ssh
###############################################################################
