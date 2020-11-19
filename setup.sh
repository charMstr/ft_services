#!/bin/sh
WORK_DIR=`pwd`

# function for building my docker images.
build_images()
{ 
	docker build -t nginx_image ./srcs/nginx
	docker build -t ftps_image ./srcs/ftps
	docker build -t mysql_image ./srcs/mysql
	docker build -t wordpress_image ./srcs/wordpress
	docker build -t phpmyadmin_image ./srcs/phpmyadmin
	#docker build -t influxdb_image ./srcs/influxdb
	#docker build -t grafana_image ./srcs/grafana
}

#function to start minikube
start_minikube()
{
	# making sure minikube is not already started
	minikube status 2>&1 > /dev/null
	if [ $? -eq 0 ] 
	then
		echo "minikube has already been started"
		return
	fi

	#detecting Operating system.
	CURRENT_OS=`uname -s`

	#starting minikube, either on Linux or Mac osX
	echo "starting Minikube on $CURRENT_OS"
	if [ $CURRENT_OS = "Linux" ]
	then
		minikube start --vm-driver=docker --cpus=2
	elif [ $CURRENT_OS = "Darwin" ]; then
		minikube start --vm-driver=virtualbox --disk-size=10g --cpus=3 --memory=2448
	else
		echo "Error: current OS not planned in this script to start minikube"
		exit 1
	fi
	if [ ! $? ]
	then
		echo "could not start minikube for OS $CURRENT_OS"
		exit 1
	fi
	#enable the dashboard
	minikube addons enable dashboard
	#MAKE THE DOCKERD AVAILABLE FROM WITHIN THE MINIKUBE
	eval $(minikube docker-env)
}

create_secrets()
{
	# creat all the secrets in that folder
	kubectl apply -f ./srcs/secrets
}

start_minikube;
build_images;
create_secrets;

######################   remove me later ####################################################
exit


cd $(WORK_DIR)
