#!/bin/sh

#START THE MINIKUBE WITH CORRECT VM AND 3 CPUS
minikube start --vm-driver=virtualbox --disk-size=10g --cpus=3 --memory=2448

#MAKE THE DOCKERD AVAILABLE FROM WITHIN THE MINIKUBE
eval $(minikube docker-env)

docker build --rm -t my-ftps .

######################################################################
# FIRST SETUP WHILE RUNNIG POD OBJECTS INSTEAD OF DEPLOYMENTS
######################################################################

#kubectl run --generator=run-pod/v1 --attach=false -i --tty nginx-pod --image=my-nginx --image-pull-policy=Never --port=80

#	expose the service
#kubectl expose pod/nginx-pod --type=NodePort

#	access the webpage straight up.
#minikube service nginx-pod


######################################################################
# THINGS I HAD TO CHANGE TO MAKE IT USABLE IN A YAML FILE
######################################################################

#	no more need to use the --attach=false -i --tty since in the Dockerfile itself
#	we created an infinite loop process.
#kubectl run --generator=run-pod/v1 nginx-pod --image=my-nginx --image-pull-policy=Never --port=80
#kubectl apply -f Nginx-deployment.yaml

#	now we dont run a pod. but creat a deployment object.
#kubectl expose deployment.apps/nginx-deployment --type=NodePort

#kubectl expose deployment.apps/nginx-deployment --type=NodePort

#If you want to access the website straight away.
#minikube service nginx-deployment

######################################################################
# THINGS I HAD TO CHANGE TO MAKE IT PROPER.
######################################################################

kubectl apply -f Nginx-deployment.yaml

#now no more need to give the --type=NodePort, the ingress will do the job
# the default type will be clusterIP, Ip internal to the cluster.
kubectl apply -f Nginx-service.yaml

kubectl apply -f Nginx-ingress.yaml

open http://`minikube ip`
