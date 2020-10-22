#!/bin/sh
WORK_DIR=`pwd`

#detecting Operating system.
CURRENT_OS=`uname -s`

#starting minikube, either on Linux or Mac osX
echo "starting Minikube on $CURRENT_OS"
if [ $CURRENT_OS = "Linux" ]
then
	minikube start --vm-driver=docker
elif [ $CURRENT_OS = "Darwin" ]; then
	minikube start --vm-driver=virtualbox --disk-size=10g --cpus=3 --memory=2448
else
	echo "Error: current OS not planned in this script to start minikube"
	return		
fi

return

#enable the dashboard
minikube addons enable dashboard
#enable the ingress controller.
minikube addons enable ingress


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
