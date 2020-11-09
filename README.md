# ft_services

This is a school project for the **_42cursus_**.

note: Each subparts of this project has its own readme.md

## Preview of project

The projects is about deploying automatically a cluster of microservices using homemade container images, and an orchestration tool.
The orchestration tool for managing the containers and their interconnections is kubernetes, it creates and maintains the cluster state for us.
Each container image is build from scratch from the alpine linux base image for lightweight and learning purpose.
The whole service we are going to run is made of the following microservices (each in its container).
- Nginx server
- FTPs server
- Wordpress
- PhpMyAdmin (for managing the wordpress database)
- MySQL database (database for the wordpress site)
- Grafana (visualisation for monitoring the containers)
- INfluxDB database (database for the grafana)

From the outside world, the access to the cluster is made through a load balancer. MetalLB is used for this purpose.

## How to use

In order to run this project you will need to have installed minikube and its dependencies locally (including kubelet).
then in the root folder you should be able to execute the script **setup.sh**.
**setup.sh** will start minikube and will then build our own docker images.
Then it will creat and interconnect all the kubernetes necessary objects, and then maintain the cluster.

## credentials

for the entire project, the credentials are:

- user="_user_"
- password="_password_"

Those are defined as environement variables in each dockerfile, though they can be overidden through the use of new environment variables at runtime.

## understanding project parts:

### 1. "Nginx" container:
it is a container running an Nginx server as well as an ssh server.

**Nginx server** is listening on the ports:

- 80, doing an automatic redirect on port 443.
- 443, providing a secure ssl conexion.

its logs are made accessible to docker.

**Openssh-server** is listening on the port:

- 22 (secure shell).

For the sake of learning, and knowing how to implement good practices, I chose not to just set _no password_, nor use a password.
Instead i chose to force the connexion using an assymetric key pair authentication method (much stronger security).
When the image is built, new host keys are generated on the server side, and 
the .ssh/authorized_keys file will already contain one specific public key.
As reminded in the ssh banner, the client for demo purpose will have to addopt that specific public key and its matching private key.
The key pair can be found into ft_services/srcs/**Nginx**/srcs_ssh/client_key_pair/ folder.
Once addopted on the client side (copy/past in its ~/.ssh folder), the ssh connexion should process through authentication automatically.

### 2. "FTPS" container:

We will use the ***vsftpd*** ftp server because it is the most lightweight(important for containerised apps) and trusted.
The logs are made accessible to docker.
The anonymous connexions have been disabled, the ssl/tls connexion is used, and the connexion is chrooted for learning purpose.
