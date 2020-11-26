# FT_SERVICES

This is a school project for the **_42cursus_**.

_note: Each subparts of this project has its own readme.md, they contain tips
and a bunch of details_

_note2: If you are a 42 student, i made a separate README.md:
**README\_FOR\_42PEERS.md** it contains some helpful hints on how to approch the
subject. I also made a correction script: **correct\_peer.sh**_

## OVERVIEW OF PROJECT

The projects is about deploying automatically a cluster of microservices using
homemade container images and an orchestration tool.
The orchestration tool for managing the containers and their interconnections
is kubernetes, it creates and maintains the cluster state for us.
Each container image is build from scratch from the alpine linux base image for
lightweight and learning purpose.
The whole service we are going to run is made of the following microservices
(each in its dedicated container).
- Nginx server
- FTPs server
- Wordpress
- PhpMyAdmin (for managing the wordpress database)
- MySQL database (database for the wordpress site)
- Grafana (visualisation for monitoring the containers)
- INfluxDB database (database for the grafana)

From the outside world, the access to the cluster is made through a load
balancer. MetalLB is used for this purpose. It will publish only one IP to
access the whole cluster.

## USAGE

### PREREQUISITES:
-docker installed and running.
-minikube installed, and its dependencies. Especially kubelet.
-be on Linux

### SETUP.SH
In the root folder you should be able to execute the script **setup.sh**.
```
./setup.sh
```
**setup.sh** will start minikube according to the OS, it will then build our
own custom docker images.
Then it will creat all the kubernetes necessary objects. The interconnection
between those object is set within the configuration files (yaml format).

### CREDENTIALS

for the entire project, the credentials are:

- user="_user_"
- password="_password_"

_note:Those are defined as environement variables in each dockerfile with a
default value.
At runtime they are overidden through the use of new environment variables
passed in our yaml configuration files. The redefinitions of those variables
are found either in the configmaps(non sensitive) and secrets(sensitive)._

**_important note:_** secrets.yaml file should be stored independently.

## MINIKUBE AND METALLB:

### MINIKUBE:
It is a tool allowing us to deploy a very basic version of a cluster, but
locally on our machine, for development purpose. The cluster is made of only
one node which includes the master process as well. Normally a real kubernetes
cluster would require at least one master node, and a worker node (on which our
kubernetes objects for our app are deployed).

#### DRIVER USED

This project was developped on a ubuntu VM (Ubuntu 18.04.5 LTS) on which docke
was installed and running. Therefor the possibility to use directly the docker
engine instead of a Virtual Machine to deploy our minikube cluster was used.
```
minikube start --vm-driver=docker
```
#### VERSION USED:
minikube version: v1.9.0
_note: this previous version does not come withe the metallb addon_.

### METALLB:

Metallb allows us to provide an external Ip address to our kubernetes services
objects of type **LoadBalancer** on bare metal server. So no need to go through
a cloud provider.
Metallb will need to provide ip addresses in our case that are in the same 
subnet as the docker0 bridge (the bridge the docker engine creates).
This because we start our cluster within the docker engine.

## MORE ABOUT KUBERNETES OBJECTS(K8S):

Oour cluster will be composed of different kubernetes objects:
- deployments theiy are a superset of pods, so that we dont have to handel them
individually.
- pods, they are basically running a container (abstraction over containers).
- services (either reachable from the exterior (type: _LoadBalancer_) or not
(type: _ClusterIp_) they will allow us to make our pods communicate with each
others within the cluster for example.
- volumes, making it possible to maintain data persistence when containers
craah and are being restarted.

#### DEPLOYMENTS

they are a superset of the pods, they creat the replicasets objects as well.
So basically they contain inside them the definition of another kubernetes
object: a pod (starting at the _template_ keyword in the  yaml format)

the metadata.name will be the name of the deployment + random hash\_key:

_ex: metadata.name = nginx   --> nginx-4sf09nasdf_

the pods will inherit this name and have another hash appended to it, on top.

#### NOTE ON LABELS AND SELECTORS.

The label of the deployment can be anything, example: _nginx-deployment_
the selector has to be exactly matching the pod's label.
if _spec.selector.matchLabels.app = ngnix-pod _
then _spec.template.metadata.labels.app = nginx-pod_

same goes with the services. they also target the **pods**.
their name can be anything, as well as their label.
But the selector must match the pods label (defined in the subparts of the
deployments).

#### SERVICES

LMGTFY

#### PERSISTENT VOLUMES WITH MINIKUBE

A persistent volume is a kubernetes object which act as if it was a kard drive
plugged in. To access those volumes within our deployments, in the yaml file we
mount the volume on the **pod** itself (with a _persistent volume claim_:
another kubernetes object) and on the **container**.

when the pod does a _persistant volume claim_, a matching _persistant volume_
that should have already been created will be used.

To avoid creating manually those _persistent volume_ objects, kubernetes offers
a way to dinamically creat them on demand: _Storage Classe_ objects do this
for us.

Minikube has a builtin _storageclass_ that will creat _persistent volumes_ on
demand dynamically on the host. those are at the _host\_path_ location

documentation: [https://minikube.sigs.k8s.io/docs/handbook/persistent_volumes/]

## UNDERSTANDING PROJECT PARTS:

### 1. "NGINX" CONTAINER:

It is a container running an Nginx server(port 443 or port 80 redirecting 443),
as well as an ssh server(port 443)
It will also:
- act as a reverse proxy server to the container phpmyadmin with
the _/phpmyadmin_ in the URI,
- give a temporary redirect of type 307 to the container running wordpress.

More details on the dedicated README.md of this microservice:
_see srcs/nginx/README.md_.

### 2. "FTPS" CONTAINER:

We will use the ***vsftpd*** ftp server because it is the most lightweight
(important for containerised apps) and trusted.
The logs are made accessible to docker.
The anonymous connexions have been disabled, the ssl/tls connexion is used, and
the connexion is chrooted for learning purpose.

More details on the dedicated README.md of this microservice:
_see srcs/ftps/README.md_.

### 3. "WORDPRESS" CONTAINER:

Tthis container will listen on port 5050. it can also be reached through the
nginx container that makes a temporary 307 redirect to it.

The wordpress is already set up with a couple of users etc (the famous 5
minutes install is done).
Two methods were possible:
- either precreate a database and import a dump in the mysql container
(very rigid because we cannot change the site name etc).
- use the wp-cli tool from within the wordpress container at startup, much
cleaner solution. dynamically configurable when starting the cluster.

Since the folder _wp-content_ stores the media(not uploaded into the database),
a persistent volume should be mounted there.

More details on the dedicated README.md of this microservice:
_see srcs/wordpress/README.md_.

### 4. "PHPMYADMIN" CONTAINER:

It connects to the mysql database container. It can be accessed on port 5000,
or through the nginx contaier (ports 80 et 443) with the uri _/phpmyadmin_

More details on the dedicated README.md of this microservice:
_see srcs/phpmyadmin/README.md_.

### 5. "MYSQL" CONTAINER:

This is a statefulset application, therefore it require to mount a persistent
volume otherwise the data will be lost between different containers lifecycle.

More details on the dedicated README.md of this microservice:
_see srcs/mysql/README.md_.

### 6. "TELEGRAF" CONTAINER:

This is a open choice in the subject, it is collecting metrics and feeds them
into our influxdb database. Telegraf is a plugin-driven agent that collects 
time series data. there is a pluggin for kubernetes.

### 6. "INFLUXDB" CONTAINER:

It will receive time series data in a database, and grafana will access that
database to display some nice visuals.

### 7. "GRAFANA" CONTAINER:

Create your own dashboards to display the time series data you collected on
whatever. in our case the data we collected on pods.
