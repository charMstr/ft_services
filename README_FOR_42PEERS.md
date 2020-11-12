# OVERVIEW

This is a README.md for my peers working on the same school project at 42.
I intend to give here interesting tips and hints based on my experience on how
to approach this project as it can be complexe to get the big picture at first.

## GOOD APPROACH FROM MY EXPERIENCE

According to my experience on this project, and if i had to redo it, my
approach would be to follow the following list. But also to not be ashamed with
reading other students projects. Its all about configuration, there is no need
to stay stuck for three days because we are missing a line or a character.

### 1) Understanding what is kubernetes.

Kubernetes is a container orchestration tool.
It will allow you to deploy your app in a fragmented way (microservices style).
Basically all the subparts (services or microservices) of your
application will run in separated containers. They inter-communicate and work
together because they are part of a virtual network: your **cluster**.
This cluster can span over different machines, the cloud, or a mixte of both.

One of the most interesting advantage of using a microservices architecture is
the fact that you can update a small part of your app in general, without
stopping the application from running.

### 2) Things you need to understand before working from ground to top.

All you need to know before starting is the concept that when deploying your
cluster, you will need to be able to interconnect your containers together.

For this interconnection to be possible, you will need to master how to run
docker images and passing to then environment variables or arguments, in order
to tune their configuration at boot time.

### 3) Master building your custom images.

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

### 4) interconnecting containers locally.

It is possible to get your containers to work with each others without 
deploying your cluster through kubernetes.

#### You could start with your mysql and wordpress containers.

You don't need phpmyadmin container in the way (its tool that makes it easier
to access the database through a friendly graphical interface). You can make
your wordpress website work with only the "_wordpress_" and the "_mysql_"
containers. Knowing its possible will help you go through with less possible
bugs.

#### steps you can take if you have problem connecting the two properly

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

#### sugestion of the commands that worked for me.

I could finally

I suggest you first creat a docker network:
```
docker network create _**my_newtork_name**_
```
Thenk I suggest you try to build and run:

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

### understand and start minikube on your local machine

minikube will allow you to deploy your app in a cluster that is a small version
reserved for development.

At least be able to creat one kubernetes object with the kubectl cli.

### creating your .yaml files. understanding their synthax

Those will allow you to deploy your kubernetes objects without manually writing
all the option on the command line interface
