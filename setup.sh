#!/bin/sh
WORK_DIR=`pwd`

# function for building my docker images.
build_alpine_docker_images()
{ 
	echo "\n\033[32m building custome alpine images: \033[m"
	for DIR in $(find ./srcs/ -mindepth 1 -maxdepth 1 -type d)
	do	
		DIR=`basename $DIR`
		case $DIR in
			secrets|yaml_files|configmaps|templates_for_cluster_ip) continue;;
		esac
		docker build -t ${DIR}_image srcs/$DIR  2>&1 > /dev/null
		if [ $? != 0 ]
		then
			echo "\033[31m building custom alpine image $IMAGE_NAME failed \033[0m" > /dev/stderr
			exit
		fi
		echo " - \033[32m ${DIR}_image \033[m ✅"
	done
}

#function to start minikube
start_minikube()
{
	# making sure minikube is not already started
	minikube status > /dev/null 2>&1 
	if [ $? -eq 0 ] 
	then
		echo "\033[32m minikube has already been started \033[0m"
		return
	fi	

	#detecting Operating system.
	CURRENT_OS=`uname -s`
	#dfining a custom range (comma separated would not work) that minikube will be using
	PORT_RANGE="--extra-config=apiserver.service-node-port-range=21-5050"

	#starting minikube, either on Linux or Mac osX
	echo "\033[32m starting Minikube on $CURRENT_OS \033[0m"
	if [ $CURRENT_OS = "Linux" ]
	then
		minikube start --vm-driver=docker --cpus=2  $PORT_RANGE
	elif [ $CURRENT_OS = "Darwin" ]; then
		minikube start --vm-driver=virtualbox --disk-size=3g --cpus=3 --memory=2448 $PORT_RANGE
	else
		echo "\033[31m Error: current OS not planned in this script to start minikube \033[0m"
		exit 1
	fi
	if [ $? -gt 0 ]
	then
		echo "\033[31m could not start minikube for OS $CURRENT_OS \033[0m"
		exit 1
	fi
	#enable the dashboard
	minikube addons enable dashboard
	#MAKE THE DOCKERD AVAILABLE FROM WITHIN THE MINIKUBE
	eval $(minikube docker-env)
}

#function to set up metallb (no update of minikube, therefore we dont use the
#minikube addons enable metallb
setup_metallb()
{
	echo "\n\033[32m setting up metallb\033[m"
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml 2>&1 > /dev/null
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml 2>&1 > /dev/null
	# On first install only 
	kubectl get secret -n metallb-system memberlist  > /dev/null 2>&1
	if [ $? != 0 ]
	then
		kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" 2>&1 > /dev/null
	fi
	kubectl apply -f ./srcs/configmaps/metallb_configmap.yaml
}

create_secrets()
{
	# creat all the secrets in that folder
	kubectl apply -f ./srcs/secrets
}

#this will look at the docker0 bridge and give us the next available address
#this way we can be sure to utilize --vm-driver=docker and be in the correct
#subnet range
get_external_ip()
{
	LAST_OCTET=`docker network inspect bridge --format='{{(index .IPAM.Config 0).Gateway}}' | cut -d . -f 4`

	NETWORK_PART=`docker network inspect bridge --format='{{(index .IPAM.Config 0).Gateway}}' | cut -d . -f 1-2`
	CLUSTER_EXTERNAL_IP=${NETWORK_PART}.0.$((LAST_OCTET+1))
}

inject_selected_external_ip()
{
	export CLUSTER_EXTERNAL_IP=$CLUSTER_EXTERNAL_IP
	envsubst '$CLUSTER_EXTERNAL_IP' < srcs/templates_for_cluster_ip/nginx_configmap.yaml > ./srcs/configmaps/nginx_configmap.yaml
}

get_external_ip;
inject_selected_external_ip;
start_minikube;
setup_metallb;
build_alpine_docker_images;
create_secrets;

echo "\033[32m BUILD SUCCESSFUL\033[0m"
echo "your cluster IP is: \033[38;5;187m$CLUSTER_EXTERNAL_IP \033m"

cd ${WORK_DIR}
