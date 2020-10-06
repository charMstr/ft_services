#!/bin/sh
WORK_DIR=`pwd`

#START THE MINIKUBE WITH CORRECT VM AND 3 CPUS
minikube start --vm-driver=virtualbox --disk-size=10g --cpus=3 --memory=2448

#enable the ingress controller.
minikube addons enable ingress

#enable the dashboard
minikube addons enable dashboard

#MAKE THE DOCKERD AVAILABLE FROM WITHIN THE MINIKUBE
eval $(minikube docker-env)

#NGINX
cd ./srcs/Nginx
#build Nginx image. -f option to select the dockerfile
docker build --rm -t my-nginx .
kubectl apply -f Nginx-deployment.yaml
kubectl apply -f Nginx-service.yaml
kubectl apply -f Nginx-ingress.yaml
cd $(WORK_DIR)
