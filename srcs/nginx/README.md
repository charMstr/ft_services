# NGINX CONTAINER

This readme is dedicated to the NGINX server subpart of the ft\_services
project. (school project, at 42.)

## OVERVIEW

The nginx server is designed to run in a container build from scratch from a
light weight base image: alpine linux, and will then be deployed in a
kubernetes cluster. It will be a hub connexion, acting as a gateway and
redirecting queries to the wordpress container (and its own nginx), and to the
phpmyadmi container(and its own nginx again).

## IMPLEMENTATION DETAILS & SECURITY GOOD PRACTICE

#### DOCKERFILE

In a real world application, we would run most oftenly one service per
container.
Here I had to run openssl and nginx in the same one (school subject).
But I still chose for training purpose to avoid using an init system (in our
alpine linux case Openrc would be the lighter option) and start individually
each binaries.
I implemented a script checking the liveliness of those two.

The services are started in a script.
Nginx is started in the foreground so that the command never ends (the
container keeps running even in detached mode).

## RUNNING PROCESSES:
- nginx
- ssh

#### SSH

For the ssh connexion, I chose not to just set no password, nor use a password.
For good practice I chose to use an assymetric key pair authentication method
(much stronger security).
When the image is built, new host keys are generated on the server side, and 
the _.ssh/authorized_keys_ file will already contain one specific public key.
that specific public key and its matching private key are found into
_srcs\_ssh/client\_key\_pair/_ and will need to be adopted on the client side for
demo purpose.

#### NGINX

##### REVERSE PROXY TO PHPMYADMIN CONTAINER

	it is a one liner:
	```
	location /wordpress { 
		proxy\_pass <ip>:port/;
	}
	```
reasons it did not work: the _**/wordpress**_ will be appended to <ip>:port
`<ip>:port/wordpress` and this is probably not an existing location or page
on the proxyed server.

**_TIP_** _MAKE SURE you add the trailing '/' at the end of the proxy\_pass line._
**_TIP_** **RTFM!**

##### 307 REDIRECT TO WORDPRESS CONTAINER

when accessing the nginx container with URI _/wordpress_ (i also implemented 
_/wordpress/_) there is a 307 temporary redirect implemented. The browser will
change the address in the URL.

## PORTS:

- 22
- 443
- 80

Port 80 should do a constant 301 redirect to port 443, where ssl is
implemented.
Port 22 is where sshd is actively listening for an incoming ssh connexion.

## ENV VARIABLES (and their default values):
- \_\_SSH_USER\_\_ user
- \_\_SSH_PASSWORD\_\_ password

_used to creat a new system user and set its password._

## LOGS

I redirect the nginx log and error messages to the docker logs (redirection to
stdin and stdout).
same goes for the sshd errors.
example of commands working:

```
docker logs -f nginx_container_name
kubectl logs -f nginx_pod_name
```

## SSH CONNEXION: Reasons things did not work in the first place:

	- if rebuilding the image from zero, therefore recreating new host keys:
		on the client side, i had to supress the .ssh/known_hosts file.
		note: you could just suppress the specific host with:
			`ssh-keygen -R <IP_or_domain_name>:port`
	- on the very firt connexion when prompt that we cannot identify the server
		hitting ENTER instead of typing yes would make it fail all the time.
		note: you could avoid this message in a script with:
			`ssh -o StrictHostKeyChecking=no host@ipadress`
	- when trying to authenticate with the public key method, if .ssh folder
		and authorized_keys file dont have a correct and very specific
		ownership or permissions it will fail without really giving a reason.
	- ssh to root: on alpine linux the root user has not password set yet.
		it should not be related but until a useless password was set to root,
		it was impossible to shh with public key authentication(without
		password!) as root.

_tip: use the "**-vvv**" option when starting ssh for maximum debug messages._
