#!/bin/sh

#START THE MINIKUBE WITH CORRECT VM AND 3 CPUS
minikube start --vm-driver=virtualbox --disk-size=10g --cpus=3 --memory=2448

#MAKE THE DOCKERD AVAILABLE FROM WITHIN THE MINIKUBE
eval $(minikube docker-env)

docker build --rm -t my-nginx .

#enable the dashboard
minikube addons dashboard

docker run --rm -it my-nginx
######################################################################
# FIRST SETUP WHILE RUNNIG POD OBJECTS INSTEAD OF DEPLOYMENTS
######################################################################

#kubectl run --generator=run-pod/v1 --attach=false -i --tty nginx-pod --image=my-nginx --image-pull-policy=Never --port=80

#	expose the service
#kubectl expose pod/nginx-pod --type=NodePort

#	access the webpage straight up.
#minikube service nginx-pod

