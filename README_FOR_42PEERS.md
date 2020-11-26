# FT_SERVICES TIPS AND ADVICES

## INTRO
This is a README.md for my peers working on the same school project at 42.
I intend to give here interesting tips and hints based on my experience on how
to approach this project as it can be complexe to get the big picture at first.
Hopefully this will give you some usefull guidance and prevent you from just
copy/pasting too much.

_note: each subparts of the ./srcs folder has its own readme with some usefull
details and tips about why things workded or did not._

A correction script is available in the root of this folder:
**correct\_peer.sh**

## GOOD APPROACH ACCORDING TO MY PERSONAL EXPERIENCE:

According to my experience on this project, and if i had to redo it, my
approach would be to follow the following list. But also to not be ashamed with
reading other students projects. Its all about configuration, there is no need
to stay stuck for three days because we are missing a line or a character.

### 1) UNDERSTANDING WHAT IS KUBERNETES:

Kubernetes is a container orchestration tool.
It will allow you to deploy your app in a fragmented way (microservices style).
Basically all the subparts (services or microservices) of your
application will run in separated containers. They inter-communicate and work
together because they are part of a virtual network: your **cluster**.
This cluster can span over different machines, the cloud, or a mixte of both.

One of the most interesting advantage of using a microservices architecture is
the fact that you can update a small part of your app in general, without
stopping the application from running.

### 2) THINGS YOU NEED TO UNDERSTAND BEFORE WORKING FROM GROUND TO TOP:

All you need to know before starting is the concept that when deploying your
cluster, you will need to be able to interconnect your containers together.

For this interconnection to be possible, you will need to master how to run
docker images and passing to then environment variables or arguments, in order
to tune their configuration at boot time.

### 3) MASTER BUILDING YOUR CUSTOM IMAGES:

Maybe a good idea to start with the things you already know like Nginx server,
or explore the ftps server image.

You will need to be able to start your images with the custom environment
variables being passed on from the outside world.

You will need to understand the concept of starting a single binary instead of
a init program like supervisord etc. This will be helpfull for the part of the
subject correction that pretend the binaries stop unfortunately within your
containers, and checking if the kubernetes pods are recreated (restarting the
container or not basically).

You should make the log files available to the outside world. Docker collects
the logs from ther container's stdout and stderr. The next command can be
really useful while debuging the rest of the project's steps.

```
docker logs -f _**container_name**_
```

Always try to undertand the different type of logs a binary can produce for you
and if some debug options can be activated.

### 4) INTERCONNECTING CONTAINERS LOCALLY:

It is possible to get your containers to work with each others without 
deploying your cluster through kubernetes.

#### You could start with your mysql and wordpress containers:

You don't need phpmyadmin container in the way (its tool that makes it easier
to access the database through a friendly graphical interface). You can make
your wordpress website work with only the "_wordpress_" and the "_mysql_"
containers. Knowing its possible will help you go through with less possible
bugs.

#### Steps you can take if you have problem connecting the two properly:

- try to open your browser with localhost:5050

- To make sure you have a good configuration making the communication available
between the two, my suggestion is to first make an hybrid container. It will
contain the mysql server and your wordpress application (with its server etc).
This will allow you to make sure your wordpress app can connect to the mysql
server locally only. this is a good start

- Then you can go back to having two containers like the subjects wants. And
now you will try to make your wordpress app connect to the mysql server through
remote connection.

- use the log redirection you set up.

- activate the debug mode in wp-config.php on the container where wordpress is
installed.

#### Sugestion of the commands that worked for me:

First creat a docker network:
```
docker network create _**my_newtork_name**_
```
Then I suggest you try to build and run:

- your _wordpress_ container (with its own nginx server listening on port 5050)
- your _mysql_ container (mysqld is a server itself)

But make sure you start them in the _**my_network_name**_ you just created.
example:
```
docker run -d --rm --name mysql_cont -p 3306:3306 --network=**my_network_name** mysql ;
docker inspect mysql_cont | grep IPAddress
``` 
_note: the wordpress container should use in its wp-config.php file the address
of the mysql\_cont we just created._

Now ou should be able to connect successfully to your msql container and its
server if you enter in your search engine **localhost:5050**.

### 5) UNDERSTAND AND START MINIKUBE ON YOUR LOCAL MACHINE:

minikube will allow you to deploy your app in a development version of a
cluster.

I personally used the school vm (Ubuntu 18.04.5 LTS as of today).
And i ran minikube using the docker driver:

```
minikube start --vm-driver=docker
```
This implies a couple of things:
- the whole minikube cluster is deployed within a docker container instead of
a VM. In that cluster/container you have all your kubernetes obejectscreated,
and "another docker" is running to run containers inside your pods.
- your minikube ip wont be 127.0.0.1. you need to look into the bridge Docker0.
- instead of running a command like `ssh minikubeip`, you would have to do
```
docker ps
docker exec -it <k8s-minikube_container_name> /bin/sh
```

_Tip: doing so i could for example see where my persistent volumes where
mounted._

_TIP: if you do not understand this concept you might be running into problems
like: trying to rebuild images while your cluster is already running, and
realising that the images are not rebuilt. well they are being rebuild, but not
in the correct context for the docker engine.

see:
```
eval $(minikube docker-env)
```
you will need to run your docker (re)build command within the scope that
command was invoked._

### 6) MORE ABOUT KUBERNETES OBJECTS:

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


### 7) CREATING YOUR .YAML FILES, UNDERSTANDING THEIR SYNTHAX:

Those will allow you to deploy your kubernetes objects without manually writing
all the option on the command line interface with kubectl.

_Tip: The indentations in the yaml files represent the dots in the dotted
notation._

_Tip: The kubernetes object always have the same main 2 fields:
- metadata
- spec 
With this in mind you understand that a deployment yaml file contains
inside it another kubernetes object for pods (with again metadata and spec)_

### 8) DEPLOYING DEPLOYMENTS AND EXPOSING THEM WITH SERVICES

It would be a good idea to only validate your ftps, nginx, mysql, phpmyadmin
and wordpress container at this stage. Some adjustements might be needed and
this the part where you will be using your logs for debugs.

Once thoses 5 containers work perfectly and they are all accessible
behind the load balancer, then move on to the telegraf/influxdb/grafana stack.
